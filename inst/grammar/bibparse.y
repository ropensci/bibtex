%{
/*{{{ first part of declarations */
#include <bibtex.h>

char		yytext[BIBYYLMAX];
// #define YYDEBUG		1		/* need for -d option support */
#define YYERROR_VERBOSE 1  /* better warning messages */
#define YYSTYPE		SEXP    /* semantic values */
#define streql(s, t)	(!strcmp((s), (t)))

/**
 * Aliases to R standard PROTECT macro, in case we want to do 
 * something else as well
 */
#define _PROTECT_WITH_INDEX(s,index) { PROTECT_WITH_INDEX(s,index);  } 
#define _PROTECT(s) { PROTECT(s); }
#define _UNPROTECT(n) { UNPROTECT(n);  }
#define _UNPROTECT_PTR(s) { UNPROTECT_PTR(s);  }
#define _REPROTECT(s,index) REPROTECT(s,index)

/**
 * Set to 1 when a syntax error was seen to indicate that 
 * tokens supplied by the lexer should not be wrapped into SEXP
 */
static int recovering ;                             

/**
 * Set to 1 after a syntax error was seen, and before the 
 * recovering process has started
 */
static int popping ; 

/**
 * used in the popping mechanism, the error message is compared to this
 * and the popping stops if anything else happens
 */ 
const char* error_msg_popping = "Error: popping";

/** 
 * The keyname of the current entry (used in warning messages)
 */
static char* currentKey = 0 ; 

/**
 * the line number where the current entry starts (used in warning messages)
 */
int currentKeyLine ;

static SEXP srcfile;
char * bibfile ; 

/** 
 * this is defined as a macro, so that it has access to yylval to be able
 * to unprotect it. 
 * 
 * the macro sets the "popping" to 1 to indicate that symbols being 
 * destructed should be UNPROTECT'ed as well, and calls the _yyerror 
 * function which sends an R warning with the problem
 */
#define yyerror(s) \
do { \
	popping = 1; \
	_yyerror(s); \
} \
while(0) ;

extern YYLTYPE yylloc ;

# define YYLLOC_DEFAULT(Current, Rhs, N)				\
	do	{ 								\
		if (YYID (N)){								\
		  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
		  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
		  (Current).first_byte   = YYRHSLOC (Rhs, 1).first_byte;	\
		  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
		  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
		  (Current).last_byte    = YYRHSLOC (Rhs, N).last_byte;		\
		} else	{								\
		  (Current).first_line   = (Current).last_line   =		\
		    YYRHSLOC (Rhs, 0).last_line;				\
		  (Current).first_column = (Current).last_column =		\
		    YYRHSLOC (Rhs, 0).last_column;				\
		  (Current).first_byte   = (Current).last_byte =		\
		    YYRHSLOC (Rhs, 0).last_byte;				\
		} \
	} while (YYID (0))

// #define XXDEBUG 1

/* functions used in the parsing process */
SEXP makeSrcRef(YYLTYPE) ;
static SEXP xx_object_list_1(SEXP);
static SEXP xx_object_list_2(SEXP,SEXP);
static SEXP xx_object(SEXP);
static SEXP xx_atobject_comment(SEXP);
static SEXP xx_atobject_entry(SEXP, YYLTYPE);
static SEXP xx_atobject_include(SEXP);
static SEXP xx_atobject_preamble(SEXP);
static SEXP xx_atobject_string(SEXP);
static SEXP xx_token_entry( SEXP, SEXP);
static SEXP xx_token_entry_empty(SEXP) ;
static SEXP xx_entry_head( SEXP, SEXP) ;
static SEXP xx_entry_head_nokey( SEXP ) ;
static SEXP xx_keyname_key( SEXP) ;
static SEXP xx_keyname_abbrev( SEXP) ;
static SEXP xx_include( SEXP ) ;
static SEXP xx_preamble(SEXP) ;
static SEXP xx_string(SEXP) ;
static SEXP xx_value( SEXP, SEXP) ;
static SEXP xx_assignement_list1(SEXP);
static SEXP xx_assignement_list2(SEXP, SEXP);
static SEXP xx_assignement(SEXP, SEXP);
static SEXP xx_lhs_field( SEXP ) ;
static SEXP xx_lhs_abbrev( SEXP );
static SEXP xx_space( SEXP ); 
static SEXP xx_space_inline( SEXP ) ;
static SEXP xx_space_newline( SEXP ) ;
static SEXP xx_forward( SEXP ) ;
static SEXP xx_null( ) ;
static SEXP xx_expand_abbrev( SEXP ) ;
static SEXP xx_simple_value( SEXP ) ;

static SEXP includes; 
static SEXP comments; 
static SEXP strings; 
static SEXP preamble; 
static SEXP entries; 

static void recordInclude( SEXP ) ;
static void recordComment( SEXP ) ;
static void recordString( SEXP ) ;
static void recordPreamble( SEXP ) ;
static SEXP asVector( SEXP, int ); 
/*}}}*/

/*{{{ Grammar */
%}

%token TOKEN_ABBREV	
%token TOKEN_AT	
%token TOKEN_COMMA
%token TOKEN_COMMENT
%token TOKEN_ENTRY
%token TOKEN_EQUALS	
%token TOKEN_FIELD
%token TOKEN_INCLUDE
%token TOKEN_INLINE	
%token TOKEN_KEY
%token TOKEN_LBRACE
%token TOKEN_LITERAL
%token TOKEN_NEWLINE
%token TOKEN_PREAMBLE
%token TOKEN_RBRACE	
%token TOKEN_SHARP
%token TOKEN_SPACE
%token TOKEN_STRING
%token TOKEN_VALUE
%token TOKEN_UNKNOWN

%nonassoc TOKEN_EQUALS
%left TOKEN_SPACE TOKEN_INLINE TOKEN_NEWLINE
%left TOKEN_SHARP

%destructor { 
	
	/* 
	this handles UNPROTECTING SEXP that are popped when a syntax 
	error is detected. When a syntax error is detected, 
	the following happens : 
		- yyerror is called which sets recovering and popping to 1
		- some symbols are "popped" from the semantic 
			value stack using this destructor, 
			this is: as many symbols as it takes to be back to this rule: 
			
			| error TOKEN_RBRACE
			
			then "popping" is set to 0 so that no more symbols are 
			UNPROTECTED
			
			then, the lexer provides as many tokens as necessary to 
			present the TOKEN_RBRACE token, however tokens are not 
			converted to SEXP because recovering is 1
			
			finally, when TOKEN_RBRACE is seen, recovering is set to 0
			to indicate that tokens should now be converted to SEXP 
			again
			
			The issue is that all symbols (terminals and non terminals
			have to be listed in this destructor. (There probably is 
			a better way)
	*/
	
	if( popping ){
		if( !streql( error_msg_popping, yymsg ) ){
			popping = 0;
		}
	}
} opt_space space single_space assignment assignment_list assignment_lhs value simple_value include preamble entry entry_head string key_name comment TOKEN_ABBREV	 TOKEN_AT	 TOKEN_COMMA TOKEN_COMMENT TOKEN_ENTRY TOKEN_EQUALS	 TOKEN_FIELD TOKEN_INCLUDE TOKEN_INLINE	 TOKEN_KEY TOKEN_LBRACE TOKEN_LITERAL TOKEN_NEWLINE TOKEN_PREAMBLE TOKEN_RBRACE	 TOKEN_SHARP TOKEN_SPACE TOKEN_STRING TOKEN_VALUE TOKEN_UNKNOWN 

%% 
file: opt_space 					  { YYACCEPT; }
	| opt_space object_list opt_space { YYACCEPT; }
	;

object_list: object 						{
			_PROTECT($$ = xx_object_list_1($1));
			_UNPROTECT(1); // $$
		}
		| object_list opt_space object 	{
			_PROTECT($$ = xx_object_list_2($1,$3));
			_UNPROTECT(1); // $$
		}
		;

object:	TOKEN_AT opt_space at_object {
			_PROTECT($$ = xx_object($3));
			_UNPROTECT(1); // $$
		}
		| anything opt_space object {
			/* this eats whatever is between two entries, lexing until 
				a TOKEN_AT is found */
			_PROTECT($$ = xx_forward($3));
			_UNPROTECT(1); // $$
		} 
	;

anything:  TOKEN_ABBREV    { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_COMMA     { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_COMMENT   { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_ENTRY     { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_EQUALS    { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_FIELD     { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_INCLUDE   { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_INLINE    { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_KEY       { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_LBRACE    { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_LITERAL   { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_NEWLINE   { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_PREAMBLE  { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_RBRACE    { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_SHARP     { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_SPACE     { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_STRING    { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_VALUE     { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }
		|  TOKEN_UNKNOWN   { _PROTECT($$ = xx_forward( $1)); _UNPROTECT(1); /* $$ */ }

at_object:	  comment        { _PROTECT($$ = xx_atobject_comment($1));              _UNPROTECT(1); /* $$ */ }
		| entry              { _PROTECT($$ = xx_atobject_entry($1, @$));            _UNPROTECT(1); /* $$ */ }
		| include            { _PROTECT($$ = xx_atobject_include($1));              _UNPROTECT(1); /* $$ */ }
		| preamble           { _PROTECT($$ = xx_atobject_preamble($1));             _UNPROTECT(1); /* $$ */ }
		| string             { _PROTECT($$ = xx_atobject_string($1));               _UNPROTECT(1); /* $$ */ }
		| error TOKEN_RBRACE { _PROTECT($$ = xx_null()); YYUSE($2); recovering = 0; _UNPROTECT(1); /* $$ */ }
		;

comment:	  TOKEN_COMMENT opt_space TOKEN_LITERAL {
			_PROTECT($$ = xx_forward($3));
			_UNPROTECT(1); // $$
		}
		;

entry:	  entry_head assignment_list TOKEN_RBRACE 						    {
			_PROTECT($$ = xx_token_entry( $1, $2));
			_UNPROTECT(1); // $$
		}
		| entry_head assignment_list TOKEN_COMMA opt_space TOKEN_RBRACE 	{
			_PROTECT($$ = xx_token_entry( $1, $2));
			_UNPROTECT(1); // $$
		}
		| entry_head TOKEN_RBRACE 											{
			_PROTECT($$ = xx_token_entry_empty($1));
			_UNPROTECT(1); // $$
		}
		;

entry_head:	  TOKEN_ENTRY opt_space TOKEN_LBRACE opt_space key_name opt_space TOKEN_COMMA opt_space {
			_PROTECT($$ = xx_entry_head( $1, $5));
			_UNPROTECT(1); // $$
		}
		| TOKEN_ENTRY opt_space TOKEN_LBRACE opt_space TOKEN_COMMA opt_space {
			_PROTECT($$ = xx_entry_head_nokey($1));
			_UNPROTECT(1); // $$
		}
		;

key_name:	  TOKEN_KEY 	{
			_PROTECT($$ = xx_keyname_key($1));
			_UNPROTECT(1); // $$
		}
		| TOKEN_ABBREV 		{
			_PROTECT($$ = xx_keyname_abbrev( $1));
			_UNPROTECT(1); // $$
		}
		;

include:	  TOKEN_INCLUDE opt_space TOKEN_LITERAL {
			_PROTECT($$ = xx_include($3));
			_UNPROTECT(1); // $$
		}
		;

preamble:	  TOKEN_PREAMBLE opt_space TOKEN_LBRACE opt_space value opt_space TOKEN_RBRACE {
			_PROTECT($$ = xx_preamble($5));
			_UNPROTECT(1); // $$
		}
		;

string:		  TOKEN_STRING opt_space TOKEN_LBRACE opt_space assignment opt_space TOKEN_RBRACE {
			_PROTECT($$ = xx_string($5));
			_UNPROTECT(1); // $$
		}
		;

value:	  	  simple_value {
			_PROTECT($$ = xx_forward($1));
			_UNPROTECT(1); // $$
		}
		| value opt_space TOKEN_SHARP opt_space simple_value {
			_PROTECT($$ = xx_value( $1, $5));
			_UNPROTECT(1); // $$
		}
		;

simple_value:	  TOKEN_VALUE { _PROTECT($$ = xx_simple_value($1)); _UNPROTECT(1); }
		| TOKEN_ABBREV { _PROTECT($$ = xx_expand_abbrev($1)); _UNPROTECT(1); }
		;

assignment_list:  assignment 								{
			_PROTECT($$ = xx_assignement_list1($1));
			_UNPROTECT(1); // $$
		}
		| assignment_list TOKEN_COMMA opt_space assignment 	{
			_PROTECT($$ = xx_assignement_list2($1, $4));
			_UNPROTECT(1); // $$
		}
		;

assignment:	  assignment_lhs opt_space TOKEN_EQUALS opt_space value opt_space {
			_PROTECT($$ = xx_assignement($1, $5));
			_UNPROTECT(1); // $$
		}
		;

assignment_lhs:	  TOKEN_FIELD 	{ $$ = xx_lhs_field( $1 ) ; }
		| TOKEN_ABBREV 			{ $$ = xx_lhs_abbrev( $1 ); }
		;

opt_space:							{ $$ = xx_null() ; }
		| space						{ _PROTECT($$ = xx_forward($1)); _UNPROTECT(1); }
		;

space:	single_space				{ _PROTECT($$ = xx_forward($1)); _UNPROTECT(1); }
		| space single_space		{
			_PROTECT($$ = xx_forward($1));
			_UNPROTECT(1); // $$
		}
		;

single_space:	  TOKEN_SPACE		{ _PROTECT($$ = xx_space( $1 ));         _UNPROTECT(1); }
		| TOKEN_INLINE				{ _PROTECT($$ = xx_space_inline( $1 ));  _UNPROTECT(1); }
		| TOKEN_NEWLINE				{ _PROTECT($$ = xx_space_newline( $1 )); _UNPROTECT(1); }
		;
%%

/*}}} end of grammar */


/*{{{ functions borrowed from gram.y */
#ifdef Win32
static char * fixmode(const char *mode){
    /* Rconnection can have a mode of 4 chars plus a null; we might
     * add one char */
    static char fixedmode[6];
    fixedmode[4] = '\0';
    strncpy(fixedmode, mode, 4);
    if (!strpbrk(fixedmode, "bt")) {
		strcat(fixedmode, "t");
    }
    return fixedmode;
}

#else
#define fixmode(mode) (mode)
#endif

FILE * _fopen(const char *filename, const char *mode){
    return(filename ? fopen(filename, fixmode(mode)) : NULL );
}
/*}}}*/

/*{{{ yyerror */
void _yyerror(const char *s){
	warning( "\n%s:%d:%d\n\t%s\n\tDropping the entry `%s` (starting at line %d) ", 
		bibfile, line_number, col_number, s, currentKey, currentKeyLine ) ;
	
	/* indicates that we are recovering from an error */
	recovering = 1 ;
}
/*}}}*/

/*{{{ yywarning */
static void yywarning(const char *s){
	warning( "\n%s:%d:%d\n\t%s", bibfile, line_number, col_number, s ) ;
}
/*}}}*/

/*{{{ R interface */
/**
 * .Internal( "do_read_bib", file = file )
 */
SEXP do_read_bib(SEXP args) {
	SEXP filename = CADR(args) ;
	const char* fname = CHAR(STRING_ELT(filename,0) ) ;
	bibfile = (char*)fname ;
	
	const char* encoding = CHAR(STRING_ELT( CADDR(args), 0 ) ); 
	known_to_be_latin1 = known_to_be_utf8 = FALSE;
	if(streql(encoding, "latin1")) {
		known_to_be_latin1 = TRUE;
	} else if(streql(encoding, "UTF-8"))  {
		known_to_be_utf8 = TRUE;
	} else if(!streql( encoding, "unknown") ){
		warning( "encoding '%s' will be ignored", encoding ) ;
	}
	
	srcfile = CADDDR(args);
	
	FILE* fp ;
	if((fp = _fopen(R_ExpandFileName( fname ), "r")) == NULL){
		error( "unable to open file to read", 0);
	}
	yyset_in( fp ) ; /* so that the lexer reads from the file */
#if YYDEBUG
	yydebug = 0 ;    /* setting this to 1 gives a lot of messages */
#endif
	popping = 0; 
	line_number = 1;
	col_number = 0; 
	byte_number = 0; 
	/* set up the data */
	_PROTECT(includes = NewList());
	_PROTECT(comments = NewList());
	_PROTECT(strings  = NewList());
	_PROTECT(preamble = NewList());
	_PROTECT(entries  = NewList());
	
	/* call the parser */
	recovering = 0; 
	/* int res = yyparse() ; */
	yyparse() ;
	
	/* structure the data */
	SEXP ans; 
	if( isNull( CDR(entries) ) ){
		PROTECT( ans = allocVector( VECSXP, 0)  ) ;
	} else {
		PROTECT( ans = CDR(entries) )  ;
	}
	SEXP obj ;
	_PROTECT(obj = asVector( comments, 0 ) ); setAttrib( ans , install("comment") , obj ); _UNPROTECT(1) ; // obj
	_PROTECT(obj = asVector( includes, 0 ) ); setAttrib( ans , install("include") , obj ); _UNPROTECT(1) ; // obj
	_PROTECT(obj = asVector( strings , 1 ) ); setAttrib( ans , install("strings") , obj ); _UNPROTECT(1) ; // obj
	_PROTECT(obj = asVector( preamble, 0 ) ); setAttrib( ans , install("preamble"), obj ); _UNPROTECT(1) ; // obj
	_UNPROTECT(6); // ans, entries, preamble, strings, comments, includes

	fclose(fp);
	
	return ans ;
}
/*}}}*/

/*{{{ xx_* parser helpers */
 
/** 
 * Object list with one object
 * 
 * @param object the object
 */
static SEXP xx_object_list_1(SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_object_list_1>\n" ) ;
#endif
	SEXP ans, tmp ;
	_PROTECT( tmp = NewList() ) ;
	if( object == R_NilValue) {
		_PROTECT( ans = tmp ) ;
	} else{
		_PROTECT( ans = GrowList( tmp, object) ) ;
	}
#ifdef XXDEBUG
	Rprintf( "</xx_object_list_1>\n" ) ;
#endif
	_UNPROTECT(2); // ans, tmp
	return ans ;
}

/** 
 * Adds an object to an object list
 * 
 * @param 
 */
static SEXP xx_object_list_2(SEXP list, SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_object_list_2>\n" ) ;
#endif
	SEXP ans ;
	if( object == R_NilValue ){
		_PROTECT( ans = list );
	} else{
		_PROTECT( ans = GrowList( list, object ) );
	}
#ifdef XXDEBUG
	Rprintf( "</xx_object_list_2>\n" ) ;
#endif
	_UNPROTECT(1); // ans,
	return ans ; 
}

/** 
 * recognizes an object, adds it to the list of entries
 *
 * @param object object
 */
static SEXP xx_object(SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_aobject>\n" ) ;
#endif
	SEXP ans; 
	_PROTECT( ans = object ) ;
	_UNPROTECT(1); // ans
#ifdef XXDEBUG
	Rprintf( "</xx_aobject>\n" ) ;
#endif

	return ans ;
}

/**
 * Comment object
 * 
 * @param object
 */
static SEXP xx_atobject_comment(SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_atobject_comment>\n" ) ;
#endif
	SEXP ans; 
	_PROTECT( ans = R_NilValue ) ; 
	recordComment( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_comment>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans ; 
}

/**
 * Entry object
 *
 * @param object the entry object
 */
static SEXP xx_atobject_entry(SEXP object, YYLTYPE loc){
#ifdef XXDEBUG
	Rprintf( "<xx_atobject_entry>\n" ) ;
#endif
	SEXP ans, head, o, names; 
	_PROTECT( head = getAttrib( object, install("head") ) ); 
	int n = length( object ) ;
	_PROTECT( ans   = allocVector( STRSXP, n) ) ;
	_PROTECT( names = allocVector( STRSXP, n) ) ;
	
	_PROTECT( o = object ) ; 
	int i;
	for( i=0; i<n; i++){
		SET_STRING_ELT( ans  , i, STRING_ELT(CAR(o),0) ) ;
		SET_STRING_ELT( names, i, STRING_ELT(getAttrib(CAR(o), install("names")),0) ) ;
		o = CDR(o ) ;
	}
	_UNPROTECT(1); // o
	
	SEXP entry ;
	_PROTECT( entry = allocVector( STRSXP, 1 ) ) ;
	SET_STRING_ELT( entry  , 0, STRING_ELT(head, 1) ) ;
	
	SEXP h ;
	_PROTECT( h = allocVector( STRSXP, 1 ) ) ;
	SET_STRING_ELT( h  , 0, STRING_ELT(head, 0) ) ;
	
	setAttrib( ans, install( "entry"), entry ) ;
	setAttrib( ans, install( "names"), names ) ;
	setAttrib( ans, install( "key"), h ) ;
	
	_UNPROTECT( 3 ) ; // entry, h, names
	
	SEXP res; 
	_PROTECT( res = GrowList( entries , ans ) ) ;
	_UNPROTECT( 1 ) ; // res
	
	SEXP srcref ; 
	_PROTECT( srcref = makeSrcRef( loc ) );
	setAttrib( ans, install( "srcref"), srcref );
	_UNPROTECT( 1 ) ; // srcref
	
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_entry>\n" ) ;
#endif
	_UNPROTECT( 2 ) ; // ans, head
	_PROTECT( ans = R_NilValue ); 
	_UNPROTECT(1); // ans
	return ans ;
}

/** 
 * Include object
 *
 * @param object the include object
 */
static SEXP xx_atobject_include(SEXP object ){
#ifdef XXDEBUG
	Rprintf( "<xx_atobject_include>\n" ) ;
#endif
	SEXP ans ;
	_PROTECT( ans = R_NilValue ) ;
	recordInclude( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_include>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans ;
}

/** 
 * A preamble object
 */ 
static SEXP xx_atobject_preamble(SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_atobject_preamble>\n" ) ;
#endif
	SEXP ans ;
	_PROTECT( ans = R_NilValue ) ;
	recordPreamble( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_preamble>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans ;
}

/** 
 * string object
 */ 
static SEXP xx_atobject_string(SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_atobject_string>\n" ) ;
#endif
	SEXP ans ;
	_PROTECT( ans = R_NilValue ) ;
	recordString( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_string>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans ; 
}

/** 
 * actual entry object
 *
 * @param head the entry head
 * @param list the assignement list
 */ 
static SEXP xx_token_entry( SEXP head, SEXP list){
#ifdef XXDEBUG
	Rprintf( "<xx_token_entry>\n" ) ;
#endif
	SEXP data ;
	_PROTECT( data = CDR(list) )  ;
	setAttrib( data, install("head"), head) ;
#ifdef XXDEBUG
	Rprintf( "</xx_token_entry>\n" ) ;
#endif
	_UNPROTECT(1); // data
	return data; 
}

/** 
 * actual entry object with no assignements
 *
 * @param head
 */
static SEXP xx_token_entry_empty(SEXP head){
#ifdef XXDEBUG
	Rprintf( "<xx_token_entry_empty>\n" ) ;
#endif
	SEXP ans; 
	_PROTECT( ans = R_NilValue ) ;
	setAttrib( ans, install("head"), head) ;
#ifdef XXDEBUG
	Rprintf( "</xx_token_entry_empty>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans; 
}

/** 
 * entry head
 *
 * @param kind kind of entry
 * @param keyname the name of the entry
 */
static SEXP xx_entry_head( SEXP kind, SEXP keyname ){
#ifdef XXDEBUG
	Rprintf( "<xx_entry_head>\n" ) ;
#endif
	SEXP ans ;
	_PROTECT( ans = allocVector( STRSXP, 2) ) ;
	SET_STRING_ELT( ans, 0, STRING_ELT(keyname, 0) ) ;
	SET_STRING_ELT( ans, 1, STRING_ELT(kind, 0) ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_entry_head>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans ;
}  
   
/** 
 * entry head
 *
 * @param kind kind of entry
 */
static SEXP xx_entry_head_nokey( SEXP kind){
#ifdef XXDEBUG
	Rprintf( "<xx_entry_head>\n" ) ;
#endif
	SEXP ans ;
	_PROTECT( ans = allocVector( STRSXP, 2) ) ;
	SET_STRING_ELT( ans, 0, NA_STRING ) ;
	SET_STRING_ELT( ans, 1, STRING_ELT(kind, 0) ) ;
	warning( "\n%s:%d:%d\n\tno key for the entry at line %d", 
			bibfile, line_number, col_number, currentKeyLine ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_entry_head>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans ;
}  

/** 
 * sets the currentKey as the first element of the 'key' parameter
 * and returns currentKey
 */
char* set_current_key( SEXP key ){
	// free currentKey if needed 
	if( currentKey ) free( currentKey ) ;
	
	// grab the first element of key
	currentKey = ( length( key ) > 0 ) ? strdup( CHAR( STRING_ELT(key,0) ) ) : 0 ;
	return currentKey ;
}

/** 
 * name of an entry
 *
 * @param key keyname
 */
static SEXP xx_keyname_key( SEXP key){
#ifdef XXDEBUG
	Rprintf( "<xx_keyname_key/>\n" ) ;
#endif
	currentKey = set_current_key( key ) ;
	currentKeyLine = line_number ;
	return key; 
}

/** 
 * name of an entry
 */ 
static SEXP xx_keyname_abbrev( SEXP abbrev){
	SEXP res =  xx_expand_abbrev( abbrev ) ;
	currentKey = set_current_key( abbrev ) ; 
	currentKeyLine = line_number ;
	return res; 
}

/**
 * "include" object
 *
 * @param object
 */ 
static SEXP xx_include( SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_include/>\n" ) ;
#endif
	return object ;
}

/** 
 * preamble object
 *
 * @param object preamble object
 */
static SEXP xx_preamble(SEXP value){
#ifdef XXDEBUG
	Rprintf( "<xx_preamble/>\n" ) ;
#endif
	return value; 
}

/**
 * string object
 *
 * @param object the assignement
 */
static SEXP xx_string(SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_string/>\n" ) ;
#endif
	return object ;
}

/** 
 * value, paste( left, right , sep = "" )
 *
 * @param 
 */
static SEXP xx_value( SEXP left , SEXP right ){
#ifdef XXDEBUG
	Rprintf( "<xx_value>\n" ) ;
#endif
	SEXP ans;
	const char* left_ = CHAR( STRING_ELT( left, 0) ) ;
	const char* right_ = CHAR( STRING_ELT( right, 0) ) ;
	int n_left = strlen( left_);
	int n_right = strlen( right_);
	int n = n_left + n_right ;
	char res[n] ;
	int i, j;
	for( i=0; i<n_left; i++){
		res[i] = left_[i] ;
	}
	for( j=0; j<n_right; j++, i++){
		res[i] = right_[j] ;
	}
	
	_PROTECT( ans = allocVector( STRSXP, 1) ) ;
	SET_STRING_ELT( ans, 0, STRING_ELT( mkString2( res, n_left + n_right ), 0) ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_value>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans ;
}

/** 
 * creates a new assignement list
 *
 * @param object assignement object
 */
static SEXP xx_assignement_list1(SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_assignement_list1>\n" ) ;
#endif
	SEXP ans, tmp; 
	_PROTECT( tmp = NewList( ) ) ;
	_PROTECT( ans = GrowList( tmp, object) ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_assignement_list1>\n" ) ;
#endif
	_UNPROTECT(2); // ans, tmp
	return ans ;
}

/**
 * Augments an assignement list with a new assignement
 *
 * @param list assignement list
 * @param object new assignement
 */
static SEXP xx_assignement_list2(SEXP list, SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_assignement_list2>\n" ) ;
#endif
	SEXP ans ;
	_PROTECT( ans = GrowList( list, object) ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_assignement_list2>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans; 
}

/**
 * assignement                
 *
 * @param lhs left side
 * @param value value
 */
static SEXP xx_assignement(SEXP lhs, SEXP value){
#ifdef XXDEBUG
	Rprintf( "<xx_assignement>\n" ) ;
#endif
	SEXP ans;
	_PROTECT( ans = value ) ;
	setAttrib( ans, install("names"), lhs ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_assignement>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans; 
}

/**
 * field lhs
 *
 * @param field 
 */
static SEXP xx_lhs_field( SEXP field){
#ifdef XXDEBUG
	Rprintf( "<xx_lhs_field/>\n" ) ;
#endif
	return field ;
}

static SEXP xx_lhs_abbrev( SEXP abbrev){
	return xx_expand_abbrev( abbrev ) ;
}


static SEXP xx_space( SEXP s ){
#ifdef XXDEBUG
	Rprintf( "<xx_space/>\n" ) ;
#endif
	return s ;
}

static SEXP xx_space_inline( SEXP s ){
#ifdef XXDEBUG
	Rprintf( "<xx_space_inline/>\n" ) ;
#endif
	return s ;
}

static SEXP xx_space_newline( SEXP s ){
#ifdef XXDEBUG
	Rprintf( "<xx_space_newline/>\n" ) ;
#endif
	return s ;
}

static SEXP xx_forward( SEXP s ){
#ifdef XXDEBUG
	Rprintf( "<xx_forward/>\n" ) ;
#endif
	return s ;
}

static SEXP xx_simple_value( SEXP s ){
#ifdef XXDEBUG
	Rprintf( "<xx_simple_value>\n" ) ;
#endif
	SEXP ans;
	/* all of what follows simply removes the " from the start and the end
	  of the value, it might be better to do this in the lexer instead */
	const char* data = CHAR( STRING_ELT( s, 0 ) ); 
	int n = strlen(data);
	if( n >= 2) {
		char first = data[0]; 
		char last = data[n-1];
		if( first == '"' && last == '"' ){
			_PROTECT( ans = allocVector( STRSXP, 1 ) ); 
			if( n == 2 ){
				SET_STRING_ELT( ans, 0, mkChar("") ) ;	
			} else {
				char noquote[n-2] ;
				for( int i=1; i<n-1; i++){
					noquote[i-1] = data[i] ;
				}
				SET_STRING_ELT( ans, 0, mkCharLen(noquote, n-2) ) ;
			}
		} else{
			_PROTECT( ans = s ) ;
		}
	} else{
		_PROTECT( ans = s ) ;
	}
#ifdef XXDEBUG
	Rprintf( "</xx_simple_value>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans ;
}



static SEXP xx_null( ){
#ifdef XXDEBUG
	Rprintf( "<xx_null>\n" ) ;
#endif
	SEXP ans; 
	_PROTECT( ans = R_NilValue ); 
#ifdef XXDEBUG
	Rprintf( "</xx_null>\n" ) ;
#endif
	_UNPROTECT(1); // ans
	return ans;
}

/*}}}*/

/*{{{ various record functions */
static void recordInclude( SEXP object ){
	SEXP tmp ;
	_PROTECT( tmp = GrowList( includes, object ) ); 
	_UNPROTECT( 1 ) ; // tmp
}

static void recordComment( SEXP object ){
	SEXP tmp ;
	_PROTECT( tmp = GrowList( comments, object ) ); 
	_UNPROTECT( 1 ) ; // tmp
}
static void recordString( SEXP object ){
	SEXP tmp ;
	_PROTECT( tmp = GrowList( strings, object ) ); 
	_UNPROTECT( 1 ) ; // tmp
}
static void recordPreamble( SEXP object ){
	SEXP tmp ;
	_PROTECT( tmp = GrowList( preamble, object ) ); 
	_UNPROTECT( 1 ) ; // tmp
}

static SEXP xx_expand_abbrev( SEXP abbrev ){
	SEXP ans, tmp ;
	/* use the abbreviation name by default */
	_PROTECT( ans = allocVector( STRSXP, 1 ) ) ;
	SET_STRING_ELT( ans, 0, STRING_ELT( abbrev, 0) ) ;
	
	_PROTECT( tmp = CDR(strings) ) ;
	int n = length( tmp ) ;
	const char * target = CHAR( STRING_ELT( abbrev, 0) ) ;
	SEXP item ;
	for(int i=0; i<n; i++){
		item = CAR(tmp);
		if( streql( CHAR( STRING_ELT( getAttrib( item, install("names") ), 0 ) ) , target ) ){
				SET_STRING_ELT( ans, 0, STRING_ELT( item, 0) ) ;
				break ;
		};
		tmp = CDR( tmp ) ;
	}
	_UNPROTECT(2); // tmp, ans
	return ans ;
}

/*}}}*/
                  
/*{{{ setToken */
/** 
 * Called from the lexer to make a SEXP of the token
 *
 * @param token the token we make a SEXP from
 * @param len number of characters of the token
 */
void setToken( const char* token, int len ){
	if( recovering ){
#ifdef XXDEBUG
		Rprintf( "recovering (%d): %s\n", recovering, token ) ;
#endif
		recovering++; 
	} else{
		_PROTECT( yylval = mkString2(token,  len) ) ;
		yylloc.first_line   = start_line_number ;
		yylloc.first_column = start_col_number ;
		yylloc.first_byte   = start_byte_number ;
		yylloc.last_line    = line_number ;
		yylloc.last_column  = col_number ;
		yylloc.last_byte    = byte_number ;
		_UNPROTECT(1); // yylval
	}
}

/** 
 * utility to make a STRSXP
 *
 * @param s character string
 * @param len number of characters
 */
SEXP mkString2(const char *s, int len){
    SEXP t;
    cetype_t enc = CE_NATIVE;
    _PROTECT(t = allocVector(STRSXP, 1));
    SET_STRING_ELT(t, 0, mkCharLenCE(s, len, enc));
    _UNPROTECT(1); // t
    return t;
}
/*}}}*/

/*{{{ asVector */
/**
 * list( a = "aa", b = "bb") -> c( a = "aa", b = "bb" ) 
 */
static SEXP asVector( SEXP x, int donames){
	SEXP ans, names = R_NilValue ; 
	SEXP tmp ;
	int n = length( CDR(x) ) ;
	_PROTECT( ans   = allocVector( STRSXP, n) ) ;
	if( donames ){
		_PROTECT( names = allocVector( STRSXP, n) ) ;
	}
	SEXP item; 
	_PROTECT( tmp = CDR( x ) );
	for( int i=0; i<n; i++){
		item = CAR(tmp); 
		SET_STRING_ELT( ans  , i, STRING_ELT(item, 0) ) ;
		if( donames){
			SET_STRING_ELT( names, i, STRING_ELT( getAttrib(item, install("names") ), 0) ) ;
		}
		tmp = CDR(tmp);
	}
	_UNPROTECT(1) ; // tmp
	if( donames ){
		setAttrib( ans, install("names"), names ) ;
		_UNPROTECT(1); // names
	}
	_UNPROTECT(1); // ans
	return ans; 
}
/*}}}*/

SEXP makeSrcRef(YYLTYPE loc){
	/* the '+ 1' here adjust the columns and bytes to 
look like the srcref class of R that does 
not work with offsets 
	*/
	SEXP ans; 
	_PROTECT( ans = allocVector( INTSXP, 6) ) ;
	INTEGER(ans)[0] = last_at_location.first_line; 
	INTEGER(ans)[1] = last_at_location.first_byte + 1; 
	INTEGER(ans)[2] = loc.last_line; 
	INTEGER(ans)[3] = loc.last_byte + 1; 
	INTEGER(ans)[4] = last_at_location.first_column + 1; 
	INTEGER(ans)[5] = loc.last_column + 1; 
	setAttrib( ans, install("srcfile"), srcfile ) ;
	SEXP srcref_str;
	_PROTECT(srcref_str = mkString2( "srcref", 6 ));
	setAttrib( ans, install("class"), srcref_str);
	_UNPROTECT(2); // srcref_str, ans
	return ans ;
}

void dummy_bibparse(){
	yywarning( "" ) ;
}


/* :tabSize=4:indentSize=4:noTabs=false:folding=explicit:collapseFolds=1: */


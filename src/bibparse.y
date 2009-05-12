%{
/*{{{ first part of declarations */
#include "bibtex.h" 
char		yytext[BIBYYLMAX];
#define YYDEBUG		1		/* need for -d option support */
#define YYSTYPE		SEXP
#define streql(s, t)	(!strcmp((s), (t)))

/* #define XXDEBUG 1 */ 

/* functions used in the parsing process */
static SEXP xx_object_list_1(SEXP);
static SEXP xx_object_list_2(SEXP,SEXP);
static SEXP xx_object(SEXP);
static SEXP xx_atobject_comment(SEXP);
static SEXP xx_atobject_entry(SEXP);
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
static void xx_result( SEXP );
static SEXP xx_expand_abbrev( SEXP ) ;

/* functions to unprotect one or more SEXP */
void junk1( SEXP); 
void junk2( SEXP, SEXP); 
void junk3( SEXP, SEXP, SEXP); 
void junk4( SEXP, SEXP, SEXP, SEXP); 
void junk5( SEXP, SEXP, SEXP, SEXP, SEXP); 
void junk6( SEXP, SEXP, SEXP, SEXP, SEXP, SEXP); 
void junk7( SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP); 

static PROTECT_INDEX INCLUDE_INDEX ;
static PROTECT_INDEX COMMENT_INDEX ;
static PROTECT_INDEX STRING_INDEX ;
static PROTECT_INDEX PREAMBLE_INDEX ;
static PROTECT_INDEX ENTRIES_INDEX ;

static SEXP includes; 
static SEXP comments; 
static SEXP strings; 
static SEXP preamble; 
static SEXP entries; 

static void recordInclude( SEXP ) ;
static void recordComment( SEXP ) ;
static void recordString( SEXP ) ;
static void recordPreamble( SEXP ) ;
static SEXP asVector( SEXP ); 
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

%%
file:		  opt_space 					{ junk1($1); }
		| opt_space object_list opt_space { xx_result( $2 ) ;junk2($1, $3) ; }
		;

object_list: object 						{ $$ = xx_object_list_1($1);  }
		| object_list opt_space object 	{ $$ = xx_object_list_2($1,$3); junk1($2) ; }
		;

object:	  	  TOKEN_AT opt_space at_object {$$ = xx_object($3); junk2($1,$2); }
		;

at_object:	  comment 						{ $$ = xx_atobject_comment($1); }
		| entry 							{ $$ = xx_atobject_entry($1);}
		| include 							{ $$ = xx_atobject_include($1);}
		| preamble 							{ $$ = xx_atobject_preamble($1);}
		| string							{ $$ = xx_atobject_string($1);}
		| error TOKEN_RBRACE 				{ YYABORT; }
		;

comment:	  TOKEN_COMMENT opt_space TOKEN_LITERAL {junk3($1,$2,$3); }
		;

entry:	  entry_head assignment_list TOKEN_RBRACE 						{ $$ = xx_token_entry( $1, $2); junk1($3); }
		| entry_head assignment_list TOKEN_COMMA opt_space TOKEN_RBRACE 	{ $$ = xx_token_entry( $1, $2); junk3($3,$4,$5); }
		| entry_head TOKEN_RBRACE 											{ $$ = xx_token_entry_empty($1) ; junk1($2) ; }
		;

entry_head:	  TOKEN_ENTRY opt_space TOKEN_LBRACE opt_space key_name opt_space TOKEN_COMMA opt_space { $$ = xx_entry_head( $1, $5) ; junk6($2,$3,$4,$6,$7,$8) ; }
		| TOKEN_ENTRY opt_space TOKEN_LBRACE opt_space TOKEN_COMMA opt_space { $$ = xx_entry_head_nokey( $1) ; junk5($2,$3,$4,$5,$6) ; }
		;

key_name:	  TOKEN_KEY 	{ $$ = xx_keyname_key( $1) ;}
		| TOKEN_ABBREV 		{ $$ = xx_keyname_abbrev( $1) ; }
		;

include:	  TOKEN_INCLUDE opt_space TOKEN_LITERAL { $$ = xx_include( $3 ) ; junk2($1,$2) ; }
		;

preamble:	  TOKEN_PREAMBLE opt_space TOKEN_LBRACE opt_space value opt_space TOKEN_RBRACE { $$ = xx_preamble($5) ; junk6($1,$2,$3,$4,$6,$7) ; }
		;

string:		  TOKEN_STRING opt_space TOKEN_LBRACE opt_space assignment opt_space TOKEN_RBRACE { $$ = xx_string($5) ; junk6( $1, $2, $3, $4, $6, $7) ; }
		;

value:	  	  simple_value {$$ = xx_forward($1) ; }
		| value opt_space TOKEN_SHARP opt_space simple_value { $$ = xx_value( $1, $5) ; junk3( $2, $3, $4);  }
		;

simple_value:	  TOKEN_VALUE { $$ = xx_forward($1); }
		| TOKEN_ABBREV { $$ = xx_expand_abbrev($1); }
		;

assignment_list:  assignment 									{ $$ = xx_assignement_list1($1); }
		| assignment_list TOKEN_COMMA opt_space assignment 	{ $$ = xx_assignement_list2($1, $4); junk2($2,$3); }
		;

assignment:	  assignment_lhs opt_space TOKEN_EQUALS opt_space value opt_space { $$ = xx_assignement($1, $5); junk4($2, $3, $4, $6) }
		;

assignment_lhs:	  TOKEN_FIELD 	{ $$ = xx_lhs_field( $1 ) ; }
		| TOKEN_ABBREV 			{ $$ = xx_lhs_abbrev( $1 ); }
		;

opt_space:							{ $$ = xx_null() ; }
		| space						{ $$ = xx_forward($1) ;}
		;

space:	single_space				{ $$ = xx_forward($1) ;}
		| space single_space		{ $$ = xx_forward($1); junk1($2) ; } 
		;

single_space:	  TOKEN_SPACE		{ $$ = xx_space( $1 ) ; }
		| TOKEN_INLINE				{ $$ = xx_space_inline( $1 ) ; }
		| TOKEN_NEWLINE				{ $$ = xx_space_newline( $1 ) ; }
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
void yyerror(const char *s){}
/*}}}*/

/*{{{ yywarning */
static void yywarning(const char *s){}
/*}}}*/

/*{{{ R interface */
/**
 * .Internal( "do_read_bib", file = file )
 */
// TODO: add an "encoding" argument and deal with it
// TODO: deal with the stack when there is an error
SEXP attribute_hidden do_read_bib(SEXP args){
	SEXP filename = CADR(args) ;
	const char* fname = CHAR(STRING_ELT(filename,0) ) ;
	FILE* fp ;
	if((fp = _fopen(R_ExpandFileName( fname ), "r")) == NULL){
		error( "unable to open file to read", 0);
	}
	yyset_in( fp ) ; /* so that the lexer reads from the file */
	yydebug = 0 ;    /* setting this to 1 gives a lot of messages */
	
	/* set up the data */
	PROTECT_WITH_INDEX( includes = NewList() , &INCLUDE_INDEX ) ;
	PROTECT_WITH_INDEX( comments = NewList() , &COMMENT_INDEX ) ;
	PROTECT_WITH_INDEX( strings  = NewList() , &STRING_INDEX ) ;
	PROTECT_WITH_INDEX( preamble = NewList() , &PREAMBLE_INDEX ) ;
	PROTECT_WITH_INDEX( entries  = R_NilValue, &ENTRIES_INDEX ) ;
	
	/* call the parser */
	yyparse() ;
	
	/* structure the data */
	SEXP obj; 
	PROTECT(obj = asVector( comments ) );  setAttrib( entries, install("comment") , obj ); UNPROTECT_PTR( obj ) ;
	PROTECT(obj = asVector( includes ) );  setAttrib( entries, install("include") , obj ); UNPROTECT_PTR( obj ) ; 
	PROTECT(obj = asVector( strings  ) );  setAttrib( entries, install("strings") , obj ); UNPROTECT_PTR( obj ) ; 
	PROTECT(obj = asVector( preamble ) );  setAttrib( entries, install("preamble"), obj ); UNPROTECT_PTR( obj ) ;
	UNPROTECT_PTR( entries ) ;
	
	return entries ;
}
/*}}}*/

/*{{{ xx_* parser helpers */

/**
 * called at the end
 */
static void xx_result( SEXP objlist ){
	
	SEXP tmp, ans, names; 
	int n = length( CDR(objlist ) ); 
	PROTECT( ans = NewList()) ;
	PROTECT( names = allocVector( STRSXP, n )) ;
	PROTECT( tmp = CDR(objlist) ) ;
	SEXP item; 
	for( int i=0; i<n; i++){
		item = CAR(tmp);
		SET_STRING_ELT( names, i, STRING_ELT( getAttrib(item, install("head") ), 0 ) ); 
		setAttrib( item, install("head"), R_NilValue ) ;
		ans = GrowList( ans, item ) ; 
		tmp = CDR(tmp) ;
	}
	SEXP out ;
	UNPROTECT(1) ;
	PROTECT( out = CDR(ans) );
	UNPROTECT_PTR(ans);
	setAttrib( out, install("names"), names );
	UNPROTECT_PTR(names);
	REPROTECT( entries = out, ENTRIES_INDEX ) ; 
	UNPROTECT_PTR(out) ;
	UNPROTECT_PTR(objlist) ;
}
 
 
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
	PROTECT( tmp = NewList() ) ;
	if( object == R_NilValue) {
		PROTECT( ans = tmp ) ;
	} else{
		PROTECT( ans = GrowList( tmp, object) ) ;
	}
	UNPROTECT_PTR( tmp) ;
	UNPROTECT_PTR( object) ;
#ifdef XXDEBUG
	Rprintf( "</xx_object_list_1>\n" ) ;
#endif
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
		PROTECT( ans = list );
	} else{
		PROTECT( ans = GrowList( list, object ) );
	}
	UNPROTECT_PTR( object ) ;
	UNPROTECT_PTR( list ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_object_list_2>\n" ) ;
#endif
	return ans ; 
}

/** 
 * an object, placeholder
 *
 * @param object object
 */
static SEXP xx_object(SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_aobject>\n" ) ;
#endif
	SEXP ans; 
	PROTECT( ans = object ) ;
	UNPROTECT_PTR( object ) ;
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
	PROTECT( ans = R_NilValue ) ; 
	recordComment( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_comment>\n" ) ;
#endif
	return ans ; 
}

/**
 * Entry object
 *
 * @param object the entry object
 */
static SEXP xx_atobject_entry(SEXP object){
#ifdef XXDEBUG
	Rprintf( "<xx_atobject_entry>\n" ) ;
#endif
	SEXP ans; 
	SEXP head; 
	SEXP o ;
	SEXP names; 
	PROTECT( head = getAttrib( object, install("head") ) ); 
	int n = length( object ) ;
	PROTECT( ans   = allocVector( STRSXP, n) ) ;
	PROTECT( names = allocVector( STRSXP, n) ) ;
	PROTECT( o = object ) ; 
	int i;
	for( i=0; i<n; i++){
		SET_STRING_ELT( ans  , i, STRING_ELT(CAR(o),0) ) ;
		SET_STRING_ELT( names, i, STRING_ELT(getAttrib(CAR(o), install("names")),0) ) ;
		o = CDR(o ) ;
	}
	
	SEXP entry ;
	PROTECT( entry = allocVector( STRSXP, 1 ) ) ;
	SET_STRING_ELT( entry  , 0, STRING_ELT(head, 1) ) ;
	
	SEXP h ;
	PROTECT( h = allocVector( STRSXP, 1 ) ) ;
	SET_STRING_ELT( h  , 0, STRING_ELT(head, 0) ) ;
	
	setAttrib( ans, install( "entry"), entry ) ;
	setAttrib( ans, install( "names"), names ) ;
	setAttrib( ans, install( "head"), h ) ;
	
	UNPROTECT( 3 ) ; // entry, h, o
	UNPROTECT_PTR( object ); 
	UNPROTECT_PTR( names ); 
	UNPROTECT_PTR( head ) ; 
	
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_entry>\n" ) ;
#endif
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
	PROTECT( ans = R_NilValue ) ;
	recordInclude( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_include>\n" ) ;
#endif
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
	PROTECT( ans = R_NilValue ) ;
	recordPreamble( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_preamble>\n" ) ;
#endif
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
	PROTECT( ans = R_NilValue ) ;
	recordString( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_string>\n" ) ;
#endif
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
	PROTECT( data = CDR(list) )  ;
	setAttrib( data, install("head"), head) ;
	UNPROTECT_PTR( list ) ;
	UNPROTECT_PTR( head ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_token_entry>\n" ) ;
#endif
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
	PROTECT( ans = R_NilValue ) ;
	setAttrib( ans, install("head"), head) ;
	UNPROTECT_PTR( head ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_token_entry_empty>\n" ) ;
#endif
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
	PROTECT( ans = allocVector( STRSXP, 2) ) ;
	SET_STRING_ELT( ans, 0, STRING_ELT(keyname, 0) ) ;
	SET_STRING_ELT( ans, 1, STRING_ELT(kind, 0) ) ;
	UNPROTECT_PTR(kind) ;
	UNPROTECT_PTR(keyname) ;
	
#ifdef XXDEBUG
	Rprintf( "</xx_entry_head>\n" ) ;
#endif
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
	PROTECT( ans = allocVector( STRSXP, 2) ) ;
	SET_STRING_ELT( ans, 0, NA_STRING ) ;
	SET_STRING_ELT( ans, 1, STRING_ELT(kind, 0) ) ;
	UNPROTECT_PTR(kind) ;
	
#ifdef XXDEBUG
	Rprintf( "</xx_entry_head>\n" ) ;
#endif
	return ans ;
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
	return key; 
}

/** 
 * name of an entry
 */ 
static SEXP xx_keyname_abbrev( SEXP abbrev){
	return xx_expand_abbrev( abbrev ) ;
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
	
	PROTECT( ans = allocVector( STRSXP, 1) ) ;
	SET_STRING_ELT( ans, 0, STRING_ELT( mkString2( res, n_left + n_right ), 0) ) ;
	UNPROTECT_PTR( right ) ; 
	UNPROTECT_PTR( left ) ; 
#ifdef XXDEBUG
	Rprintf( "</xx_value>\n" ) ;
#endif
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
	PROTECT( tmp = NewList( ) ) ;
	PROTECT( ans = GrowList( tmp, object) ) ;
	UNPROTECT_PTR( tmp ) ;
	UNPROTECT_PTR( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_assignement_list1>\n" ) ;
#endif
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
	PROTECT( ans = GrowList( list, object) ) ;
	UNPROTECT_PTR( list ) ;
	UNPROTECT_PTR( object ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_assignement_list2>\n" ) ;
#endif
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
	PROTECT( ans = value ) ;
	setAttrib( ans, install("names"), lhs ) ;
	UNPROTECT_PTR( lhs ) ;
	UNPROTECT_PTR( value ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_assignement>\n" ) ;
#endif
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

static SEXP xx_null( ){
#ifdef XXDEBUG
	Rprintf( "<xx_null>\n" ) ;
#endif
	SEXP ans; 
	PROTECT( ans = R_NilValue ); 
#ifdef XXDEBUG
	Rprintf( "</xx_null>\n" ) ;
#endif
	return ans;
}

/*}}}*/

/*{{{ various record functions */
static void recordInclude( SEXP object ){
	SEXP tmp ;
	PROTECT( tmp = GrowList( includes, object ) ); 
	REPROTECT( includes = tmp, INCLUDE_INDEX ) ;
	UNPROTECT_PTR( tmp ) ;
	UNPROTECT_PTR( object ) ;
}

static void recordComment( SEXP object ){
	SEXP tmp ;
	PROTECT( tmp = GrowList( comments, object ) ); 
	REPROTECT( comments = tmp, COMMENT_INDEX ) ;
	UNPROTECT_PTR( tmp ) ;
	
	UNPROTECT_PTR( object ) ;
}
static void recordString( SEXP object ){
	SEXP tmp ;
	PROTECT( tmp = GrowList( strings, object ) ); 
	REPROTECT( strings = tmp, STRING_INDEX ) ;
	UNPROTECT_PTR( tmp ) ;
	UNPROTECT_PTR( object ) ;
}
static void recordPreamble( SEXP object ){
	SEXP tmp ;
	PROTECT( tmp = GrowList( preamble, object ) ); 
	REPROTECT( preamble = tmp, PREAMBLE_INDEX ) ;
	UNPROTECT_PTR( tmp ) ;
	UNPROTECT_PTR( object ) ;
}

static SEXP xx_expand_abbrev( SEXP abbrev ){
	SEXP ans, tmp ;
	/* use the abbreviation name by default */
	PROTECT( ans = allocVector( STRSXP, 1 ) ) ;
	SET_STRING_ELT( ans, 0, STRING_ELT( abbrev, 0) ) ;
	
	PROTECT( tmp = CDR(strings) ) ;
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
	UNPROTECT(1); // tmp
	UNPROTECT_PTR( abbrev ) ;
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
	PROTECT( yylval = mkString2(token,  len) ) ; 
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
    PROTECT(t = allocVector(STRSXP, 1));
    SET_STRING_ELT(t, 0, mkCharLenCE(s, len, enc));
    UNPROTECT(1);
    return t;
}
/*}}}*/

/*{{{ junks */
void junk1( SEXP s){
#ifdef XXDEBUG
	Rprintf( " *~\n" ) ; 
#endif
	UNPROTECT_PTR( s ) ; 
}

void junk2( SEXP s1, SEXP s2){
	junk1(s1);
	junk1(s2); 
}

void junk3( SEXP s1, SEXP s2, SEXP s3){
	junk1(s1);
	junk1(s2);
	junk1(s3);
}

void junk4( SEXP s1, SEXP s2, SEXP s3, SEXP s4){
	junk1(s1);
	junk1(s2);
	junk1(s3);
	junk1(s4);
}


void junk5( SEXP s1, SEXP s2, SEXP s3, SEXP s4, SEXP s5){
	junk1(s1);
	junk1(s2);
	junk1(s3);
	junk1(s4);
	junk1(s5);
}

void junk6( SEXP s1, SEXP s2, SEXP s3, SEXP s4, SEXP s5, SEXP s6){
	junk1(s1);
	junk1(s2);
	junk1(s3);
	junk1(s4);
	junk1(s5);
	junk1(s6);
}

void junk7( SEXP s1, SEXP s2, SEXP s3, SEXP s4, SEXP s5, SEXP s6, SEXP s7){
	junk1(s1);
	junk1(s2);
	junk1(s3);
	junk1(s4);
	junk1(s5);
	junk1(s6);
	junk1(s7);
}
/*}}}*/

/*{{{ asVector */
/**
 * list( a = "aa", b = "bb") -> c( a = "aa", b = "bb" ) 
 */
static SEXP asVector( SEXP x){
	SEXP ans, names ; 
	SEXP tmp ;
	int n = length( CDR(x) ) ;
	PROTECT( ans   = allocVector( STRSXP, n) ) ;
	PROTECT( names = allocVector( STRSXP, n) ) ;
	SEXP item; 
	PROTECT( tmp = CDR( x ) );
	for( int i=0; i<n; i++){
		item = CAR(tmp); 
		SET_STRING_ELT( ans  , i, STRING_ELT(item, 0) ) ;
		SET_STRING_ELT( names, i, STRING_ELT( getAttrib(item, install("names") ), 0) ) ;
		tmp = CDR(tmp);
	}
	UNPROTECT(1) ; // tmp
	setAttrib( ans, install("names"), names ) ;
	UNPROTECT_PTR(names) ;
	UNPROTECT_PTR(x) ; 
	UNPROTECT_PTR(ans) ; 
	return ans; 
}
/*}}}*/

/* :tabSize=4:indentSize=4:noTabs=false:folding=explicit:collapseFolds=1: */




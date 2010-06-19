/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 1



/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TOKEN_ABBREV = 258,
     TOKEN_AT = 259,
     TOKEN_COMMA = 260,
     TOKEN_COMMENT = 261,
     TOKEN_ENTRY = 262,
     TOKEN_EQUALS = 263,
     TOKEN_FIELD = 264,
     TOKEN_INCLUDE = 265,
     TOKEN_INLINE = 266,
     TOKEN_KEY = 267,
     TOKEN_LBRACE = 268,
     TOKEN_LITERAL = 269,
     TOKEN_NEWLINE = 270,
     TOKEN_PREAMBLE = 271,
     TOKEN_RBRACE = 272,
     TOKEN_SHARP = 273,
     TOKEN_SPACE = 274,
     TOKEN_STRING = 275,
     TOKEN_VALUE = 276,
     TOKEN_UNKNOWN = 277
   };
#endif
/* Tokens.  */
#define TOKEN_ABBREV 258
#define TOKEN_AT 259
#define TOKEN_COMMA 260
#define TOKEN_COMMENT 261
#define TOKEN_ENTRY 262
#define TOKEN_EQUALS 263
#define TOKEN_FIELD 264
#define TOKEN_INCLUDE 265
#define TOKEN_INLINE 266
#define TOKEN_KEY 267
#define TOKEN_LBRACE 268
#define TOKEN_LITERAL 269
#define TOKEN_NEWLINE 270
#define TOKEN_PREAMBLE 271
#define TOKEN_RBRACE 272
#define TOKEN_SHARP 273
#define TOKEN_SPACE 274
#define TOKEN_STRING 275
#define TOKEN_VALUE 276
#define TOKEN_UNKNOWN 277




/* Copy the first part of user declarations.  */
#line 1 "bibparse.y"

/*{{{ first part of declarations */
#include "bibtex.h" 

/* Stretchy List Structures : Lists are created and grown using a special */
/* dotted pair.  The CAR of the list points to the last cons-cell in the */
/* list and the CDR points to the first.  The list can be extracted from */
/* the pair by taking its CDR, while the CAR gives fast access to the end */
/* of the list. */

/**
 * Creates a stretchy-list dotted pair
 */ 
SEXP NewList(void) {
    SEXP s = Rf_cons(R_NilValue, R_NilValue);
    SETCAR(s, s);
    return s;
}

/**
 * Add a new element at the __end__ of a stretchy list
 * 
 * @param l stretchy list to expand
 * @param s element to add at the __end__ of the list
 * @return 
 */ 
SEXP GrowList(SEXP l, SEXP s) {
    SEXP tmp;
    PROTECT(s);
    tmp = Rf_cons(s, R_NilValue);
    UNPROTECT(1);
    SETCDR(CAR(l), tmp);
    SETCAR(l, tmp);
    return l;
}

/**
 * Insert a new element at the __head__ of a stretchy list
 * 
 * @param l stretchy list in which we want to insert s
 * @param s element to add to l
 * @return the stretchy list l appended by s
 */ 
SEXP Insert(SEXP l, SEXP s){
    SEXP tmp;
    PROTECT(s);
    tmp = Rf_cons(s, CDR(l));
    UNPROTECT(1);
    SETCDR(l, tmp);
    return l;
}

#define YY_TYPEDEF_YY_SIZE_T
typedef int yy_size_t;

// static char		yytext[BIBYYLMAX];
#define YYDEBUG		1		/* need for -d option support */
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
char * currentKey; 

/**
 * the line number where the current entry starts (used in warning messages)
 */
int currentKeyLine ;

static SEXP srcfile = R_NilValue ;
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
	_UNPROTECT_PTR( yylval ) ; \
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

/* #define XXDEBUG 1 */ 

/* functions used in the parsing process */
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
static SEXP asVector( SEXP, int ); 
/*}}}*/

/*{{{ Grammar */


/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 366 "bibparse.cpp"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
	     && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss;
  YYSTYPE yyvs;
    YYLTYPE yyls;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  8
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   85

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  23
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  21
/* YYNRULES -- Number of rules.  */
#define YYNRULES  59
/* YYNRULES -- Number of states.  */
#define YYNSTATES  101

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   277

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint8 yyprhs[] =
{
       0,     0,     3,     5,     9,    11,    15,    19,    23,    25,
      27,    29,    31,    33,    35,    37,    39,    41,    43,    45,
      47,    49,    51,    53,    55,    57,    59,    61,    63,    65,
      67,    69,    71,    74,    78,    82,    88,    91,   100,   107,
     109,   111,   115,   123,   131,   133,   139,   141,   143,   145,
     150,   157,   159,   161,   162,   164,   166,   169,   171,   173
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      24,     0,    -1,    41,    -1,    41,    25,    41,    -1,    26,
      -1,    25,    41,    26,    -1,     4,    41,    28,    -1,    27,
      41,    26,    -1,     3,    -1,     5,    -1,     6,    -1,     7,
      -1,     8,    -1,     9,    -1,    10,    -1,    11,    -1,    12,
      -1,    13,    -1,    14,    -1,    15,    -1,    16,    -1,    17,
      -1,    18,    -1,    19,    -1,    20,    -1,    21,    -1,    22,
      -1,    29,    -1,    30,    -1,    33,    -1,    34,    -1,    35,
      -1,     1,    17,    -1,     6,    41,    14,    -1,    31,    38,
      17,    -1,    31,    38,     5,    41,    17,    -1,    31,    17,
      -1,     7,    41,    13,    41,    32,    41,     5,    41,    -1,
       7,    41,    13,    41,     5,    41,    -1,    12,    -1,     3,
      -1,    10,    41,    14,    -1,    16,    41,    13,    41,    36,
      41,    17,    -1,    20,    41,    13,    41,    39,    41,    17,
      -1,    37,    -1,    36,    41,    18,    41,    37,    -1,    21,
      -1,     3,    -1,    39,    -1,    38,     5,    41,    39,    -1,
      40,    41,     8,    41,    36,    41,    -1,     9,    -1,     3,
      -1,    -1,    42,    -1,    43,    -1,    42,    43,    -1,    19,
      -1,    11,    -1,    15,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   269,   269,   270,   273,   274,   277,   281,   288,   289,
     290,   291,   292,   293,   294,   295,   296,   297,   298,   299,
     300,   301,   302,   303,   304,   305,   306,   308,   309,   310,
     311,   312,   313,   316,   319,   320,   321,   324,   325,   328,
     329,   332,   335,   338,   341,   342,   345,   346,   349,   350,
     353,   356,   357,   360,   361,   364,   365,   368,   369,   370
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TOKEN_ABBREV", "TOKEN_AT",
  "TOKEN_COMMA", "TOKEN_COMMENT", "TOKEN_ENTRY", "TOKEN_EQUALS",
  "TOKEN_FIELD", "TOKEN_INCLUDE", "TOKEN_INLINE", "TOKEN_KEY",
  "TOKEN_LBRACE", "TOKEN_LITERAL", "TOKEN_NEWLINE", "TOKEN_PREAMBLE",
  "TOKEN_RBRACE", "TOKEN_SHARP", "TOKEN_SPACE", "TOKEN_STRING",
  "TOKEN_VALUE", "TOKEN_UNKNOWN", "$accept", "file", "object_list",
  "object", "anything", "at_object", "comment", "entry", "entry_head",
  "key_name", "include", "preamble", "string", "value", "simple_value",
  "assignment_list", "assignment", "assignment_lhs", "opt_space", "space",
  "single_space", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    23,    24,    24,    25,    25,    26,    26,    27,    27,
      27,    27,    27,    27,    27,    27,    27,    27,    27,    27,
      27,    27,    27,    27,    27,    27,    27,    28,    28,    28,
      28,    28,    28,    29,    30,    30,    30,    31,    31,    32,
      32,    33,    34,    35,    36,    36,    37,    37,    38,    38,
      39,    40,    40,    41,    41,    42,    42,    43,    43,    43
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     3,     1,     3,     3,     3,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     2,     3,     3,     5,     2,     8,     6,     1,
       1,     3,     7,     7,     1,     5,     1,     1,     1,     4,
       6,     1,     1,     0,     1,     1,     2,     1,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
      53,    58,    59,    57,     0,     2,    54,    55,     1,     8,
      53,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    53,
       4,    53,    56,     0,     3,     0,     0,    53,    53,    53,
      53,    53,     6,    27,    28,     0,    29,    30,    31,     5,
       7,    32,     0,     0,     0,     0,     0,    52,    51,    36,
       0,    48,    53,    33,    53,    41,    53,    53,    53,    34,
       0,     0,     0,     0,     0,    53,    40,    53,    39,    53,
      47,    46,    53,    44,    53,    35,    49,     0,    38,     0,
       0,     0,    53,    53,    42,    53,    43,    50,    37,     0,
      45
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     4,    29,    30,    31,    42,    43,    44,    45,    79,
      46,    47,    48,    82,    83,    60,    61,    62,     5,     6,
       7
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -20
static const yytype_int8 yypact[] =
{
      49,   -20,   -20,   -20,     3,    29,    49,   -20,   -20,   -20,
      49,   -20,   -20,   -20,   -20,   -20,   -20,   -20,   -20,   -20,
     -20,   -20,   -20,   -20,   -20,   -20,   -20,   -20,   -20,    49,
     -20,    49,   -20,     0,    29,    29,   -12,    49,    49,    49,
      49,    49,   -20,   -20,   -20,     6,   -20,   -20,   -20,   -20,
     -20,   -20,    -6,    11,    -1,    13,    46,   -20,   -20,   -20,
      -3,   -20,    49,   -20,    49,   -20,    49,    49,    49,   -20,
      55,    50,     1,     9,     8,    49,   -20,    49,   -20,    49,
     -20,   -20,    49,   -20,    49,   -20,   -20,     1,   -20,    56,
      53,    62,    49,    49,   -20,    49,   -20,    48,   -20,     1,
     -20
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -20,   -20,   -20,    41,   -20,   -20,   -20,   -20,   -20,   -20,
     -20,   -20,   -20,   -14,   -19,   -20,     4,   -20,   -10,   -20,
      75
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
      33,    36,    68,     8,    80,    51,    37,    38,    63,    57,
      39,    57,    57,    65,    69,    58,    40,    58,    58,    34,
      41,    35,    81,    59,    64,    85,    66,    52,    53,    54,
      55,    56,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    70,    76,    71,    77,    72,    73,    74,    67,
       1,    93,    78,    75,     2,    87,    95,    88,     3,    89,
      94,    95,    90,    92,    91,    49,    50,    84,    86,    96,
     100,    32,    97,    98,     0,    99
};

static const yytype_int8 yycheck[] =
{
      10,     1,     5,     0,     3,    17,     6,     7,    14,     3,
      10,     3,     3,    14,    17,     9,    16,     9,     9,    29,
      20,    31,    21,    17,    13,    17,    13,    37,    38,    39,
      40,    41,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
      21,    22,    62,     3,    64,     5,    66,    67,    68,    13,
      11,     5,    12,     8,    15,    75,    18,    77,    19,    79,
      17,    18,    82,    87,    84,    34,    35,    73,    74,    17,
      99,     6,    92,    93,    -1,    95
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    11,    15,    19,    24,    41,    42,    43,     0,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,    21,    22,    25,
      26,    27,    43,    41,    41,    41,     1,     6,     7,    10,
      16,    20,    28,    29,    30,    31,    33,    34,    35,    26,
      26,    17,    41,    41,    41,    41,    41,     3,     9,    17,
      38,    39,    40,    14,    13,    14,    13,    13,     5,    17,
      41,    41,    41,    41,    41,     8,     3,     5,    12,    32,
       3,    21,    36,    37,    39,    17,    39,    41,    41,    41,
      41,    41,    36,     5,    17,    18,    17,    41,    41,    41,
      37
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value, Location); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (!yyvaluep)
    return;
  YYUSE (yylocationp);
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yylsp, yyrule)
    YYSTYPE *yyvsp;
    YYLTYPE *yylsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       , &(yylsp[(yyi + 1) - (yynrhs)])		       );
      fprintf (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, yylsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
#else
static void
yydestruct (yymsg, yytype, yyvaluep, yylocationp)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
    YYLTYPE *yylocationp;
#endif
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {
      case 3: /* "TOKEN_ABBREV" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1385 "bibparse.cpp"
	break;
      case 4: /* "TOKEN_AT" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1426 "bibparse.cpp"
	break;
      case 5: /* "TOKEN_COMMA" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1467 "bibparse.cpp"
	break;
      case 6: /* "TOKEN_COMMENT" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1508 "bibparse.cpp"
	break;
      case 7: /* "TOKEN_ENTRY" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1549 "bibparse.cpp"
	break;
      case 8: /* "TOKEN_EQUALS" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1590 "bibparse.cpp"
	break;
      case 9: /* "TOKEN_FIELD" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1631 "bibparse.cpp"
	break;
      case 10: /* "TOKEN_INCLUDE" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1672 "bibparse.cpp"
	break;
      case 11: /* "TOKEN_INLINE" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1713 "bibparse.cpp"
	break;
      case 12: /* "TOKEN_KEY" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1754 "bibparse.cpp"
	break;
      case 13: /* "TOKEN_LBRACE" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1795 "bibparse.cpp"
	break;
      case 14: /* "TOKEN_LITERAL" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1836 "bibparse.cpp"
	break;
      case 15: /* "TOKEN_NEWLINE" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1877 "bibparse.cpp"
	break;
      case 16: /* "TOKEN_PREAMBLE" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1918 "bibparse.cpp"
	break;
      case 17: /* "TOKEN_RBRACE" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 1959 "bibparse.cpp"
	break;
      case 18: /* "TOKEN_SHARP" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2000 "bibparse.cpp"
	break;
      case 19: /* "TOKEN_SPACE" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2041 "bibparse.cpp"
	break;
      case 20: /* "TOKEN_STRING" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2082 "bibparse.cpp"
	break;
      case 21: /* "TOKEN_VALUE" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2123 "bibparse.cpp"
	break;
      case 22: /* "TOKEN_UNKNOWN" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2164 "bibparse.cpp"
	break;
      case 29: /* "comment" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2205 "bibparse.cpp"
	break;
      case 30: /* "entry" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2246 "bibparse.cpp"
	break;
      case 31: /* "entry_head" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2287 "bibparse.cpp"
	break;
      case 32: /* "key_name" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2328 "bibparse.cpp"
	break;
      case 33: /* "include" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2369 "bibparse.cpp"
	break;
      case 34: /* "preamble" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2410 "bibparse.cpp"
	break;
      case 35: /* "string" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2451 "bibparse.cpp"
	break;
      case 36: /* "value" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2492 "bibparse.cpp"
	break;
      case 37: /* "simple_value" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2533 "bibparse.cpp"
	break;
      case 38: /* "assignment_list" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2574 "bibparse.cpp"
	break;
      case 39: /* "assignment" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2615 "bibparse.cpp"
	break;
      case 40: /* "assignment_lhs" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2656 "bibparse.cpp"
	break;
      case 41: /* "opt_space" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2697 "bibparse.cpp"
	break;
      case 42: /* "space" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2738 "bibparse.cpp"
	break;
      case 43: /* "single_space" */
#line 230 "bibparse.y"
	{ 
	
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
		if( streql( error_msg_popping, yymsg ) ){
			UNPROTECT_PTR( (*yyvaluep) ) ;
		} else{
			popping = 0; 
		}
	}
};
#line 2779 "bibparse.cpp"
	break;

      default:
	break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;
/* Location data for the look-ahead symbol.  */
YYLTYPE yylloc;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  int yystate;
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;

  /* The location stack.  */
  YYLTYPE yylsa[YYINITDEPTH];
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;
  /* The locations where the error started and ended.  */
  YYLTYPE yyerror_range[2];

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;
  yylsp = yyls;
#if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
  /* Initialize the default location before parsing starts.  */
  yylloc.first_line   = yylloc.last_line   = 1;
  yylloc.first_column = yylloc.last_column = 0;
#endif

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;
	YYLTYPE *yyls1 = yyls;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yyls1, yysize * sizeof (*yylsp),
		    &yystacksize);
	yyls = yyls1;
	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);
	YYSTACK_RELOCATE (yyls);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;
  *++yylsp = yylloc;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location.  */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 269 "bibparse.y"
    { junk1((yyvsp[(1) - (1)])); YYACCEPT ; ;}
    break;

  case 3:
#line 270 "bibparse.y"
    { junk3((yyvsp[(1) - (3)]), (yyvsp[(2) - (3)]), (yyvsp[(3) - (3)])) ; YYACCEPT ; ;}
    break;

  case 4:
#line 273 "bibparse.y"
    { (yyval) = xx_object_list_1((yyvsp[(1) - (1)]));  ;}
    break;

  case 5:
#line 274 "bibparse.y"
    { (yyval) = xx_object_list_2((yyvsp[(1) - (3)]),(yyvsp[(3) - (3)])); junk1((yyvsp[(2) - (3)])) ; ;}
    break;

  case 6:
#line 277 "bibparse.y"
    {
			(yyval) = xx_object((yyvsp[(3) - (3)])); 
			junk2((yyvsp[(1) - (3)]),(yyvsp[(2) - (3)])); 
		;}
    break;

  case 7:
#line 281 "bibparse.y"
    {
			/* this eats whatever is between two entries, lexing until 
				a TOKEN_AT is found */
			(yyval) = xx_forward((yyvsp[(3) - (3)])); junk2((yyvsp[(1) - (3)]),(yyvsp[(2) - (3)])) ; 
		;}
    break;

  case 8:
#line 288 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 9:
#line 289 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 10:
#line 290 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 11:
#line 291 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 12:
#line 292 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 13:
#line 293 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 14:
#line 294 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 15:
#line 295 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 16:
#line 296 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 17:
#line 297 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 18:
#line 298 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 19:
#line 299 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 20:
#line 300 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 21:
#line 301 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 22:
#line 302 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 23:
#line 303 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 24:
#line 304 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 25:
#line 305 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 26:
#line 306 "bibparse.y"
    { (yyval) = xx_forward( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 27:
#line 308 "bibparse.y"
    { (yyval) = xx_atobject_comment((yyvsp[(1) - (1)])); ;}
    break;

  case 28:
#line 309 "bibparse.y"
    { (yyval) = xx_atobject_entry((yyvsp[(1) - (1)]), (yyloc));;}
    break;

  case 29:
#line 310 "bibparse.y"
    { (yyval) = xx_atobject_include((yyvsp[(1) - (1)]));;}
    break;

  case 30:
#line 311 "bibparse.y"
    { (yyval) = xx_atobject_preamble((yyvsp[(1) - (1)]));;}
    break;

  case 31:
#line 312 "bibparse.y"
    { (yyval) = xx_atobject_string((yyvsp[(1) - (1)]));;}
    break;

  case 32:
#line 313 "bibparse.y"
    { (yyval) = xx_null() ; YYUSE((yyvsp[(2) - (2)])) ; recovering = 0; ;}
    break;

  case 33:
#line 316 "bibparse.y"
    {junk2((yyvsp[(1) - (3)]),(yyvsp[(2) - (3)])); (yyval) = xx_forward((yyvsp[(3) - (3)])); ;}
    break;

  case 34:
#line 319 "bibparse.y"
    { (yyval) = xx_token_entry( (yyvsp[(1) - (3)]), (yyvsp[(2) - (3)])); junk1((yyvsp[(3) - (3)])); ;}
    break;

  case 35:
#line 320 "bibparse.y"
    { (yyval) = xx_token_entry( (yyvsp[(1) - (5)]), (yyvsp[(2) - (5)])); junk3((yyvsp[(3) - (5)]),(yyvsp[(4) - (5)]),(yyvsp[(5) - (5)])); ;}
    break;

  case 36:
#line 321 "bibparse.y"
    { (yyval) = xx_token_entry_empty((yyvsp[(1) - (2)])) ; junk1((yyvsp[(2) - (2)])) ; ;}
    break;

  case 37:
#line 324 "bibparse.y"
    { (yyval) = xx_entry_head( (yyvsp[(1) - (8)]), (yyvsp[(5) - (8)])) ; junk6((yyvsp[(2) - (8)]),(yyvsp[(3) - (8)]),(yyvsp[(4) - (8)]),(yyvsp[(6) - (8)]),(yyvsp[(7) - (8)]),(yyvsp[(8) - (8)])) ; ;}
    break;

  case 38:
#line 325 "bibparse.y"
    { (yyval) = xx_entry_head_nokey( (yyvsp[(1) - (6)])) ; junk5((yyvsp[(2) - (6)]),(yyvsp[(3) - (6)]),(yyvsp[(4) - (6)]),(yyvsp[(5) - (6)]),(yyvsp[(6) - (6)])) ; ;}
    break;

  case 39:
#line 328 "bibparse.y"
    { (yyval) = xx_keyname_key( (yyvsp[(1) - (1)])) ;;}
    break;

  case 40:
#line 329 "bibparse.y"
    { (yyval) = xx_keyname_abbrev( (yyvsp[(1) - (1)])) ; ;}
    break;

  case 41:
#line 332 "bibparse.y"
    { (yyval) = xx_include( (yyvsp[(3) - (3)]) ) ; junk2((yyvsp[(1) - (3)]),(yyvsp[(2) - (3)])) ; ;}
    break;

  case 42:
#line 335 "bibparse.y"
    { (yyval) = xx_preamble((yyvsp[(5) - (7)])) ; junk6((yyvsp[(1) - (7)]),(yyvsp[(2) - (7)]),(yyvsp[(3) - (7)]),(yyvsp[(4) - (7)]),(yyvsp[(6) - (7)]),(yyvsp[(7) - (7)])) ; ;}
    break;

  case 43:
#line 338 "bibparse.y"
    { (yyval) = xx_string((yyvsp[(5) - (7)])) ; junk6( (yyvsp[(1) - (7)]), (yyvsp[(2) - (7)]), (yyvsp[(3) - (7)]), (yyvsp[(4) - (7)]), (yyvsp[(6) - (7)]), (yyvsp[(7) - (7)])) ; ;}
    break;

  case 44:
#line 341 "bibparse.y"
    {(yyval) = xx_forward((yyvsp[(1) - (1)])) ; ;}
    break;

  case 45:
#line 342 "bibparse.y"
    { (yyval) = xx_value( (yyvsp[(1) - (5)]), (yyvsp[(5) - (5)])) ; junk3( (yyvsp[(2) - (5)]), (yyvsp[(3) - (5)]), (yyvsp[(4) - (5)]));  ;}
    break;

  case 46:
#line 345 "bibparse.y"
    { (yyval) = xx_simple_value((yyvsp[(1) - (1)])); ;}
    break;

  case 47:
#line 346 "bibparse.y"
    { (yyval) = xx_expand_abbrev((yyvsp[(1) - (1)])); ;}
    break;

  case 48:
#line 349 "bibparse.y"
    { (yyval) = xx_assignement_list1((yyvsp[(1) - (1)])); ;}
    break;

  case 49:
#line 350 "bibparse.y"
    { (yyval) = xx_assignement_list2((yyvsp[(1) - (4)]), (yyvsp[(4) - (4)])); junk2((yyvsp[(2) - (4)]),(yyvsp[(3) - (4)])); ;}
    break;

  case 50:
#line 353 "bibparse.y"
    {  (yyval) = xx_assignement((yyvsp[(1) - (6)]), (yyvsp[(5) - (6)])); junk4((yyvsp[(2) - (6)]), (yyvsp[(3) - (6)]), (yyvsp[(4) - (6)]), (yyvsp[(6) - (6)])); ;}
    break;

  case 51:
#line 356 "bibparse.y"
    { (yyval) = xx_lhs_field( (yyvsp[(1) - (1)]) ) ; ;}
    break;

  case 52:
#line 357 "bibparse.y"
    { (yyval) = xx_lhs_abbrev( (yyvsp[(1) - (1)]) ); ;}
    break;

  case 53:
#line 360 "bibparse.y"
    { (yyval) = xx_null() ; ;}
    break;

  case 54:
#line 361 "bibparse.y"
    { (yyval) = xx_forward((yyvsp[(1) - (1)])) ;;}
    break;

  case 55:
#line 364 "bibparse.y"
    { (yyval) = xx_forward((yyvsp[(1) - (1)])) ;;}
    break;

  case 56:
#line 365 "bibparse.y"
    { (yyval) = xx_forward((yyvsp[(1) - (2)])); junk1((yyvsp[(2) - (2)])) ; ;}
    break;

  case 57:
#line 368 "bibparse.y"
    { (yyval) = xx_space( (yyvsp[(1) - (1)]) ) ; ;}
    break;

  case 58:
#line 369 "bibparse.y"
    { (yyval) = xx_space_inline( (yyvsp[(1) - (1)]) ) ; ;}
    break;

  case 59:
#line 370 "bibparse.y"
    { (yyval) = xx_space_newline( (yyvsp[(1) - (1)]) ) ; ;}
    break;


/* Line 1267 of yacc.c.  */
#line 3400 "bibparse.cpp"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }

  yyerror_range[0] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse look-ahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval, &yylloc);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  yyerror_range[0] = yylsp[1-yylen];
  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      yyerror_range[0] = *yylsp;
      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;

  yyerror_range[1] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the look-ahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, (yyerror_range - 1), 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval, &yylloc);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp, yylsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


#line 372 "bibparse.y"


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
	Rf_warning( "\n%s:%d:%d\n\t%s\n\tDropping the entry `%s` (starting at line %d) ", 
		bibfile, line_number, col_number, s, currentKey, currentKeyLine ) ;
	
	/* indicates that we are recovering from an error */
	recovering = 1 ;
}
/*}}}*/

/*{{{ yywarning */
void yywarning(const char *s){
	Rf_warning( "\n%s:%d:%d\n\t%s", bibfile, line_number, col_number, s ) ;
}
/*}}}*/

/*{{{ R interface */
/**
 * .External( "do_read_bib", file = file )
 */
RcppExport SEXP do_read_bib(SEXP args){
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
		Rf_warning( "encoding '%s' will be ignored", encoding ) ;
	}
	
	srcfile = CADDDR(args);
	
	FILE* fp ;
	if((fp = _fopen(R_ExpandFileName( fname ), "r")) == NULL){
		Rf_error( "unable to open file to read", 0);
	}
	yyset_in( fp ) ; /* so that the lexer reads from the file */
	yydebug = 0 ;    /* setting this to 1 gives a lot of messages */
	popping = 0; 
	line_number = 1;
	col_number = 0; 
	byte_number = 0; 
	/* set up the data */
	_PROTECT_WITH_INDEX( includes = NewList() , &INCLUDE_INDEX ) ;
	_PROTECT_WITH_INDEX( comments = NewList() , &COMMENT_INDEX ) ;
	_PROTECT_WITH_INDEX( strings  = NewList() , &STRING_INDEX ) ;
	_PROTECT_WITH_INDEX( preamble = NewList() , &PREAMBLE_INDEX ) ;
	_PROTECT_WITH_INDEX( entries  = NewList() , &ENTRIES_INDEX ) ;
	
	/* call the parser */
	recovering = 0; 
	/* int res = yyparse() ; */
	yyparse() ;
	
	/* structure the data */
	SEXP ans; 
	if( Rf_length( CDR(entries) ) == 0 ){
		PROTECT( ans = Rf_allocVector( INTSXP, 1)  ) ;
		INTEGER(ans)[0] = 0; 
	} else {
		PROTECT( ans = CDR(entries) )  ;
	}
	SEXP obj ;
	_PROTECT(obj = asVector( comments, 0 ) ); Rf_setAttrib( ans , Rf_install("comment") , obj ); _UNPROTECT_PTR( obj ) ;
	_PROTECT(obj = asVector( includes, 0 ) ); Rf_setAttrib( ans , Rf_install("include") , obj ); _UNPROTECT_PTR( obj ) ; 
	_PROTECT(obj = asVector( strings , 1 ) ); Rf_setAttrib( ans , Rf_install("strings") , obj ); _UNPROTECT_PTR( obj ) ; 
	_PROTECT(obj = asVector( preamble, 0 ) ); Rf_setAttrib( ans , Rf_install("preamble"), obj ); _UNPROTECT_PTR( obj ) ;
	_UNPROTECT_PTR( entries ) ;
	_UNPROTECT_PTR( ans );
	free(currentKey) ;
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
	_UNPROTECT_PTR( tmp) ;
	_UNPROTECT_PTR( object) ;
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
		_PROTECT( ans = list );
	} else{
		_PROTECT( ans = GrowList( list, object ) );
	}
	_UNPROTECT_PTR( object ) ;
	_UNPROTECT_PTR( list ) ;
#ifdef XXDEBUG
	Rprintf( "</xx_object_list_2>\n" ) ;
#endif
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
	_UNPROTECT_PTR( object ) ;
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
	_PROTECT( head = Rf_getAttrib( object, Rf_install("head") ) ); 
	int n = Rf_length( object ) ;
	_PROTECT( ans   = Rf_allocVector( STRSXP, n) ) ;
	_PROTECT( names = Rf_allocVector( STRSXP, n) ) ;
	
	_PROTECT( o = object ) ; 
	int i;
	for( i=0; i<n; i++){
		SET_STRING_ELT( ans  , i, STRING_ELT(CAR(o),0) ) ;
		SET_STRING_ELT( names, i, STRING_ELT(Rf_getAttrib(CAR(o), Rf_install("names")),0) ) ;
		o = CDR(o ) ;
	}
	_UNPROTECT(1); // o
	
	SEXP entry ;
	_PROTECT( entry = Rf_allocVector( STRSXP, 1 ) ) ;
	SET_STRING_ELT( entry  , 0, STRING_ELT(head, 1) ) ;
	
	SEXP h ;
	_PROTECT( h = Rf_allocVector( STRSXP, 1 ) ) ;
	SET_STRING_ELT( h  , 0, STRING_ELT(head, 0) ) ;
	
	Rf_setAttrib( ans, Rf_install( "entry"), entry ) ;
	Rf_setAttrib( ans, Rf_install( "names"), names ) ;
	Rf_setAttrib( ans, Rf_install( "key"), h ) ;
	
	_UNPROTECT( 2 ) ; // entry, h, o
	_UNPROTECT_PTR( object ); 
	_UNPROTECT_PTR( names ); 
	_UNPROTECT_PTR( head ) ;
	
	SEXP res; 
	_PROTECT( res = GrowList( entries , ans ) ) ;
	_REPROTECT( entries = res , ENTRIES_INDEX ) ;
	_UNPROTECT_PTR( res ) ;
	
	SEXP srcref ; 
	_PROTECT( srcref = makeSrcRef( loc, srcfile ) );
	Rf_setAttrib( ans, Rf_install( "srcref"), srcref );
	_UNPROTECT( 1) ; // srcref
	
	
#ifdef XXDEBUG
	Rprintf( "</xx_atobject_entry>\n" ) ;
#endif
	_UNPROTECT_PTR( ans ) ;
	_PROTECT( ans = R_NilValue ); 
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
	Rf_setAttrib( data, Rf_install("head"), head) ;
	_UNPROTECT_PTR( list ) ;
	_UNPROTECT_PTR( head ) ;
	
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
	_PROTECT( ans = R_NilValue ) ;
	Rf_setAttrib( ans, Rf_install("head"), head) ;
	_UNPROTECT_PTR( head ) ;
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
	_PROTECT( ans = Rf_allocVector( STRSXP, 2) ) ;
	SET_STRING_ELT( ans, 0, STRING_ELT(keyname, 0) ) ;
	SET_STRING_ELT( ans, 1, STRING_ELT(kind, 0) ) ;
	_UNPROTECT_PTR(kind) ;
	_UNPROTECT_PTR(keyname) ;
	
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
	_PROTECT( ans = Rf_allocVector( STRSXP, 2) ) ;
	SET_STRING_ELT( ans, 0, NA_STRING ) ;
	SET_STRING_ELT( ans, 1, STRING_ELT(kind, 0) ) ;
	_UNPROTECT_PTR(kind) ;
	Rf_warning( "\n%s:%d:%d\n\tno key for the entry at line %d", 
			bibfile, line_number, col_number, currentKeyLine ) ;
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
	currentKey = strdup( CHAR( STRING_ELT(key,0) ) ) ;
	currentKeyLine = line_number ;
	return key; 
}

/** 
 * name of an entry
 */ 
static SEXP xx_keyname_abbrev( SEXP abbrev){
	SEXP res =  xx_expand_abbrev( abbrev ) ;
	currentKey = strdup( CHAR( STRING_ELT(abbrev,0) ) ) ; 
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
	
	_PROTECT( ans = Rf_allocVector( STRSXP, 1) ) ;
	SET_STRING_ELT( ans, 0, STRING_ELT( mkString2( res, n_left + n_right ), 0) ) ;
	_UNPROTECT_PTR( right ) ; 
	_UNPROTECT_PTR( left ) ; 
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
	_PROTECT( tmp = NewList( ) ) ;
	_PROTECT( ans = GrowList( tmp, object) ) ;
	_UNPROTECT_PTR( tmp ) ;
	_UNPROTECT_PTR( object ) ;
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
	_PROTECT( ans = GrowList( list, object) ) ;
	_UNPROTECT_PTR( list ) ;
	_UNPROTECT_PTR( object ) ;
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
	_PROTECT( ans = value ) ;
	Rf_setAttrib( ans, Rf_install("names"), lhs ) ;
	_UNPROTECT_PTR( lhs ) ;
	_UNPROTECT_PTR( value ) ;
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
			char noquote[n-2] ;
			for( int i=1; i<n-1; i++){
				noquote[i-1] = data[i] ;
			}
			_PROTECT( ans = Rf_allocVector( STRSXP, 1 ) ); 
			SET_STRING_ELT( ans, 0, STRING_ELT(mkString2(noquote, n-2), 0) ) ;
		} else{
			_PROTECT( ans = s ) ;
		}
	} else{
		_PROTECT( ans = s ) ;
	}
	
	_UNPROTECT_PTR( s ) ;
#ifdef XXDEBUG
	Rprintf( "<xx_simple_value>\n" ) ;
#endif
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
	return ans;
}

/*}}}*/

/*{{{ various record functions */
static void recordInclude( SEXP object ){
	SEXP tmp ;
	_PROTECT( tmp = GrowList( includes, object ) ); 
	_REPROTECT( includes = tmp, INCLUDE_INDEX ) ;
	_UNPROTECT_PTR( tmp ) ;
	_UNPROTECT_PTR( object ) ;
}

static void recordComment( SEXP object ){
	SEXP tmp ;
	_PROTECT( tmp = GrowList( comments, object ) ); 
	_REPROTECT( comments = tmp, COMMENT_INDEX ) ;
	_UNPROTECT_PTR( tmp ) ;
	_UNPROTECT_PTR( object ) ;
}
static void recordString( SEXP object ){
	SEXP tmp ;
	_PROTECT( tmp = GrowList( strings, object ) ); 
	_REPROTECT( strings = tmp, STRING_INDEX ) ;
	_UNPROTECT_PTR( tmp ) ;
	_UNPROTECT_PTR( object ) ;
}
static void recordPreamble( SEXP object ){
	SEXP tmp ;
	_PROTECT( tmp = GrowList( preamble, object ) ); 
	_REPROTECT( preamble = tmp, PREAMBLE_INDEX ) ;
	_UNPROTECT_PTR( tmp ) ;
	_UNPROTECT_PTR( object ) ;
}

static SEXP xx_expand_abbrev( SEXP abbrev ){
	SEXP ans, tmp ;
	/* use the abbreviation name by default */
	_PROTECT( ans = Rf_allocVector( STRSXP, 1 ) ) ;
	SET_STRING_ELT( ans, 0, STRING_ELT( abbrev, 0) ) ;
	
	_PROTECT( tmp = CDR(strings) ) ;
	int n = Rf_length( tmp ) ;
	const char * target = CHAR( STRING_ELT( abbrev, 0) ) ;
	SEXP item ;
	for(int i=0; i<n; i++){
		item = CAR(tmp);
		if( streql( CHAR( STRING_ELT( Rf_getAttrib( item, Rf_install("names") ), 0 ) ) , target ) ){
				SET_STRING_ELT( ans, 0, STRING_ELT( item, 0) ) ;
				break ;
		};
		tmp = CDR( tmp ) ;
	}
	_UNPROTECT(1); // tmp
	_UNPROTECT_PTR( abbrev ) ;
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
    _PROTECT(t = Rf_allocVector(STRSXP, 1));
    SET_STRING_ELT(t, 0, Rf_mkCharLenCE(s, len, enc));
    _UNPROTECT_PTR(t);
    return t;
}
/*}}}*/

/*{{{ junks */
void junk1( SEXP s){
#ifdef XXDEBUG
	Rprintf( " *~\n" ) ; 
#endif
	_UNPROTECT_PTR( s ) ; 
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
static SEXP asVector( SEXP x, int donames){
	SEXP ans, names = R_NilValue ; 
	SEXP tmp ;
	int n = Rf_length( CDR(x) ) ;
	_PROTECT( ans   = Rf_allocVector( STRSXP, n) ) ;
	if( donames ){
		_PROTECT( names = Rf_allocVector( STRSXP, n) ) ;
	}
	SEXP item; 
	_PROTECT( tmp = CDR( x ) );
	for( int i=0; i<n; i++){
		item = CAR(tmp); 
		SET_STRING_ELT( ans  , i, STRING_ELT(item, 0) ) ;
		if( donames){
			SET_STRING_ELT( names, i, STRING_ELT( Rf_getAttrib(item, Rf_install("names") ), 0) ) ;
		}
		tmp = CDR(tmp);
	}
	_UNPROTECT(1) ; // tmp
	if( donames ){
		Rf_setAttrib( ans, Rf_install("names"), names ) ;
		_UNPROTECT_PTR(names) ;
	}
	_UNPROTECT_PTR(x) ; 
	_UNPROTECT_PTR(ans) ; 
	return ans; 
}
/*}}}*/


void dummy_bibparse(){
	yywarning( "" ) ;
}


/* :tabSize=4:indentSize=4:noTabs=false:folding=explicit:collapseFolds=1: */



#ifndef BIBTEX_BIBTEX_H
#define BIBTEX_BIBTEX_H

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#include <Rcpp.h>

#define BIBYYLMAX 131072 
extern "C" {
void	_yyerror(const char *s_);
int		yylex(void);
int		yyparse(void);
int		yywrap(void);
}

#if defined(FLEX_SCANNER)
	#define input		yyinput
	#define output		putchar
	
	#if !defined(HAVE_FILENO)
		#define YY_NEVER_INTERACTIVE 1	/* suppresses need for isatty() and fileno() */
	#endif                      
	
	#else /* NOT defined(FLEX_SCANNER) */

#endif /* defined(FLEX_SCANNER) */

int				yyparse();

/* These variables are defined in biblex.cpp: */
static long line_number;
static long col_number ;
static long byte_number ;
static long start_line_number; 
static long start_col_number ;
static long start_byte_number; 

extern int yydebug;

#define R_EOF   -1
FILE *	_fopen(const char *filename, const char *mode);
void yyset_in (FILE*) ;

SEXP NewList() ;
SEXP GrowList(SEXP, SEXP) ;
SEXP Insert(SEXP, SEXP) ;

void setToken( const char*, int) ;
SEXP mkString2(const char *, int) ;

extern Rboolean known_to_be_utf8  ;
extern Rboolean known_to_be_latin1 ;
typedef struct yyltype{
  int first_line;
  int first_column;
  int first_byte;

  int last_line;
  int last_column;
  int last_byte;
} yyltype;
# define YYLTYPE yyltype

SEXP makeSrcRef(YYLTYPE,SEXP);

#endif


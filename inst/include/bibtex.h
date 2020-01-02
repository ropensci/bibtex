#ifndef BIBTEX_BIBTEX_H
#define BIBTEX_BIBTEX_H

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#ifndef extern
#include <Rinternals.h>
#endif

#ifdef SUPPORT_MBCS
# ifdef Win32
#  define USE_UTF8_IF_POSSIBLE
# endif
#endif

#ifdef HAVE_VISIBILITY_ATTRIBUTE
# define attribute_visible __attribute__ ((visibility ("default")))
# define attribute_hidden __attribute__ ((visibility ("hidden")))
#else
# define attribute_visible
# define attribute_hidden
#endif

#define BIBYYLMAX 131072
void	_yyerror(const char *s_);
int		yylex(void);
int		yyparse(void);
int		yywrap(void);

#if defined(FLEX_SCANNER)
#define input		yyinput
#define output(c)	Rprintf("%c", c)

#if !defined(HAVE_FILENO)
#define YY_NEVER_INTERACTIVE 1	/* suppresses need for isatty() and fileno() */
#endif

#else /* NOT defined(FLEX_SCANNER) */

#endif /* defined(FLEX_SCANNER) */

int				yyparse();

extern int			error_count;
extern char			*program_name;	/* for error messages */

/* These variables are defined in biblex.c: */
extern int		do_lex_output;
extern long line_number;
extern long col_number ;
extern long byte_number ;
extern long start_line_number; 
extern long start_col_number ;
extern long start_byte_number; 

extern const char	*the_filename;

#define	ERROR_PREFIX	"??"	/* this prefixes all error messages */
#define WARNING_PREFIX	"%%"	/* this prefixes all warning messages */

extern int yydebug;

#if !defined(EXIT_SUCCESS)
#define EXIT_SUCCESS	0
#define EXIT_FAILURE	1
#endif

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
extern YYLTYPE last_at_location ;

#define YY_FATAL_ERROR(msg) Rf_error("lex fatal error:\n%s\n", msg);

#endif


#ifndef BIBTEX_BIBTEX_H
#define BIBTEX_BIBTEX_H

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <alloca.h>
#include <Rinternals.h>

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

void	yyerror(const char *s_);
int		yylex(void);
int		yyparse(void);
int		yywrap(void);

#if defined(FLEX_SCANNER)
#define input		yyinput
#define output		putchar

#if !defined(HAVE_FILENO)
#define YY_NEVER_INTERACTIVE 1	/* suppresses need for isatty() and fileno() */
#endif

#else /* NOT defined(FLEX_SCANNER) */

#endif /* defined(FLEX_SCANNER) */

static void		recognize(const char *s_);
int				yyparse();
static void		yywarning(const char *s_);

int			error_count;
char			*program_name;	/* for error messages */

/* These variables are defined in biblex.c: */
int		do_lex_output;
long		line_number;
const char	*the_filename;

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

#endif


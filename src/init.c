#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .External calls */
extern SEXP do_read_bib(SEXP);

static const R_ExternalMethodDef ExternalEntries[] = {
  {"do_read_bib", (DL_FUNC) &do_read_bib, 3},
  {NULL, NULL, 0}
};

void R_init_bibtex(DllInfo *dll){
  R_registerRoutines(dll, NULL, NULL, NULL, ExternalEntries);
  R_useDynamicSymbols(dll, FALSE);
}

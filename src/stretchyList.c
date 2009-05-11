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
    SEXP s = CONS(R_NilValue, R_NilValue);
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
    tmp = CONS(s, R_NilValue);
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
    tmp = CONS(s, CDR(l));
    UNPROTECT(1);
    SETCDR(l, tmp);
    return l;
}


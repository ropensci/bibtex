#!/bin/bash 

cp inst/grammar/bibparse.y src/
cp inst/grammar/biblex.l src/
cd src
bison -vd bibparse.y -o bibparse.c
lex -l -t biblex.l > biblex.c
rm bibparse.y
rm biblex.l
mv bibparse.output ../inst/
mv bibparse.h ../inst/include/
cd ../..
Rscript bibtex/inst/clean-bibtex.R
cd bibtex

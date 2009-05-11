read.bib <- function(
	file = system.file( "REFERENCES.bib", package = package ), 
	package = "bibtex" ){
	
	out <- .External( "do_read_bib", file = file )
	# FIXME: deal with quotes in the lexer
	quote.killer <- function(x) gsub ('"', '', x )
	at  <- sapply( attributes(out), quote.killer ) 
	out <- lapply( out, quote.killer )
	attributes(out) <- at
	out
}


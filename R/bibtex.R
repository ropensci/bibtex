read.bib <- function(
	file = system.file( "REFERENCES.bib", package = package ), 
	package = "bibtex", 
	header = if( length(preamble) ) paste( preamble, sep = "\n" ) else "", 
	footer = "" ){
	
	out <- .External( "do_read_bib", file = file )
	quote.killer <- function(x) gsub ('(^"|"$)', '', x )
	at  <- sapply( attributes(out), quote.killer ) 
	out <- lapply( out, function(x){
		entry <- attr( x, "entry" )
		y <- as.list( quote.killer(x) )
		attr( y, "entry") <- entry
		if( "author" %in% names(y) ){
			y[["author"]] <- as.personList( y[["author"]] )
		}
		structure( y, class = "citation", srcfile = file, srcref = rep(NA, 6) ) 
	} )
	preamble <- at[["preamble"]] 
	structure( list( out ), class = "citationList", 
		header = header, 
		footer = footer, 
		strings = at[["strings"]] )
}


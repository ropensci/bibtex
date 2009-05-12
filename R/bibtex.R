read.bib <- function(
	file = system.file( "REFERENCES.bib", package = package ), 
	package = "bibtex" ){
	
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
		structure( y, class = "citation" ) 
	} )
	preamble <- at[["preamble"]] 
	structure( list( out ), class = "citationList", 
		header = if( length(preamble) ) paste( preamble, sep = "\n" ) else "", 
		footer = "", 
		strings = at[["strings"]] )
}


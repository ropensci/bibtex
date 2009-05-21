read.bib <- function(
	file = system.file( "REFERENCES.bib", package = package ), 
	package = "bibtex", 
	encoding = "unknown",
	header = if( length(preamble) ) paste( preamble, sep = "\n" ) else "", 
	footer = "" ){
	
	if( !is.character( file ) ){
		stop( "'read.bib' only supports reading from files, `file` should be a character vector of length one" )
	}
	srcfile <- switch( encoding, 
		"unknown" = srcfile( file ), 
		srcfile( file, encoding = encoding ) )
	out <- .External( "do_read_bib", file = file, 
		encoding = encoding, srcfile = srcfile )
	at  <- attributes(out) 
	out <- lapply( out, function(x){
		y <- as.list( x )
		if( "author" %in% names(y) ){
			y[["author"]] <- as.personList( y[["author"]] )
		}
		structure( y, class = "citation", 
			srcref = attr( x, "srcref" ), 
			entry = attr( x, "entry" ), 
			key = attr( x, "key") ) 
	} )
	preamble <- at[["preamble"]] 
	structure( list( out ), class = "citationList", 
		header = header, 
		footer = footer, 
		strings = at[["strings"]] )
}


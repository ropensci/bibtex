
R2.12.0 <- getRversion() >= "2.12.0"

.bibentry <- if(R2.12.0) {
	get( "bibentry", asNamespace( "utils" ) )
} else {
	function( bibtype, textVersion, header = NULL, 
		footer = NULL, key = NULL, ..., other = list(), 
		mheader = NULL, mfooter = NULL ){
		
		y <- list(...)
		if( "author" %in% names(y) ){
			y[["author"]] <- as.personList( y[["author"]] )
		}
		structure( y,
			entry = bibtype, 
			key = key, 
			class = "citation" 
			)
	}
}

make.bib.entry <- function( x ){
		type <- attr( x, "entry" )
		key  <- attr( x, "key" )
		
		y <- as.list( x )
		
		textVersion <- sprintf( "%s. %s (%s)", 
			if( "author" %in% names(x) ) x[["author"]] else "?", 
			if( "title" %in% names(x) ) x[["title"]] else "?", 
			if( "year" %in% names(x) ) x[["year"]] else "?"
			)
		
		
		tryCatch(  
			.bibentry( bibtype = type, key = key, textVersion = textVersion ,
				other = y ), 
		error = function(e){
			message( sprintf( "ignoring entry '%s' (line %d) because :\n\t%s\n", 
				key, 
				attr(x, "srcref")[1], 
				conditionMessage( e ) ) )
			NULL
		} )
}

make.citation.list <- if( R2.12.0 ){
	function( x, header, footer) {
		rval <- list()
		for( i in seq_along(x) ){
			if( !is.null(x[[i]] ) )
				rval <- c( rval, x[[i]] )
		}
		class(rval) <- c( "citation", "bibentry" )
		rval
	}  
} else {
	function( x , header, footer ){
		structure( out, class = "citationList", 
			header = header, footer = footer )
	}
}


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
	out <- lapply( out, make.bib.entry )
	preamble <- at[["preamble"]]
	
	out <- make.citation.list( out, header, footer )
	attr( out, "strings") <- at[["strings"]]
	out
}


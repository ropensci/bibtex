
R2.12.0 <- getRversion() >= "2.12.0"

.bibentry <- if(R2.12.0) {
	get( "bibentry", asNamespace( "utils" ) )
} else {
	function( bibtype, textVersion = NULL , header = NULL, 
		footer = NULL, key = NULL, ..., other = list(), 
		mheader = NULL, mfooter = NULL ){
		
		y <- append( list(...), other )
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

arrange.authors <- function( x ){
	rx <- "[[:space:]]+and[[:space:]]+"
	authors <- lapply( strsplit( x, rx )[[1]], function(y){
		if( grepl( ",", y) ) {
			y <- sub( "^([^,]+)[[:space:]]*,[[:space:]]*(.*?)$", "\\2 \\1", y , perl = TRUE )
		}
		rx <-  "^[{](.*)[}]$"
		if( grepl( rx, y ) ){
			person( sub( rx, "\\1", y ) )
		} else{
			as.person( y )
		}
	} )
	as.personList( authors )
}

make.bib.entry <- function( x ){
		type <- attr( x, "entry" )
		key  <- attr( x, "key" )
		
		y <- as.list( x )
		
		if( "author" %in% names(x) ){
			y[["author"]] <- arrange.authors( y[["author"]] )
		}
		
		tryCatch(  
			.bibentry( bibtype = type, key = key, other = y ), 
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
		structure( x, class = "citationList", 
			header = header, footer = footer )
	}
}

findBibFile <- function(package){
	if( package %in% c("base", "datasets", "graphics", "grDevices", 
		"methods", "stats", "stats4", "tools", "utils" ) ){
		system.file( "bib", sprintf( "%s.bib", package ), package = "bibtex" )
	} else {
		attempt <- system.file( "REFERENCES.bib", package = package )
		if( !nzchar(attempt) ){
			stop( sprintf( "no bibtex database for package `s`", package ) ) 
		}
		attempt
	}
}


read.bib <- function(
	file = findBibFile(package) , 
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


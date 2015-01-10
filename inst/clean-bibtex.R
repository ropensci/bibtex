lines <- readLines( "bibtex/src/biblex.c" )

# remove declaration of yy_fatal_error
decl <- grep("static void yy_fatal_error.*;", lines)
lines[decl] <- paste( "//", lines[decl] )

# first line of definition of yy_fatal_error
def_begin <- grep("static void yy_fatal_error[^;]*$", lines )
def_end <- def_begin + grep( "^}", tail(lines, -def_begin) )[1L]

lines[ def_begin:def_end ] <- paste( "// ", lines[def_begin:def_end] )

writeLines( lines, "bibtex/src/biblex.c" )


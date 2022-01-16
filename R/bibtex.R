UnlistSplitClean <- function(s) {
  unlist(strsplit(gsub("[{}]", "", trimws(s)), " "))
}

#' @importFrom tools deparseLatex latexToUtf8 parseLatex
cleanupLatex <- function (x){
  if (!length(x))
    return(x)

  if (any(grepl('mkbib', x))){
    x <- gsub('mkbibquote', 'dQuote', x)
    x <- gsub('mkbibemph', 'emph', x)
    x <- gsub('mkbibbold', 'bold', x)
  }
  x <- gsub('\\\\hyphen', '-', x)

  latex <- try(parseLatex(x), silent = TRUE)
  if (inherits(latex, "try-error")) {
    x
  }else {
    x <- deparseLatex(latexToUtf8(latex), dropBraces = TRUE)
    if (grepl("\\\\[[:punct:]]", x)){
      x <- gsub("\\\\'I", '\u00cd', x)
      x <- gsub("\\\\'i", '\u00ed', x)
      x <- gsub('\\\\"I', '\u00cf', x)
      x <- gsub('\\\\"i', '\u00ef', x)
      x <- gsub("\\\\\\^I", '\u00ce', x)
      x <- gsub("\\\\\\^i", '\u00ee', x)
      x <- gsub("\\\\`I", '\u00cc', x)
      x <- gsub("\\\\`i", '\u00ec', x)
      Encoding(x) <- 'UTF-8'
    }
    x
  }
}

#' @importFrom utils as.personList
ArrangeAuthors <- function (x){
  rx <- "(?i)[[:space:]]+and[[:space:]]+"
  x <- gsub('[[:space:]]{2,}', ' ', x, useBytes = TRUE)
  authors <- lapply(strsplit(x, rx, perl = TRUE)[[1]], ArrangeSingleAuthor)
  as.personList(authors)
}

ArrangeSingleAuthor <- function(y){
  if (grepl('[\\]', y)){
    tmp <- try(parseLatex(y), TRUE)
    if (!inherits(tmp, 'try-error'))
      y <- deparseLatex(latexToUtf8(tmp))
  }
  parts <- unlist(strsplit(y, ", ?(?![^{}]*})", perl = TRUE))
  len.parts <- length(parts)
  if (len.parts == 1L){
    #     parts <- "{Barnes} {and} {Noble,} {Inc.}"
    if (grepl("[^{][[:print:]][}]$", parts)){
      s <- unlist(strsplit(parts, ''))
      i <- length(s) - 1L
      paren <- 1
      while (paren > 0 && i > 0){
        if (s[i] == '{'){
          paren <- paren - 1L
        }else if (s[i] == '}'){
          paren <- paren + 1L
        }
        i <- i - 1L
      }
      last <- paste0(s[(i+2):(length(s)-1)], collapse = '')
      first <- NULL
      if (i > 0)
        first <- paste0(s[seq_len(i-1)], collapse = '')
      person(UnlistSplitClean(first), cleanupLatex(last))  # Mathew {McLean IX}
    }else{
      vonrx <- "(^|[[:space:]])([[:lower:]+[:space:]?]+)[[:space:]]"
      m <- regexec(vonrx, parts)
      von <- unlist(regmatches(parts, m))[3L]
      if (!is.na(von)){
        name <- unlist(strsplit(parts, vonrx))
        if (length(name) == 1L){  # von Bommel
          person(family=c(cleanupLatex(von), cleanupLatex(name)))
        }else{  # Mark von Bommel
          person(given = UnlistSplitClean(name[1L]), family=c(cleanupLatex(von), cleanupLatex(name[2L])))
        }
      }else{  # George Bernard Shaw
        name <- UnlistSplitClean(parts)
        len.name <- length(name)
        if (len.name <= 1L){
          person(family = name)
        }else{
          person(given = name[seq_len(len.name - 1L)], family = name[len.name])
        }
      }
    }
  }else if (len.parts == 2L){
    if (grepl('^[{]', parts[1L])){  # e.g. {de Gama}, Vasco
      person(UnlistSplitClean(parts[2L]), UnlistSplitClean(parts[1L]))
    }else{
      vonrx <- "^([[:lower:]+[:space:]?]+)[[:space:]]"
      m <- regexec(vonrx, parts[1L])
      von <- unlist(regmatches(parts[1L], m))[2]
      if (is.na(von)){  # e.g. Smith, John Paul
        person(UnlistSplitClean(parts[2L]), cleanupLatex(parts[1L]))
      }else{  # e.g. de la Soul, John
        person(UnlistSplitClean(parts[2L]), c(cleanupLatex(von), cleanupLatex(sub(vonrx, '', parts[1L]))))
      }
    }
  }else if (len.parts == 3L){
    vonrx <- "^([[:lower:]+[:space:]?]+)[[:space:]]"
    m <- regexec(vonrx, parts[1L])
    von <- unlist(regmatches(parts[1L], m))[2]
    if (is.na(von)){  # e.g. White, Jr., Walter
      person(UnlistSplitClean(parts[3L]), c(cleanupLatex(parts[1L]), cleanupLatex(parts[2L])))
    }else{  # e.g. des White, Jr., Walter
      person(UnlistSplitClean(parts[3L]),
             c(cleanupLatex(von), cleanupLatex(sub(vonrx, '', parts[1L])), cleanupLatex(parts[2L])))
    }
  }else{
    stop('Invalid author/editor format.')
  }
}

#' @importFrom utils bibentry person citation installed.packages toBibtex
make.bib.entry <- function( x ){
    type <- attr( x, "entry" )
    key  <- attr( x, "key" )

    y <- as.list( x )
    names(y) <- tolower( names(y) )

    err.fun <- function(e){
         message( sprintf( "ignoring entry '%s' (line %d) because :\n\t%s\n",
                         key,
                         attr(x, "srcref")[1],
                         conditionMessage( e ) ) )
          NULL
    }

    if( "author" %in% names(y) ){
        y[["author"]] <- tryCatch(ArrangeAuthors( y[["author"]] ), error = err.fun)
        if (is.null(y[["author"]]))
            return()
    }
    if( "editor" %in% names(y) ){
        y[["editor"]] <- tryCatch(ArrangeAuthors( y[["editor"]] ), error = err.fun)
        if (is.null(y[["editor"]]))
            return()
    }

    # if there is a date entryn try to extract the year (#15)
    fields <- names(y)
    if( "date" %in% fields && !"year" %in% fields ){
      y$year <- format( as.Date( y$date), "%Y" )
    }

    tryCatch(bibentry( bibtype = type, key = key, other = y ), error = err.fun)
}

make.citation.list <- function( x, header, footer){
    rval <- list()
    for( i in seq_along(x) ){
        if( !is.null(x[[i]] ) )
            rval <- c( rval, x[[i]] )
    }
    class(rval) <- c( "bibentry" )
    rval
}

findBibFile <- function(package) {
    if( package %in% c("base", "datasets", "graphics", "grDevices",
                       "methods", "stats", "stats4", "tools", "utils" )
       ) {
        system.file( "bib", sprintf( "%s.bib", package ), package = "bibtex" )
    } else {
      reference_locations <- c("REFERENCES.bib", "inst/REFERENCES.bib")
      for(file_path in reference_locations) {
        attempt <- system.file( file_path, package = package )
        if( nzchar(attempt) ) return( attempt )
      }
      stop( sprintf( "no bibtex database for package '%s'", package ) )
    }
}

#' convenience wrapper around .External call
#'
#' This is a convenience function for packages that do need to call the internal
#' functionality of \code{\link{read.bib}} but does different processing. This is
#' a simple wrapper around the \code{.External} code used by \code{\link{read.bib}}
#'
#' The parser is greatly inspired from the \samp{bibparse} library.
#'
#' @seealso \code{\link[utils]{bibentry}}
#'
#' @param file file name
#' @param encoding encoding
#' @param srcfile Deprecated
#' @export
do_read_bib <- function(file, encoding = "unknown", srcfile) {
  # Assess the extension of the file
  if (!file.exists(file)) stop("Error: unable to open file to read")

  # Read all as UTF-8
  lines <- readLines(file, encoding = encoding, warn = FALSE)

  # Aux
  trimlines <- trimws(lines)

  # Map bib file
  # Init and end of citation
  init <- grep("^@", trimlines)

  # Identify type of entry
  entry <- unlist(lapply(trimlines[init], function(x) {
    unlist(strsplit(x, "\\{"))[1]
  }))


  # Map fo document
  map_bib <- data.frame(
    entry = trimws(entry),
    entry_lower = trimws(tolower(entry)),
    init = init,
    # The end of each entry is at most the
    # previous line of the next entry
    end = c(init[-1] - 1, length(lines))
  )

  # Extract map string
  map_string <- map_bib[map_bib$entry_lower == "@string", ]

  if (nrow(map_string) > 0) {
    # This is needed for multiline strings

    stringlines <- lapply(seq_len(nrow(map_string)), function(x) {
      init <- map_string$init[x]
      end <- map_string$end[x]
      string_line <- lines[seq(init, end)]
      # Guess lines outside of the entry

      guess_eostring <- max(grep("\\}$", string_line))

      string_line <- string_line[seq(1, guess_eostring)]

      # Collapse to single line
      string_line <- paste0(string_line, collapse = "\n")
      string_line
    })

    stringlines <- unlist(stringlines)

    map_string_end <- tryCatch(parse_strings(map_string, stringlines),
      warning = function(e) {
        NULL
      },
      error = function(e) {
        stop("Error when parsing strings of ",
          file,
          call. = FALSE
        )
      }
    )
  } else {
    map_string_end <- NULL
  }


  # Select entries only, i.e. exclude preamble, comment and string
  map_entries <- map_bib[!map_bib$entry_lower %in% c(
    "@preamble",
    "@string", "@comment"
  ), ]


  # Parse single entry
  end <- lapply(seq_len(nrow(map_entries)), function(x) {
    parse_single_entry(
      map_entries$init[x], map_entries$end[x], lines,
      map_string_end
    )
  })

  return(end)
}

#' bibtex parser
#'
#' Parser for bibliography databases written in the bib format.
#'
#' @param file bib file to parse.  By default, the file
#'         \file{REFERENCES.bib} in the root directory of the package given by
#'         the \code{package} argument is used.
#' @param package package from which we want to read the bibliography.
#'         Only used if \code{file} is unspecified.
#'         Core R packages (base, datasets, graphics, grDevices, methods,
#'         stats, stats4, tools and utils) are treated specially: this package
#'         contains bibtex entries for these packages.
#' @param encoding encoding
#' @param header DEPRECATED.
#' @param footer DEPRECATED
#'
#' @return An object of class \code{"bibentry"}, similar to those obtained by the
#'        \code{\link[utils]{bibentry}} function.
#'
#' @references Nelson H. F. Beebe. bibparse 1.04. 1999. \url{http://www.math.utah.edu/~beebe/}
#'
#' @examples
#' ## this package has a REFERENCES.bib file
#' bib <- read.bib( package = "bibtex" )
#'
#' ## bibtex collects bibtex entries for R base packages
#' base.bib <- read.bib( package = "base" )
#'
#' \dontshow{
#' bib <- read.bib( package = "base" )
#' bib <- read.bib( package = "datasets" )
#' bib <- read.bib( package = "graphics" )
#' bib <- read.bib( package = "grDevices" )
#' bib <- read.bib( package = "methods" )
#' bib <- read.bib( package = "stats" )
#' bib <- read.bib( package = "stats4" )
#' bib <- read.bib( package = "tools" )
#' bib <- read.bib( package = "utils" )
#' }
#' @export
read.bib <- function(file = findBibFile(package) ,
         package = "bibtex",
         encoding = "unknown",
         header = NULL,
         footer = NULL )
{
    if( !is.character( file ) ){
        stop( "'read.bib' only supports reading from files, 'file' should be a character vector of length one" )
    }
    srcfile <- switch( encoding,
                      "unknown" = srcfile( file ),
                      srcfile( file, encoding = encoding ) )

    out <- tryCatch(do_read_bib(
      file = file,
      encoding = encoding
    ),
    error = function(e) {
      stop("Invalid bib file", call. = FALSE)
    }, warning = function(w) {
      if (any(grepl("syntax error, unexpected [$]end", w))) {
        NULL
      }
    }
    )
    # keys <- lapply(out, function(x) attr(x, 'key'))
    at  <- attributes(out)
    if((typeof(out) != "integer") || (getRversion() < "3.0.0"))
        out <- lapply( out, make.bib.entry )
    else
        out <- list()
    preamble <- at[["preamble"]]

    out <- make.citation.list( out, header, footer )
    attr( out, "strings") <- at[["strings"]]
    names(out) <- unlist(out$key)
    out
}

#' Generate a Bibtex File from Package Citations
#'
#' Generates a Bibtex file from a list of packages or all the installed packages.
#' It is useful for adding relevant citations in Sweave documents.
#'
#' @param entry a \code{\link{bibentry}} object or a character vector of package
#' names. If \code{NULL}, then the list of all installed packages is used.
#' @param file output Bibtex file.
#' @param verbose a logical to toggle verbosity.
#' @param append logical. If \code{TRUE} content is appended to the file.
#'
#' @return the list of Bibtex objects -- invisibly.
#' @author
#' Renaud Gaujoux, based on the function \code{Rpackages.bib}
#' from Achim Zeileis (see \emph{References}).
#'
#' @references
#' \emph{[R] Creating bibtex file of all installed packages?}
#' Achim Zeileis. R-help mailing list.
#'
#' @export
#' @examples
#'
#' write.bib(c('bibtex', 'utils', 'tools'), file='references')
#' bibs <- read.bib('references.bib')
#' write.bib(bibs, 'references2.bib')
#' md5 <- tools::md5sum(c('references.bib', 'references2.bib'))
#' md5[1] == md5[2]
#'
#' \dontshow{unlink(c('references.bib', 'references2.bib'))}
write.bib <- function(entry, file="Rpackages.bib", append = FALSE, verbose = TRUE) {
    bibs <-
    if( inherits(entry, "bibentry") )    entry
    else if( is.character(entry) ){
        if( length(entry) == 0 ){
            if( verbose ) message("Empty package list: nothing to be done.")
            return(invisible())
        }
        pkgs <- entry
        if( is.null(pkgs) ) ## use all installed packages
            pkgs <- unique(installed.packages()[,1])
        bibs <- sapply(pkgs, function(x) try(citation(x)), simplify=FALSE)
        #bibs <- lapply(pkgs, function(x) try(toBibtex(citation(x))))
        n.installed <- length(bibs)

        ## omit failed citation calls
        ok <- sapply(bibs, inherits, "bibentry")
        pkgs <- pkgs[ok]
        bibs <- bibs[ok]
        n.converted <- sum(ok)

        ## add bibtex keys to each entry
        pkgs <- lapply(seq_along(pkgs), function(i) if(length(bibs[[i]]) > 1)
                        paste(pkgs[i], 1:length(bibs[[i]]), sep = "") else pkgs[i])
        pkgs <- do.call("c", pkgs)
        bibs <- do.call("c", bibs)
        # formatting function for bibtex keys:
        # names with special characters must be enclosed in {}, others not.
        as.bibkey <- function(x){
            i <- grep("[.]", x)
            if( length(i) > 0 )
                x[i] <- paste("{", x[i], "}", sep='')
            x
        }
        bibs <- mapply(function(b,k){ b$key <- k; b}, bibs, pkgs, SIMPLIFY=FALSE)
        bibs <- do.call("c", bibs)

        if(verbose) message("Converted ", n.converted, " of ", n.installed, " package citations to BibTeX")
        bibs
    } else
        stop("Invalid argument 'entry': expected a bibentry object or a character vector of package names.")

    if( length(bibs) == 0 ){
        if( verbose ) message("Empty bibentry list: nothing to be done.")
        return(invisible())
    }

    ## write everything to a single .bib file
    if( is.null(file) )
        file <- stdout()
    else if( is.character(file) ){
        if( !grepl("\\.bib$", file) ) # add .bib extension if necessary
        file <- paste(file, '.bib', sep='')
    }

    fh <- file(file, open = if(append) "a+" else "w+" )
    on.exit( if( isOpen(fh) ) close(fh) )
    if( verbose ) message("Writing ", length(bibs) , " Bibtex entries ... ", appendLF=FALSE)
    writeLines(toBibtex(bibs), fh)
    #writeLines(do.call("c", lapply(bibs, as.character)), fh)
    if(verbose) message("OK\nResults written to file '", file, "'")

    ## return Bibtex items invisibly
    invisible(bibs)
}

\name{read.bib}
\Rdversion{1.1}
\alias{read.bib}
\title{
bibtex parser
}
\description{
	parser for bibliography databases written in the bib format
}
\usage{
read.bib(file = findBibFile(package), 
	package = "bibtex", 
	encoding = "unknown", 
	header = if( length(preamble) ) paste( preamble, sep = "\n" ) else "", 
	footer = "" )
}
\arguments{
\item{file}{
bib file to parse. By default, the file \samp{REFERENCES.bib} in the 
root directory of the package given by the \code{package} argument is used. 
}
\item{package}{
package from which we want to read the bibliography. Only used if \code{file}
is unspecified. 
  	  
Core R packages (base, datasets, graphics, grDevices, methods, stats, 
stats4, tools and utils) are treated specially: this package contains bibtex
entries for these packages.
}
\item{encoding}{encoding}
\item{header}{
header of the citation list. By default this is made from the \samp{Preamble}
entries found in the bib file.
}
\item{footer}{
footer of the citation list
}
}
\value{
A \samp{citationList} object, similar to those made by the
\samp{\link[utils]{citation}} function.
}
\references{
Nelson H. F. Beebe. bibparse 1.04. 1999. \url{http://www.math.utah.edu/~beebe}
}
\author{
Romain Francois <romain@r-enthusiasts.com>
}
\note{
	The parser is greatly inspired from the \samp{bibparse} library.
}
\seealso{
\code{\link[utils]{citation}}
}
\examples{
# this package has a a REFERENCES.bib file
bib <- read.bib( package = "bibtex" )

# bibtex collects bibtex entries for R core packages
base.bib <- read.bib( package = "base" )
}
\keyword{ manip }


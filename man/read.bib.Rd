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
read.bib(file = system.file("REFERENCES.bib", package = package), package = "bibtex")
}
\arguments{
  \item{file}{
bib file to parse. By default, the file \preformatted{REFERENCES.bib} in the 
root directory of the package given by the \code{package} argument is used
}
  \item{package}{
package from which we want to read the bibliography
}
}
\value{
A list of class bibtex. Each item of the list 
corresponds to an entry of the bibtex database. The format 
of these items is a named character vector.
}
\references{
Nelson H. F. Beebe. bibparse 1.04. 1999. http://www.math.utah.edu/~beebe
}
\author{
Romain Francois <francoisromain@free.fr>
}
\note{
The parser is greatly inspired from the bibparse library.
}

\examples{
	\dontrun{
		bib <- read.bib( package = "bibtex" )
	}
}
\keyword{ manip }


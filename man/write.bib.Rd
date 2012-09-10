\name{write.bib}
\alias{write.bib}
\title{
Generate a Bibtex File from Package Citations
}
\description{
Generates a Bibtex file from a list of packages or all the installed packages.
It is useful for adding relevant citations in Sweave documents.
}
\usage{
write.bib(entry, file = "Rpackages.bib", append = FALSE, verbose = TRUE)
}
\arguments{
  \item{entry}{
entry a \code{\link{bibentry}} object or a character vector of package
names. If \code{NULL}, then the list of all installed packages is used.
}
  \item{file}{
output Bibtex file
}
  \item{append}{
TRUE if the content should be appended to the file
}
  \item{verbose}{
a logical to toggle verbosity
}
}
\value{
the list of Bibtex objects -- invisibly
}
\references{
\emph{Creating bibtex file of all installed packages?}
 Achim Zeileis. R-help mailing list.
 \url{https://stat.ethz.ch/pipermail/r-help/2009-December/222201.html}
}
\author{
Renaud Gaujoux, based on the function \code{Rpackages.bib}
from Achim Zeileis (see \emph{References}).  
}
\examples{
\dontrun{
write.bib(c('bibtex', 'utils', 'tools'), file='references')
bibs <- read.bib('references.bib')
write.bib(bibs, 'references2.bib')
md5 <- tools::md5sum(c('references.bib', 'references2.bib'))
md5[1] == md5[2]
}
}
\keyword{manip}

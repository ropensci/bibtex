\name{NEWS}
\title{News for Package \pkg{bibtex}}
\newcommand{\cpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\section{Changes in version 0.4.0 (2014-12-31)}{
  \itemize{
    \item Removed the function \code{yy_fatal_error} which even though it was never 
    actually called, triggered some R CMD check nuisance
    \item Removed useless dependency on Rcpp which bibtex no longer uses 
    \item Added cite by key functionality to \code{read.bib}, pull request by 
    Michael Koohafkan
  }
}

\section{Changes in version 0.3-5 (2013-02-04)}{
  \itemize{
    \item Fix for bib files with no content.
  }
}

\section{Changes in version 0.3-1 (2011-12-11)}{
  \itemize{
    \item New function \code{write.bib} contributed by Renaud Gaujoux.
    \item Missing \code{\%} in error reporting in read.bib.
    Fix provided by Renaud Gaujoux.
  }
}

\section{Changes in version 0.3-0 (2011-11-17)}{
  \itemize{
    \item Fixed long standing bug re backslahes.
  }
}


test_that("Write", {
  tmp <- file.path(tempdir(), "references")

  suppressWarnings(write.bib(c("bibtex", "utils", "tools"), file = tmp))

  #> Results written to file 'references.bib'
  expect_error(read.bib(tmp))

  #> Results written to file 'references.bib'
  bibs <- read.bib(paste0(tmp, ".bib"))

  tmp2 <- tempfile(fileext = ".bib")
  write.bib(bibs, tmp2)

  md5 <- tools::md5sum(c(paste0(tmp, ".bib"), tmp2))
  md5 <- unname(md5)

  expect_equal(md5[1], md5[2])
})


test_that("Read", {
  ## this package has a REFERENCES.bib file
  bib <- read.bib( package = "bibtex" )
  
  ## bibtex collects bibtex entries for R base packages
  base.bib <- read.bib( package = "base" )
  
  # \dontshow{
  bib <- read.bib( package = "base" )
  bib <- read.bib( package = "datasets" )
  bib <- read.bib( package = "graphics" )
  bib <- read.bib( package = "grDevices" ) 
  bib <- read.bib( package = "methods" )
  bib <- read.bib( package = "stats" )
  bib <- read.bib( package = "stats4" )
  bib <- read.bib( package = "tools" )
  bib <- read.bib( package = "utils" )
})

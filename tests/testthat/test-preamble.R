test_that("Preamble from file", {
  file <- system.file("bib/xampl_preamble.bib", package = "bibtex")

  out <- read.bib(file)
  class(out) <- c("citation", "bibentry")
  expect_snapshot_output(out)
})


test_that("Preamble via params", {
  file <- system.file("bib/xampl_single.bib", package = "bibtex")

  out <- read.bib(file)
  expect_snapshot_output(toBibtex(out))
})

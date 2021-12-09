test_that("Multiline from file", {
  file <- system.file("bib/xampl_multiline.bib", package = "bibtex")

  out <- read.bib(file)

  expect_snapshot_output(toBibtex(out))
})

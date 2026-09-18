test_that("Preamble from file", {
  file <- system.file("bib/xampl_preamble.bib", package = "bibtex")

  out <- read.bib(file)
  expect_length(format(out), length(out))
  expect_snapshot_output(dump_bib(out))
  expect_snapshot_output(toBibtex(out))
})


test_that("Preamble via params", {
  file <- system.file("bib/xampl_single.bib", package = "bibtex")

  out <- read.bib(file)
  expect_snapshot_output(toBibtex(out))
})

test_that("Full xampl on string", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot(names(out))

  # print() output depends on the R version, see helper-dump_bib.R.
  expect_length(format(out), length(out))
  expect_snapshot_output(dump_bib(out))
})


test_that("Full xampl on bibtex", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot_output(toBibtex(out))
})

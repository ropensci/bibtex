test_that("Full xampl on string", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot(names(out))

  expect_snapshot_output(out)
})


test_that("Full xampl on bibtex", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot_output(toBibtex(out))
})

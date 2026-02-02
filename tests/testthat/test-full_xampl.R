test_that("Full xampl on string", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot(names(out))

  # bibentry formatting changed in R 4.5.0 (deparseLatex math handling)
  expect_snapshot_output(out, variant = if (getRversion() >= "4.5.0") "devel" else NULL)
})


test_that("Full xampl on bibtex", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot_output(toBibtex(out))
})

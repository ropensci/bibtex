test_that("Full xampl on string", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot(names(out))

  # bibentry formatting changed in R-devel (4.6.0) via deparseLatex math handling
  is_r_devel <- grepl("devel", R.version$status, ignore.case = TRUE)
  expect_snapshot_output(out, variant = if (is_r_devel) "devel" else NULL)
})


test_that("Full xampl on bibtex", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot_output(toBibtex(out))
})

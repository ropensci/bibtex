test_that("Full xampl on string", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot(names(out))

  # R 4.6.0 reordered the fields of book-type entries, so pages now print
  # before the edition rather than after it
  new_format <- getRversion() >= "4.6.0"
  expect_snapshot_output(out, variant = if (new_format) "devel" else NULL)
})


test_that("Full xampl on bibtex", {
  file <- system.file("bib/xampl_mod.bib", package = "bibtex")
  out <- read.bib(file)
  expect_snapshot_output(toBibtex(out))
})

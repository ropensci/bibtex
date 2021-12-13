test_that("Unbalanced braces", {
  skip("Can't test: cause error on package")
  file <- system.file("bib/unbalanced_braces.bib", package = "bibtex")
  expect_error(read.bib(file), "Invalid bib file")
})


test_that("Unable to recover after encountering two consecutive TOKEN_LBRACE { 42", {
  skip("Can't test: cause error on package")
  file <- system.file("bib/unable_recover_42.bib", package = "bibtex")
  expect_warning(read.bib(file))
})

test_that("srcfile deprecation message", {
  f <- file.path(system.file("bib", "xampl_mod.bib", package = "bibtex"))

  m <- expect_message(do_read_bib(file = f, srcfile = f))

  expect_equal(m$message, "'srcfile' argument is deprecated.\n")
})

test_that("header deprecation message", {
  f <- file.path(system.file("bib", "xampl_single.bib", package = "bibtex"))

  m <- expect_message(read.bib(file = f, header = "test"))

  expect_equal(m$message, "'header' argument is deprecated.\n")
})

test_that("footer deprecation message", {
  f <- file.path(system.file("bib", "xampl_single.bib", package = "bibtex"))

  m <- expect_message(read.bib(file = f, footer = "test"))

  expect_equal(m$message, "'footer' argument is deprecated.\n")
})

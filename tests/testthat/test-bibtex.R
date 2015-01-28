context("bibtex")

test_that("arrange.single.author does not add extra trailing space in given names (#7)", {
  given <- bibtex:::ArrangeSingleAuthor('Jean-Claude {Van Damme}')$given
  expect_false( grepl( "[[:space:]]$", given ) )
})

test_that("read.bib Ignores entry but does not stop with invalid author/editor (#12)", {
  f <- file.path(system.file("bib", "badFormat.bib", package = "bibtex"))
  bib <- read.bib(f)
  expect_true(length(bib) == 1L)
})


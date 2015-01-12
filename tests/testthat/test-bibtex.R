context("bibtex")

test_that("arrange.single.author does not add extra trailing space in given names (#7)", {
  given <- bibtex:::ArrangeSingleAuthor('Jean-Claude {Van Damme}')$given
  expect_false( grepl( "[[:space:]]$", given ) )
})


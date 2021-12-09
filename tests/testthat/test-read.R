test_that("Read errors 1", {
  x <- 1

  expect_error(read.bib(x))
})

test_that("Not find bib on package", {
  expect_error(findBibFile("mockpackage"))
})

test_that("Test errors", {
  tmp <- tempfile(fileext = ".bib")
  expect_error(write.bib(NULL, file = tmp))
  expect_message(
    write.bib(as.character(NULL), file = tmp),
    "Empty package list: nothing to be done"
  )
})

test_that("Test package citation", {
  skip_if_not_installed("testthat")
  skip_if_not_installed("devtools")

  tmp <- tempfile(fileext = ".bib")

  write.bib(c("testthat", "devtools"), file = tmp)
  l <- read.bib(tmp)

  expect_gte(length(l), 2)
})


test_that("Test append", {
  f <- citation("base")[1]

  f$key <- "base"

  tmp <- tempfile(fileext = ".bib")

  write.bib(f, file = tmp)
  l <- read.bib(tmp)

  expect_length(l, 1)

  # Add one citation

  mock <- bibentry("Misc",
    title = "Mock citation",
    author = "Mock author",
    key = "mock"
  )

  write.bib(mock, file = tmp, append = TRUE)

  l2 <- read.bib(tmp)

  expect_length(l2, 2)


  # Overwrite
  expect_silent(write.bib(mock, file = tmp, append = FALSE, verbose = FALSE))
  l3 <- read.bib(tmp)

  expect_length(l3, 1)
  expect_equal(l3$title, mock$title)
  expect_equal(l3$author, mock$author)
  expect_equal(l3$key, mock$key)
})

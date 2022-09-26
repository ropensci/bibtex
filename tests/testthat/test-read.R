test_that("Read errors 1", {
  x <- 1

  expect_error(read.bib(x))
})

test_that("Not find bib on package", {
  expect_error(findBibFile("mockpackage"))
})

test_that("Test entry with non standard fields", {
  tmp <- tempfile(fileext = ".bib")
  entry <- '@Article{newspaper,
    author = {Van Damme, Jean-Claude},
    title  = {Article title},
    date   = {2016-12-21},
    journal = {Newspaper name},
    hyphen-field = "This one",
    under_field = "This one",
    double:field = "This one",
  }'
  writeLines(entry, tmp)

  bib <- read.bib(tmp)

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

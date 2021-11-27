
test_that("Test messages on write.bib", {
  expect_message(
    bibtex::write.bib(""),
    "Empty bibentry list: nothing to be done."
  )
})

test_that("Extension management", {
  tmp <- tempfile()
  write.bib(c("utils", "base"), file = tmp)
  expect_true(file.exists(paste0(tmp, ".bib")))
})

test_that("Test write bib from packages", {
  tmp <- tempfile(fileext = ".bib")
  expect_message(write.bib(c("utils", "base"), file = tmp))
})


test_that("Snapshot of bibentry", {
  tmp <- tempfile(fileext = ".bib")

  book <- bibentry("Book",
    author = "Hadley Wickham",
    title = "ggplot2: Elegant Graphics for Data Analysis",
    publisher = "Springer-Verlag New York",
    year = "2016",
    isbn = "978-3-319-24277-4",
    url = "https://ggplot2.tidyverse.org"
  )
  write.bib(book, file = tmp)

  expect_snapshot_file(tmp, "bibtex_book.bib")
})

test_that("Snapshot of bibentry with UTF-8", {
  tmp <- tempfile(fileext = ".bib")

  utf_chars <- bibentry(
    "Article",
    doi = "10.21105/joss.03900",
    url = "https://doi.org/10.21105/joss.03900",
    year = 2021,
    publisher = "The Open Journal",
    volume = 6,
    number = 67,
    pages = 3900,
    author = person("Diego", "Hernangómez"),
    title = "cffr: Generate Citation File Format Metadata for R Packages",
    journal = "Journal of Open Source Software"
  )
  write.bib(utf_chars, file = tmp)

  expect_snapshot_file(tmp, "bibtex_utf8.bib")
})

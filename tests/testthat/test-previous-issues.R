test_that("Error message for invalid .bib files to read.bib #3", {
  bib <- system.file("bib/badFormat.bib", package = "bibtex")

  message <- expect_message(read.bib(bib))

  expect_snapshot_output(message$message)
})


test_that("arrange.authors when family names have white space #6", {
  issuefile <- system.file("bib/issue6.bib", package = "bibtex")

  out <- read.bib(issuefile)

  aut <- out["newspaper"]$author
  expect_s3_class(aut, "person", exact = TRUE)
  expect_identical(aut, person(given = "Jean-Claude", family = "Van Damme"))
})

# Rewriting test already included
# Housekeeping and for keep track on the same file

test_that("(new) Extra trailing space in ... #7", {
  issuefile <- system.file("bib/issue7.bib", package = "bibtex")

  out <- read.bib(issuefile)

  aut <- out["newspaper"]$author
  expect_s3_class(aut, "person", exact = TRUE)
  expect_identical(aut, person(given = "Jean-Claude", family = "Van Damme"))
  cat(aut$family)
})

test_that("read.bib can use ? in key #9", {
  issuefile <- system.file("bib/issue9.bib", package = "bibtex")

  out <- read.bib(issuefile)

  expect_snapshot_output(toBibtex(out))

  # Write
  tmp2 <- file.path(tempdir(), "issue9.bib")

  expect_message(write.bib(out, tmp2, append = FALSE, verbose = TRUE))

  expect_snapshot_file(tmp2)

  # Re-read
  out2 <- read.bib(tmp2)

  expect_identical(out2$key, "key?")
  expect_identical(names(out2), "key?")
})

test_that("read.bib Ignores entry but does not stop with invalid author/editor #12", {
  f <- file.path(system.file("bib", "badFormat.bib", package = "bibtex"))
  bib <- read.bib(f)
  expect_true(length(bib) == 1L)
})



test_that("make.bib.entry can generate year from date #15", {
  issuefile <- system.file("bib/issue15.bib", package = "bibtex")

  # Read Lines, there is no year here
  expect_snapshot_output(readLines(issuefile))

  out <- read.bib(issuefile)
  expect_equal(out$year, "2016")
  expect_snapshot_output(toBibtex(out))
})


test_that("windows and encoding #17", {
  issuefile <- system.file("bib/issue17.bib", package = "bibtex")

  out <- read.bib(issuefile)

  auths <- out$author

  expect_s3_class(auths, "person", exact = TRUE)


  expect_identical(auths[[1]]$family, "Hermès International S.A.")
  expect_identical(auths[[2]]$family, "Katzfuß")
})


test_that("List of author names joined by AND cannot be parsed #18", {
  issuefile <- system.file("bib/issue18.bib", package = "bibtex")

  out <- read.bib(issuefile)

  auths <- out$author
  expect_length(auths, 5)

  expect_snapshot_output(auths$given)
  expect_snapshot_output(auths$family)

  expect_snapshot_output(toBibtex(out))
})


test_that("caught segfault read.bib() - macOS 10.14.6 #23", {
  issuefile <- system.file("bib/issue23.bib", package = "bibtex")

  out <- read.bib(issuefile)
  expect_snapshot_output(toBibtex(out))
})


test_that("Parse single entry from string #35", {

  # This test is about not reading from a file, but from a string
  my_ref <- " @book{McElreath_2020, edition={2},
   title={Statistical Rethinking: A Bayesian Course with Examples in R and Stan}, ISBN={978-0-429-02960-8},
   url={https://www.taylorfrancis.com/books/9780429642319}, DOI={10.1201/9780429029608},
   publisher={Chapman and Hall/CRC}, author={McElreath, Richard}, year={2020}, month={Mar} }"

  # Need to check by writing first
  tmp1 <- tempfile(fileext = ".bib")
  writeLines(my_ref, tmp1)

  # And reading from the temp file
  out <- read.bib(tmp1)

  expect_snapshot_output(toBibtex(out))
})

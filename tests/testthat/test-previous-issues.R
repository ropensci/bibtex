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


test_that("Trailing whitespace after closing brace does not cause silent failure", {
  # Issue: entries with trailing whitespace after } like "} " were silently

  # ignored, returning empty bibentry() with no error
  issuefile <- system.file("bib/issue_trailing_space.bib", package = "bibtex")

  out <- read.bib(issuefile)

  expect_length(out, 2)
  expect_equal(names(out), c("ad1", "ad2"))
  expect_equal(unlist(out$year, use.names = FALSE), c("2025", "2026"))
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


test_that("make.bib.entry handles YYYY-MM date format #56", {
  # BibLaTeX files often have date in YYYY-MM format without day
  j <- c(
    author = "Dagsvik, John K. and Raknerud, Arvid",
    date = "2011-05",
    journal = "Journal of Applied Econometrics",
    title = "Test title"
  )
  attributes(j) <- c(attributes(j), list(
    entry = "Article",
    key = "test2011",
    srcref = 1
  ))

  result <- bibtex:::make.bib.entry(j)
  expect_s3_class(result, "bibentry")
  expect_equal(result$year, "2011")
})


test_that("make.bib.entry maps journaltitle to journal #57", {
  # BibLaTeX uses journaltitle instead of journal
  j <- c(
    author = "Dagsvik, John K. and Raknerud, Arvid",
    year = "2011",
    journaltitle = "Journal of Applied Econometrics",
    title = "Test title"
  )
  attributes(j) <- c(attributes(j), list(
    entry = "Article",
    key = "test2011",
    srcref = 1
  ))

  result <- bibtex:::make.bib.entry(j)
  expect_s3_class(result, "bibentry")
  expect_equal(result$journal, "Journal of Applied Econometrics")
})


test_that("Braceless @Comment lines do not cause a silent empty read #64", {
  # `@Comment my comment` (the Emacs syntax) carries no braces, so it used to
  # be taken for an entry. Parsing it raised a warning, and read.bib()'s
  # warning handler swallowed the whole parse and returned bibentry().
  issuefile <- system.file("bib/issue64.bib", package = "bibtex")

  out <- read.bib(issuefile)

  expect_length(out, 3)
  expect_equal(names(out), c("ad1", "ad2", "ad3"))
  expect_equal(unlist(out$year, use.names = FALSE), c("2025", "2026", "2027"))
})


test_that("A leading @Comment line does not change the result #64", {
  bibfile <- system.file("REFERENCES.bib", package = "bibtex")
  expected <- read.bib(bibfile)

  tmp <- tempfile(fileext = ".bib")
  writeLines(c("@Comment my comment", "", readLines(bibfile)), tmp)

  expect_equal(read.bib(tmp), expected)
})


test_that("A '%' comment after the closing brace keeps the entry #64", {
  tmp <- tempfile(fileext = ".bib")
  writeLines(c(
    "@String{JJ = \"Journal J\"} % the journal",
    "@Article{pc1, author = {A B}, title = {T}, journal = JJ, year = 2026} % x"
  ), tmp)

  out <- read.bib(tmp)

  expect_length(out, 1)
  expect_equal(out$journal, "Journal J")
})


test_that("An '@' opening a wrapped field value does not split the entry #64", {
  tmp <- tempfile(fileext = ".bib")
  writeLines(c(
    "@Article{at1,",
    "  author = {A B},",
    "  title = {T},",
    "  journal = {J},",
    "  year = 2026,",
    "  note = {Contact the author at",
    "          @example.org for reprints},",
    "}"
  ), tmp)

  out <- read.bib(tmp)

  expect_length(out, 1)
  expect_equal(names(out), "at1")
})


test_that("Files without entries read as an empty bibentry #64", {
  empty <- tempfile(fileext = ".bib")
  file.create(empty)

  comments <- tempfile(fileext = ".bib")
  writeLines(c("% Encoding: UTF-8", "% nothing to see here"), comments)

  expect_length(read.bib(empty), 0)
  expect_length(read.bib(comments), 0)
})


test_that("read.bib() reports the cause of a parse failure #64", {
  # A genuine failure must be loud, and must say more than "Invalid bib file".
  unterminated <- tempfile(fileext = ".bib")
  writeLines(c("@String{ j = \"No closing brace", "@Article{a, title = {T}}"), unterminated)

  expect_error(read.bib(unterminated), "Invalid bib file: ")

  # The historical message is kept where the cause carries no text of its own.
  unbalanced <- system.file("bib/unbalanced_braces.bib", package = "bibtex")
  expect_error(suppressMessages(read.bib(unbalanced)), "^Invalid bib file$")
})

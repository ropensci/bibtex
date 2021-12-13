test_that("Error message for invalid .bib files to read.bib #3", {
  bib <- system.file("bib/badFormat.bib", package = "bibtex")

  message <- expect_message(read.bib(bib))

  expect_snapshot_output(message$message)
})


test_that("arrange.authors when family names have white space #6", {
  tmp <- tempfile(fileext = ".bib")
  entry <- "@Article{newspaper,
    author = {Van Damme, Jean-Claude},
    title  = {Article title},
    date   = {2016-12-21},
    journal = {Newspaper name},
  }"
  writeLines(entry, tmp)

  out <- read.bib(tmp)

  aut <- out["newspaper"]$author
  expect_s3_class(aut, "person", exact = TRUE)
  expect_identical(aut, person(given = "Jean-Claude", family = "Van Damme"))
})

# Rewriting test already included
# Housekeeping and for keep track on the same file

test_that("(new) Extra trailing space in ... #7", {
  tmp <- tempfile(fileext = ".bib")
  entry <- "@Article{newspaper,
    author = {Jean-Claude {Van Damme}},
    title  = {Article title},
    date   = {2016-12-21},
    journal = {Newspaper name},
  }"
  writeLines(entry, tmp)

  out <- read.bib(tmp)

  aut <- out["newspaper"]$author
  expect_s3_class(aut, "person", exact = TRUE)
  expect_identical(aut, person(given = "Jean-Claude", family = "Van Damme"))
  cat(aut$family)
})

test_that("read.bib can use ? in key #9", {
  tmp <- tempfile(fileext = ".bib")
  entry <- "@Misc{key?,\n author = \"Smith, Bob\",\n title = \"The Title\",\n year = 2012, \n}"
  writeLines(entry, tmp)
  out <- read.bib(tmp)

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
  tmp <- tempfile(fileext = ".bib")
  entry <- "@Article{newspaper,
    author = {Author Smith},
    title  = {Article title},
    date   = {2016-12-21},
    journal = {Newspaper name},
  }"
  writeLines(entry, tmp)
  out <- read.bib(tmp)
  expect_equal(out$year, "2016")
  expect_snapshot_output(toBibtex(out))
})


test_that("windows and encoding #17", {
  tmp <- tempfile(fileext = ".bib")
  entry <- "@Article{newspaper,
    author = {{Herm{\\`e}s International S.A.} and Katzfu{\\ss}, Matthias},
    title  = {Article title},
    date   = {2016-12-21},
    journal = {Newspaper name},
  }"

  writeLines(entry, tmp)
  out <- read.bib(tmp)

  auths <- out$author

  expect_s3_class(auths, "person", exact = TRUE)


  expect_identical(auths[[1]]$family, "Hermès International S.A.")
  expect_identical(auths[[2]]$family, "Katzfuß")
})


test_that("List of author names joined by AND cannot be parsed #18", {
  tmp <- tempfile(fileext = ".bib")
  entry <- "@Article{10.1371/journal.pone.0109458,
    author = {Liu, Yang-Yu AND Nacher, Jose C. AND Ochiai, Tomoshiro AND Martino, Mauro AND Altshuler, Yaniv},
  journal = {PLOS ONE},
  publisher = {Public Library of Science},
  title = {Prospect Theory for Online Financial Trading},
  year = {2014},
  month = {10},
  volume = {9},
  url = {https://doi.org/10.1371/journal.pone.0109458},
  pages = {1-7},
  number = {10},
  doi = {10.1371/journal.pone.0109458}
  }"

  writeLines(entry, tmp)
  out <- read.bib(tmp)

  auths <- out$author
  expect_length(auths, 5)

  expect_snapshot_output(auths$given)
  expect_snapshot_output(auths$family)

  expect_snapshot_output(toBibtex(out))
})


test_that("caught segfault read.bib() - macOS 10.14.6 #23", {
  tmp <- tempfile(fileext = ".bib")
  entry <- "@article{Hawking1966,
  author = {Hawking, Stephen William  and Bondi, Hermann },
  title = {The occurrence of singularities in cosmology},
  journal = {Proceedings of the Royal Society of London. Series A. Mathematical and Physical Sciences},
  volume = {294},
  number = {1439},
  pages = {511-521},
  year = {1966},
  doi = {10.1098/rspa.1966.0221},
}"

  writeLines(entry, tmp)
  out <- read.bib(tmp)
  expect_snapshot_output(toBibtex(out))
})


test_that("Parse single entry from string #35", {
  my_ref <- " @book{McElreath_2020, edition={2},
   title={Statistical Rethinking: A Bayesian Course with Examples in R and Stan}, ISBN={978-0-429-02960-8},
   url={https://www.taylorfrancis.com/books/9780429642319}, DOI={10.1201/9780429029608},
   publisher={Chapman and Hall/CRC}, author={McElreath, Richard}, year={2020}, month={Mar} }"

  tmp1 <- tempfile(fileext = ".bib")

  writeLines(my_ref, tmp1)

  out <- read.bib(tmp1)

  expect_snapshot_output(toBibtex(out))
})

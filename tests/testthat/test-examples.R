test_that("Write", {
  tmp <- file.path(tempdir(), "references")

  suppressWarnings(write.bib(c("bibtex", "utils", "tools"), file = tmp))

  #> Results written to file 'references.bib'
  expect_error(read.bib(tmp))

  #> Results written to file 'references.bib'
  bibs <- read.bib(paste0(tmp, ".bib"))

  tmp2 <- tempfile(fileext = ".bib")
  write.bib(bibs, tmp2)

  md5 <- tools::md5sum(c(paste0(tmp, ".bib"), tmp2))
  md5 <- unname(md5)

  expect_equal(md5[1], md5[2])
})


test_that("Read bibtex", {
  ## this package has a REFERENCES.bib file
  bib <- read.bib(package = "bibtex")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

test_that("Read base", {
  bib <- read.bib(package = "base")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})


test_that("Read datasets", {
  bib <- read.bib(package = "datasets")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

test_that("Read graphics", {
  bib <- read.bib(package = "graphics")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

test_that("Read grDevices", {
  bib <- read.bib(package = "grDevices")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

test_that("Read methods", {
  bib <- read.bib(package = "methods")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

test_that("Read stats", {
  bib <- read.bib(package = "stats")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

test_that("Read stats4", {
  bib <- read.bib(package = "stats4")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

test_that("Read tools", {
  bib <- read.bib(package = "tools")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

test_that("Read utils", {
  bib <- read.bib(package = "utils")

  expect_snapshot_output(bib)

  expect_snapshot_output(toBibtex(bib))
})

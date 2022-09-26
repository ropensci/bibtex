test_that("parse strings", {
  map_string <- data.frame(
    entry = c("@STRING", "@STRING", "@STRING")
  )


  stringlines <- c(
    "@STRING{STOC-key = \"OX{\\singleletter{stoc}}\"}",
    "@STRING{ACM = \"The OX Association for Computing Machinery\"}",
    "@STRING{STOC = ACM # \" Symposium on the Theory of Computing\"}"
  )


  expect_snapshot_output(
    dput(
      parse_strings(map_string, stringlines)
    )
  )
})

test_that("parse single entry", {
  lines <- readLines(system.file("bib", "utils.bib", package = "bibtex"))
  parsed <- parse_single_entry(
    init = 2,
    end = 8,
    lines = lines,
    map_string_end = NULL
  )

  expect_snapshot_output(dput(parsed))
})


test_that("replace and concat", {
  x <- "\"CIA means \" # CIA"
  string <- c("CIA", "FBI")
  value <- c("Central Intelligence Agency", "Federal Bureau of Investigation")

  # Replace and concat
  expect_snapshot_output(
    replace_string_and_concat(x, string, value)
  )

  x_alt <- "CIA # \" can be abbreviated as CIA, and FBI stands for \" # FBI"

  expect_snapshot_output(
    replace_string_and_concat(x_alt, string, value)
  )


  # Full replacement
  x2 <- "CIA"
  expect_snapshot_output(
    replace_string_and_concat(x2, string, value)
  )

  # No replacement
  x3 <- "\"CIA\""
  expect_snapshot_output(
    replace_string_and_concat(x3, string, value)
  )

  # Protected
  x4 <- "{CIA}"
  expect_snapshot_output(
    replace_string_and_concat(x4, string, value)
  )
})

test_that("Check balanced braces", {
  error <- paste0(
    "@misc{murdoch:2010, author = {Duncan Murdoch}",
    "title = {I {am} unbalanced",
    "year = 2010",
    "url = {http://developer.r-project.org/parseRd.pdf}}"
  )

  err <- expect_message(expect_error(check_balanced_braces(error, 3)))
  expect_equal(
    err$message,
    "Error: Unbalanced braces on entry (line 3). Invalid .bib file\n"
  )


  ok <- paste0(
    "@misc{murdoch:2010, author = {Duncan Murdoch}",
    "title = {I {am} balanced}",
    "year = 2010",
    "url = {http://developer.r-project.org/parseRd.pdf}}"
  )

  expect_silent(check_balanced_braces(ok, 3))
})

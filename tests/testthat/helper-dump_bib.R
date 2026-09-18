# Writes out a bibentry as read.bib() built it: any attributes and class other
# than the default, then the type, key and every field of each entry, with
# each person split into its name parts. It stands in for snapshotting
# print(), which renders through tools::toRd() and tools::Rd2txt() and changes
# between R releases ("\&" unescaped in 4.5.3; field order, chapters and math
# in 4.6.0; Unicode dashes and math again in R-devel). Vectors are written as
# c(...), so the snapshot shows how names were split, e.g.
# given = c("Donald", "E.") rather than "Donald E.", which print() only hints
# at through initials and toBibtex() does not show at all.
dump_bib <- function(bib) {
  extra <- setdiff(names(attributes(bib)), "names")
  if (identical(class(bib), "bibentry")) {
    extra <- setdiff(extra, "class")
  }
  entries <- vapply(unclass(bib), dump_entry, "")
  writeLines(c(
    dump_attributes(bib, extra, ""),
    paste(entries, collapse = "\n\n")
  ))
}

dump_entry <- function(entry) {
  extra <- setdiff(names(attributes(entry)), c("names", "bibtype", "key"))
  key <- paste(attr(entry, "key"), collapse = "")
  lines <- c(
    sprintf("@%s{%s}", attr(entry, "bibtype"), key),
    dump_attributes(entry, extra, "  "),
    unlist(lapply(names(entry), function(f) dump_field(f, entry[[f]])))
  )
  paste(lines, collapse = "\n")
}

dump_attributes <- function(x, which, indent) {
  values <- vapply(attributes(x)[which], dump_value, "")
  sprintf("%sattr(%s) = %s", indent, which, values)
}

dump_field <- function(field, value) {
  if (!inherits(value, "person")) {
    return(sprintf("  %s = %s", field, dump_value(value)))
  }
  people <- vapply(unclass(value), function(p) {
    p <- Filter(length, p)
    paste(names(p), vapply(p, dump_value, ""), sep = " = ", collapse = " | ")
  }, "")
  c(sprintf("  %s:", field), paste0("    ", people))
}

dump_value <- function(x) {
  type <- if (is.character(x)) NULL else sprintf("<%s> ", class(x)[1L])
  x <- unlist(x)
  out <- encodeString(as.character(x), quote = "\"")
  if (!is.null(names(x))) {
    named <- nzchar(names(x))
    out[named] <- paste(names(x)[named], out[named], sep = " = ")
  }
  if (length(out) != 1L || !is.null(names(x))) {
    out <- sprintf("c(%s)", paste(out, collapse = ", "))
  }
  paste0(type, out)
}

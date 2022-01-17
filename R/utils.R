# Helper functions for do_read_bib()

#' Parse (at)string keys
#'
#' Returns a data.frame with all the string keys and their value to be used on
#' the `bib` file.
#'
#' @param map_string data frame with at least one column. Used as index, the
#' only condition is that it must have one row per string.
#'
#' @param stringlines A vector of characters with the same length that
#'   map_string (in terms of number of rows), containing the text of each
#'   string.
#'
#' @details
#' Both inputs are generated on [do_read_bib()]. This function parses the
#' (at) string sequentially, i.e. if the first string is used for concatenation
#' in the second string it should work.
#'
#'
#' @examples
#'
#' map_string <- data.frame(
#'   entry = c("@STRING", "@STRING", "@STRING")
#' )
#'
#'
#' stringlines <- c(
#'   "@STRING{STOC-key = \"OX{\\singleletter{stoc}}\"}",
#'   "@STRING{ACM = \"The OX Association for Computing Machinery\"}",
#'   "@STRING{STOC = ACM # \" Symposium on the Theory of Computing\"}"
#' )
#'
#'
#' parse_strings(map_string, stringlines)
#' @noRd
parse_strings <- function(map_string,
                          stringlines) {

  # This needs to be done in a loop, since strings can depend also
  # on values of previous strings

  parsed_string <- NULL

  for (i in seq_along(stringlines)) {
    row <- map_string[i, ]
    singleline <- stringlines[i]

    map_braces <- check_balanced_braces(singleline, row$init)

    # Extract string between first and last brace

    first_bracket_position <- map_braces$pos[1]
    last_bracket_position <- min(map_braces[map_braces$cum_flag == 0, ]$pos)

    singleline <- trimws(substr(
      singleline, first_bracket_position,
      last_bracket_position
    ))

    # Remove also the braces
    singleline <- trimws(gsub("^\\{|\\}$", "", singleline))

    # Split on name/value
    splitted <- unlist(strsplit(singleline, "="))

    finalrow <- data.frame(
      name_string = trimws(splitted[1]),
      value = trimws(splitted[-1])
    )

    # As character to avoid compatibility issues with older R versions
    finalrow$name_string <- as.character(finalrow$name_string)
    finalrow$value <- as.character(finalrow$value)

    parsed_string <- rbind(parsed_string, finalrow)
  }

  # Need to replace and concat values on loop
  # Iterate over map_parsed and concat
  init <- parsed_string[1, ]

  # Trim leading and trailing commas
  init$value <- trimws(init$value, "both")
  init$value <- trimws(init$value, "both", whitespace = "\"")

  # If only one string return
  if (nrow(parsed_string) == 1) {
    return(init)
  }
  for (j in seq(2, nrow(parsed_string))) {

    # Search if need to replace and concat
    row <- parsed_string[j, ]

    value <- replace_string_and_concat(
      row$value,
      init$name_string,
      init$value
    )

    row$value <- trimws(value, "both", "\"")

    init <- rbind(init, row)
  }

  return(init)
}

#' Parse a single entry
#'
#'
#' Parses a character string to an R object, that would be used to create
#' a [bibentry()] object on a later stage.
#'
#' @return A named character object with two attributes: entry with the
#' BibTeX entry type and key with the assigned key on the file.
#'
#' @param init Number of line where the entry begins
#' @param end Number of line where the entry ends
#' @param lines The content of the .bib file to be parsed, `init` and `end`
#'   are used to select the corresponding lines
#' @param map_string_end The output of [parse_strings()] or `NULL`.
#'
#'
#' @examples
#'
#' lines <- readLines(system.file("bib", "utils.bib", package = "bibtex"))
#' parse_single_entry(
#'   init = 2,
#'   end = 8,
#'   lines = lines,
#'   map_string_end = NULL
#' )
#' @noRd
parse_single_entry <- function(init, end, lines, map_string_end) {
  entry_lines <- lines[seq(init, end)]

  # Skipping empty lines
  entry_lines <- entry_lines[entry_lines != ""]

  # Guess lines outside of the entry

  guess_eoentry <- max(grep("\\}$", entry_lines))

  entry_lines <- entry_lines[seq(1, guess_eoentry)]

  # Collapse to single line
  entry_collapsed <- paste0(entry_lines, collapse = "\n")

  # Check balanced braces
  map_braces <- check_balanced_braces(entry_collapsed, init)

  # Extract string from beginning to first balanced brace

  lastbrace <- min(map_braces[map_braces$cum_flag == 0, ]$pos)

  # This would remove the last brace, it is what we want
  cleaned_entry <- trimws(substr(entry_collapsed, 1, lastbrace - 1))

  # Identify fields
  # Safest pattern I found:
  # ,<space or newline>singleword<space or newline>=
  # E.g:
  # ...}, author={...}
  # ...",\ntitle ="
  # etc.
  # As field entry could have -, _ or : need to replace when identifying the
  # fields. This improve the regex matching pattern

  cleaned_entry_sub <-
    gsub("(?<=[[:alnum:]])_|(?<=[[:alnum:]])-|(?<=[[:alnum:]]):", "x",
      cleaned_entry,
      perl = TRUE
    )

  # Protect commas on brackets to avoid error on splitting
  protected <- gsub(",(?![^\\}]*(\\{|$))", "|",
    cleaned_entry_sub,
    perl = TRUE
  )

  posfields <- unlist(gregexpr(",\\s*\\w+\\s*=", protected))
  # Add init and last pos
  posfields <- sort(unique(c(1, posfields, nchar(cleaned_entry))))

  formatted_bib <- lapply(seq_len(length(posfields) - 1), function(x) {
    str <- substr(cleaned_entry, posfields[x], posfields[x + 1])

    # Cleanup leading and trailing comma and blanks
    str <- trimws(gsub("^,|,$", "", str))
  })

  formatted_bib <- unlist(formatted_bib)

  # Each field is now on a single line

  # # Extract type of entry and key
  # String to first comma
  entry_key <- formatted_bib[1]

  entry_key <- gsub("@", "", unlist(strsplit(entry_key, "\\{")))
  entry_name <- trimws(entry_key[1])
  key_name <- trimws(entry_key[2])

  # Now treat fields

  fields <- formatted_bib[-1]

  treat_fields <- lapply(seq_along(fields), function(x) {
    string <- fields[x]
    equalsign <- grep("=", strsplit(string, "")[[1]])
    field_name <- trimws(substr(string, 1, equalsign - 1))
    field_value <- trimws(substr(string, equalsign + 1, nchar(string)))

    c(field_name, field_value)
  })

  field_names <- unlist(sapply(treat_fields, "[[", 1))
  field_value <- trimws(unlist(sapply(treat_fields, "[[", 2)))


  # Try hard to replace with string values

  field_value <- lapply(field_value, replace_string_and_concat,
    string_names = map_string_end$name_string,
    string_values = map_string_end$value
  )

  field_value <- unlist(field_value)

  # Lead/trailing curly braces ¿?
  field_value <- gsub("^\\{|\\}$", "", field_value)

  # Lead/trailing quotes
  field_value <- gsub("^\"|\"$", "", field_value)


  # Build final object

  attr(field_value, "entry") <- trimws(entry_name)
  names(field_value) <- trimws(field_names)
  attr(field_value, "key") <- key_name
  attr(field_value, "srcref") <- seq(init, end)

  return(field_value)
}


#' Replaces a word with a (at)string value and concatenate
#'
#' Helper function
#'
#'
#' @noRd
#'
#' @param x values to evaluate
#' @param string_names Names of the strings detected on the .bib file
#' @param string_values Values of the string
#'
#' @return A string with the specified treatment
#'
#' @examples
#' x <- "\"CIA means \" # CIA"
#' string <- c("CIA", "FBI")
#' value <- c("Central Intelligence Agency", "Federal Bureau of Investigation")
#'
#' # Replace and concat
#' replace_string_and_concat(x, string, value)
#' x_alt <- "CIA # \" can be abbreviated as CIA, and FBI stands for \" # FBI"
#'
#' replace_string_and_concat(x_alt, string, value)
#'
#'
#' # Full replacement
#' x2 <- "CIA"
#' replace_string_and_concat(x2, string, value)
#'
#' # No replacement
#' x3 <- "\"CIA\""
#' replace_string_and_concat(x3, string, value)
#'
#' # Protected
#' x4 <- "{CIA}"
#' replace_string_and_concat(x3, string, value)
replace_string_and_concat <- function(x, string_names, string_values) {

  # As characters instead of factors
  string_names <- as.character(string_names)
  string_values <- as.character(string_values)

  # If has braces then return the same value
  if (grepl("\\{|\\}", x)) {
    return(x)
  }

  # If has a concat try to replace
  # Use lower for avoid caps mismatching
  if (tolower(x) %in% tolower(string_names)) {
    # Case of full replacement
    index <- match(tolower(x), tolower(string_names))
    return(paste0("\"", string_values[index], "\""))
  } else if (grepl(" # ", x)) {
    # Hardest case, replace and concat
    parts <- unlist(strsplit(x, " # "))

    parts <- lapply(parts, function(y) {
      if (tolower(y) %in% tolower(string_names)) {
        index2 <- match(tolower(y), tolower(string_names))
        string_values[index2]
      } else {
        y
      }
    })

    # Flatten and clean
    newval <- paste(trimws(parts, "both", "\""), collapse = "")

    return(trimws(newval))
  } else {
    return(x)
  }
}


#' Error catching
#'
#' Evaluates if braces \{ are balanced or not and returns an error instead.
#'
#' @param x The string or entry to be evaluated
#' @param line The number of line of the string/entry evaluated. This is used
#'   for generating an informative error only.
#'
#' @examples
#' if (FALSE) {
#'   # Dont run, throws an error
#'   error <- paste0(
#'     "@misc{murdoch:2010, author = {Duncan Murdoch}",
#'     "title = {I {am} unbalanced",
#'     "year = 2010",
#'     "url = {http://developer.r-project.org/parseRd.pdf}}"
#'   )
#'
#'   check_balanced_braces(error, 3)
#' }
#'
#'
#' ok <- paste0(
#'   "@misc{murdoch:2010, author = {Duncan Murdoch}",
#'   "title = {I {am} balanced}",
#'   "year = 2010",
#'   "url = {http://developer.r-project.org/parseRd.pdf}}"
#' )
#'
#' check_balanced_braces(ok, 3)
#' @noRd
check_balanced_braces <- function(x, line) {
  # Check if braces are balanced ----
  # Split the line into chars, extract the position of
  # braces (left and right) and manipulate

  to_chars <- unlist(strsplit(x, ""))

  # Create table with brace map

  pos_leftbrace <- grep("\\{", to_chars)
  pos_rightbrace <- grep("\\}", to_chars)

  map_braces <- data.frame(
    brace = c(
      rep("{", length(pos_leftbrace)),
      rep("}", length(pos_rightbrace))
    ),
    pos = c(pos_leftbrace, pos_rightbrace)
  )

  map_braces <- map_braces[order(map_braces$pos), ]

  # Asign index to each brace: left = 1 and right = -1
  # Then cumsum. This reveals the structure: e.g:
  # @aa{x, a=1, b={s{S}}, f="x{x}x"}
  # This is translated as
  # {  { {   }  }   {   } }
  # 1  1 1   -1 -1  1  -1 -1
  # 1  2 3   2   1   2  1  0

  map_braces$flag <- ifelse(map_braces$brace == "{", 1, -1)
  map_braces$cum_flag <- cumsum(map_braces$flag)

  # If there is no 0 the braces are unbalanced: Throw an error
  if (!(0 %in% map_braces$cum_flag)) {
    message(
      "Error: Unbalanced braces on entry (line ",
      line,
      "). Invalid .bib file"
    )

    # Trigger an error for tryCatch(es)
    stop()
  }

  return(map_braces)
}

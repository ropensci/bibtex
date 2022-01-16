# Helper functions for do_read_bib()

#' Parse (at)string keys
#'
#' Returns a table with all the string values and their value to be used on the
#' `bib` file.
#'
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

    f <- map_braces$pos[1]
    l <- min(map_braces[map_braces$cum_flag == 0, ]$pos)

    singleline <- trimws(substr(singleline, f, l))

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
#' Returns an entry from a .bib file parsed into an R object
#'
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


#' Replaces a word with a string value and concatenate
#'
#' Helper function
#'
#'
#' @noRd
#'
#' @param x values to evalute
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

#' tidy labels to lower snake case with no accents
#'
#' @param x a character vector
#' @param sep a separator to use for non-alphabetical characters
#' @param protect any special characters that need to be protected
#'
#' @return a transformed character vector
#' @keywords internal
#' @note This was taken from the dev version of epitrix to reduce the number
#'   of packages imported (and because it's not going to be on CRAN anytime soon)
#' @noRd
tidy_labels <- function(x, sep = "_", protect = "") {
  x <- as.character(x)

  ## On the processing of the input:

  ## - coercion to lower case
  ## - replace accentuated characters by closest matches
  ## - replace punctuation and spaces not in the protected list with sep, cautiously
  ## - remove starting / trailing seps
  sep <- gsub("([.*?])", "\\\\\\1", sep)

  out <- tolower(x)
  # out <- stringi::stri_trans_general(out, id = transformation)
  # Negative lookahead for alphanumeric and any protected symbols
  to_protect <- sprintf("(?![a-z0-9%s])", paste(protect, collapse = ""))
  # If the negative lookahead doesn't find what it's looking for, then do the
  # replacement.
  to_replace <- sprintf("%s[[:punct:][:space:]]+?", to_protect)

  # workhorse
  out <- gsub(to_replace, sep, out, perl = TRUE)
  out <- gsub(paste0("(", sep, ")+"), sep, out, perl = TRUE)
  out <- sub(paste0("^", sep), "", out, perl = TRUE)
  out <- sub(paste0(sep, "$"), "", out, perl = TRUE)
  out
}

#' get dictionary in format according to dictionaries
#'
#' @param dictionary a single character that matches one of the surveys or outbreaks
#'
#' @return the correct name of the dictionary
#' @noRd
#'
#' @examples
#' get_dictionary("MOrTality")
get_dictionary <- function(dictionary, org = "MSF") {

  # define which ones are outbreaks and which ones are survey datasets
  if (toupper(org) == "MSF") {
    SURVEYS <- c("Mortality", "Nutrition", "Vaccination")
    OUTBREAKS <- c("Cholera", "Measles", "Meningitis", "AJS")
    # NOTE: For future collaborators, if you have other dictionaries you wish to
    #       add to this project, then you should place the names of your valid
    #       dictionaries here in SURVEYS and OUTBREAKS.
    } else if (toupper(org) == "WHO") {
      SURVEYS <- c()
      OUTBREAKS <- c("Cholera")
  } else {
    # no dictionary available
    msg <- sprintf("No dictionaries from '%s' available", org)
    stop(msg, call. = FALSE)
  }

  cmpr <- function(a, b) tolower(a) == tolower(b)
  surv <- cmpr(SURVEYS, dictionary)
  outb <- cmpr(OUTBREAKS, dictionary)

  if (!(any(surv) || any(outb))) {
    msg <- "'dictionary' must be one of:"
    dct <- paste(c(OUTBREAKS, SURVEYS), collapse = "', '")
    msg <- sprintf("%s '%s'", msg, dct)
    stop(msg, call. = FALSE)
  }

  return(list(survey = SURVEYS[surv], outbreak = OUTBREAKS[outb]))
}

# Equivalent of !is.na()
has_value <- Negate(is.na)

# Enforces timing between two columns in a data frame.
#
# The data in the first column must come before the second column. If the timing
# isn't correct, then force the timing to be correct by making the second column
# bigger than the first by `add`.
enforce_timing <- function(x, first, second, add = 2, inclusive = FALSE) {
  if (inclusive) {
    mistakes <- x[[second]] < x[[first]]
  } else {
    mistakes <- x[[second]] <= x[[first]]
  }
  mistakes[is.na(mistakes)] <- FALSE

  days <- if (length(add) == 1) add else sample(add, sum(mistakes, na.rm = TRUE), replace = TRUE)

  x[[second]][mistakes] <- x[[first]][mistakes] + days
  x
}

fix_dates <- function(dis_output) {

  # Fix DATES MSF --------------------------------------------------------------
  #
  # The date sampling we did above
  # exit dates before date of entry
  # just add 20 to admission.... (was easiest...)
  dis_output <- enforce_timing(dis_output,
    first  = "date_of_consultation_admission",
    second = "date_of_exit",
    20
  )

  # lab sample dates before admission
  # add 2 to admission....
  dis_output <- enforce_timing(dis_output,
    first  = "date_of_consultation_admission",
    second = "date_lab_sample_taken",
    2
  )
  # vaccination dates after admission
  # minus 20 to admission...
  dis_output <- enforce_timing(dis_output,
    first  = "date_of_consultation_admission",
    second = "date_of_last_vaccination",
    20
  )

  # symptom onset after admission
  # minus 20 to admission...
  dis_output <- enforce_timing(dis_output,
    first  = "date_of_consultation_admission",
    second = "date_of_onset",
    20
  )

  return(dis_output)
}

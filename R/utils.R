#' tidy labels to lower snake case with no accents
#'
#' @param x a character vector
#' @param sep a separator to use for non-alphabetical characters
#' @param transformation passed to [stri::stri_trans_general()]
#' @param protect any special characters that need to be protected
#'
#' @return a transformed character vector
#' @keywords internal
#' @note This was taken from the dev version of epitrix to reduce the number
#'   of packages imported (and because it's not going to be on CRAN anytime soon)
# Not needed because we don't deal with accents here: importFrom stringi stri_trans_general
#' @noRd
tidy_labels <- function(x, sep = "_", #transformation = "Any-Latin; Latin-ASCII",
                        protect = "") {
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
get_dictionary <- function(dictionary) {

  # define which ones are outbreaks and which ones are survey datasets
  SURVEYS   <- c("Mortality", "Nutrition", "Vaccination")
  OUTBREAKS <- c("Cholera", "Measles", "Meningitis", "AJS")
  surv <- tolower(SURVEYS)   == tolower(dictionary)
  outb <- tolower(OUTBREAKS) == tolower(dictionary)

  if (!(any(surv) || any(outb))) {
    stop("'dictionary' must be one of: 'Cholera', 'Measles', 'Meningitis', 'AJS', 'Mortality', 'Nutrition', 'Vaccination'", call. = FALSE)
  } 

  return(list(survey = SURVEYS[surv], outbreak = OUTBREAKS[outb]))

}

# Equivalent of !is.na()
has_value <- Negate(is.na)


gen_ages <- function(dis_output, numcases, set_age_na = TRUE) {

  # GENERATE AGES --------------------------------------------------------------

  # sample age_month and age_days if appropriate
  age_year_var  <- grep("age.*year",  names(dis_output), value = TRUE)[1]
  age_month_var <- grep("age.*month", names(dis_output), value = TRUE)[1]
  age_day_var   <- grep("age.*day",   names(dis_output), value = TRUE)[1]

  # indicator vectors for ages under two years and months, respectively. Ages
  # under two years/months should go down to a more fine-grained age
  U2_YEARS  <- integer(0)
  U2_MONTHS <- integer(0)
  
  sample_age <- function(x = 120, n = numcases) {
    # Sample the value of x n times
    v      <- sample(0:x, size = n, replace = TRUE)
    return(v)
  }

  if (has_value(age_year_var)) {
    # sample 0:120
    years    <- sample_age(120L, numcases)
    U2_YEARS <- which(years <= 2)
    if (set_age_na) {
      years[U2_YEARS] <- NA_integer_
    }

    dis_output[[age_year_var]] <- years

  } else {
    if (has_value(age_year_var)) {
      dis_output[[age_year_var]] <- NA_integer_
    }
    years <- NA
  }

  if (has_value(age_month_var) && length(U2_YEARS) > 0 && sum(U2_YEARS) > 0) {
    # age_month
    months          <- sample_age(24L, length(U2_YEARS))
    damv            <- dis_output[[age_month_var]]
    damv[U2_YEARS]  <- months
    U2_MONTHS       <- which(damv <= 2)
    if (set_age_na) {
      damv[U2_MONTHS] <- NA_integer_
    }

    dis_output[[age_month_var]] <- damv
  } else {
    if (has_value(age_month_var)) {
      dis_output[[age_month_var]] <- NA_integer_
    }
    months <- NA
  }

  if (has_value(age_day_var) && length(U2_MONTHS) > 0 && sum(U2_MONTHS) > 0) {
    # age_days
    dis_output[[age_day_var]][U2_MONTHS] <- sample_age(60L, length(U2_MONTHS))
  } else {
    if (has_value(age_day_var)) {
      dis_output[[age_day_var]] <- NA_integer_
    }
  }

  return(dis_output)

}

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

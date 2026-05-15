# Shared constraint detection for gen_dict.
#
# These functions identify constraint candidates and relevant conditions from
# a data frame without producing any format-specific syntax. Format backends
# (gen_dict_odk.R, gen_dict_dhis2.R, etc.) call these and then convert the
# results into their own expression language.


# Column name patterns that suggest a sex/gender variable ---------------------
.sex_col_patterns <- c("^sex$", "^gender$", "^sexe$", "^genre$", "sex_at_birth")

# Lower-cased option values that indicate female
.female_values <- c("female", "f", "femme", "fem", "2", "mujer")

# Column name patterns for pregnancy / obstetric variables
.preg_col_patterns <- c(
  "preg", "deliver", "trimester", "gravid", "parity",
  "^lmp$", "postpartum", "lactating", "breastfeed"
)


# Detect the sex/gender column in a set of column names -----------------------

detect_sex_col <- function(col_names) {
  for (pat in .sex_col_patterns) {
    m <- grep(pat, col_names, ignore.case = TRUE, value = TRUE)
    if (length(m) > 0L) return(m[1L])
  }
  NULL
}


# Find the female-indicating option value from a variable's options data frame -

detect_female_val <- function(options_df) {
  if (is.null(options_df) || nrow(options_df) == 0L) return(NULL)
  idx   <- match(tolower(options_df$option_name), .female_values)
  found <- options_df$option_name[!is.na(idx)]
  if (length(found) > 0L) found[1L] else NULL
}


# Check whether a column name suggests a pregnancy / obstetric variable -------

detect_preg_col <- function(col_name) {
  any(vapply(
    .preg_col_patterns,
    function(p) grepl(p, col_name, ignore.case = TRUE),
    logical(1)
  ))
}


# Return the observed numeric bounds of a column, or NULL ---------------------
#
# Returns a list(lo, hi) where lo = floor(min) and hi = ceiling(max).
# Returns NULL when the column is all-NA or has only a single unique value
# (a single value produces a vacuous constraint).

detect_numeric_bounds <- function(col) {
  vals <- stats::na.omit(col)
  if (length(vals) == 0L) return(NULL)
  lo <- floor(min(vals))
  hi <- ceiling(max(vals))
  if (lo == hi) return(NULL)
  list(lo = lo, hi = hi)
}

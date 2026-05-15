# ODK XLSForm-specific components for gen_dict.
#
# This file contains only things that are specific to the ODK XLSForm format:
#   - odk_infer_type()      R class → ODK type string
#   - odk_constraint_expr() numeric bounds → XPath constraint
#   - odk_constraint_msg()  numeric bounds → English constraint message
#   - odk_relevant_expr()   sex col + female value → XPath relevant condition
#   - to_odk()              epidict tibble → XLSForm sheet list


#' Translate an epidict tibble to an ODK XLSForm list
#'
#' Takes a dictionary tibble in epidict format (as returned by [gen_dict()] or
#' [read_dict()]) and produces the three-sheet list expected by an ODK
#' XLSForm: `survey`, `choices`, and `settings`. This is the inverse
#' operation of [read_dict()] with `format = "ODK"`.
#'
#' @param dict A tibble in epidict format.
#' @param form_title Optional character; written to the settings sheet.
#'   Defaults to `"Generated dictionary"`.
#' @param form_id Optional character; written to the settings sheet. Derived
#'   from `form_title` if not supplied.
#'
#' @return Named list with elements `survey`, `choices`, `settings`, ready
#'   to write with [write_dict()] or `writexl::write_xlsx()`.
#'
#' @export
to_odk <- function(dict, form_title = NULL, form_id = NULL) {

  # Survey sheet: reconstruct "select_one <list>" type strings
  type_str <- ifelse(
    !is.na(dict$value_type),
    paste0(dict$value_type, " ", dict$type),
    dict$type
  )

  survey <- data.frame(
    type               = type_str,
    name               = dict$name,
    label              = dict$label,
    hint               = dict$hint,
    required           = dict$required,
    relevant           = dict$relevant,
    constraint         = dict$constraint,
    constraint_message = dict$constraint_message,
    stringsAsFactors   = FALSE
  )

  # Choices sheet: unnest options, deduplicate shared lists (e.g. yes_no)
  choices_rows <- lapply(dict$options, function(opts) {
    if (is.null(opts) || nrow(opts) == 0L) return(NULL)
    data.frame(
      list_name = opts$option_list_name,
      name      = opts$option_name,
      label     = if ("option_label" %in% names(opts)) opts$option_label
                  else opts$option_name,
      stringsAsFactors = FALSE
    )
  })
  choices_rows <- Filter(Negate(is.null), choices_rows)

  if (length(choices_rows) == 0L) {
    choices <- data.frame(
      list_name = character(), name = character(), label = character(),
      stringsAsFactors = FALSE
    )
  } else {
    choices <- unique(do.call(rbind, choices_rows))
    rownames(choices) <- NULL
  }

  # Settings sheet
  if (is.null(form_title)) form_title <- "Generated dictionary"
  if (is.null(form_id))    form_id    <- gsub("[^a-zA-Z0-9_]", "_", tolower(form_title))

  settings <- data.frame(
    form_title = form_title,
    form_id    = form_id,
    version    = format(Sys.Date(), "%Y%m%d"),
    stringsAsFactors = FALSE
  )

  list(survey = survey, choices = choices, settings = settings)
}


# Infer the ODK type string for a single column --------------------------------
#
# Returns strings like "select_one sex", "integer", "date", "text" that are
# used in the ODK survey sheet `type` column.

odk_infer_type <- function(col, col_name, max_choices, id_cols) {
  if (!is.null(id_cols) && col_name %in% id_cols) return("text")
  if (inherits(col, "Date"))                       return("date")
  if (inherits(col, c("POSIXct", "POSIXlt")))      return("dateTime")
  if (is.logical(col))                             return("select_one yes_no")
  if (is.factor(col))                              return(paste0("select_one ", col_name))

  n_unique <- length(unique(stats::na.omit(col)))

  if (is.integer(col))
    return(if (n_unique <= max_choices) paste0("select_one ", col_name) else "integer")
  if (is.numeric(col))
    return(if (n_unique <= max_choices) paste0("select_one ", col_name) else "decimal")
  if (is.character(col))
    return(if (n_unique <= max_choices) paste0("select_one ", col_name) else "text")
  "text"
}


# ODK XPath constraint expression from numeric bounds -------------------------

odk_constraint_expr <- function(lo, hi) {
  sprintf(". >= %g and . <= %g", lo, hi)
}


# English constraint message from numeric bounds ------------------------------

odk_constraint_msg <- function(lo, hi) {
  sprintf("Value must be between %g and %g", lo, hi)
}


# ODK XPath relevant expression for a sex-conditional variable ----------------

odk_relevant_expr <- function(sex_col, female_val) {
  sprintf("${%s} = '%s'", sex_col, female_val)
}

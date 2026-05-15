#' Generate a data dictionary from a data frame
#'
#' Creates a data dictionary from an existing data frame in the same format
#' as [read_dict()] and [msf_dict()], so the result can be passed directly
#' to [gen_data()] to produce fake data, or used with \pkg{matchmaker} for
#' recoding. Variable labels and value labels are read from \pkg{labelled}
#' attributes if present (e.g. data imported via \pkg{haven} from Stata/SPSS).
#'
#' The primary workflow this enables is:
#' \enumerate{
#'   \item User runs \code{gen_dict(their_linelist)} and shares the resulting
#'     dictionary instead of their raw data.
#'   \item Recipient calls [gen_data()] (or the \code{dict} argument directly)
#'     to generate a realistic fake dataset for code development.
#' }
#'
#' @param x A data frame.
#' @param format Character; target format. Currently only \code{"odk"} is
#'   supported.
#' @param path Optional file path ending in \code{.xlsx}. If provided the
#'   dictionary is written via [write_dict()] and returned invisibly. If
#'   \code{NULL} (default) the epidict tibble is returned directly.
#' @param constraints Logical; if \code{TRUE} (default) adds constraint
#'   expressions for numeric variables (min/max from the data) and
#'   relevant conditions for pregnancy-related variables (shown only when
#'   sex is female). Constraint messages are in English.
#' @param max_choices Integer; maximum number of unique non-NA values before a
#'   character or integer column is treated as free text rather than
#'   categorical. Default \code{20}.
#' @param id_cols Character vector of column names to force to type \code{text}
#'   regardless of content (e.g. unique identifiers).
#' @param clean Logical; if \code{TRUE} (default) variable names and choice
#'   values are converted to lower snake case via [tidy_labels()], matching
#'   the behaviour of [read_dict()].
#' @param ... Additional arguments passed to the format writer (e.g.
#'   \code{form_title}, \code{form_id} for ODK). See [to_odk()].
#'
#' @return A tibble in epidict format (same structure as [read_dict()] with
#'   \code{compact = TRUE}): one row per variable with columns \code{name},
#'   \code{type}, \code{label}, \code{value_type}, \code{hint},
#'   \code{required}, \code{relevant}, \code{constraint},
#'   \code{constraint_message}, and a nested \code{options} column. Returned
#'   invisibly when \code{path} is given.
#'
#' @importFrom tibble tibble
#' @export
gen_dict <- function(x, format = "odk", path = NULL, constraints = TRUE,
                     max_choices = 20, id_cols = NULL, clean = TRUE, ...) {
  stopifnot(is.data.frame(x))
  format <- match.arg(format, "odk")

  dict <- gen_dict_core(x,
    constraints = constraints,
    max_choices = max_choices,
    id_cols     = id_cols,
    clean       = clean
  )

  if (!is.null(path)) {
    write_dict(dict, path = path, format = format, ...)
    invisible(dict)
  } else {
    dict
  }
}


#' Write an epidict tibble to an Excel file
#'
#' Translates a dictionary tibble (as returned by [gen_dict()]) to the target
#' format and writes it as an \code{.xlsx} file. Requires the \pkg{writexl}
#' package.
#'
#' @param dict A tibble in epidict format (output of [gen_dict()]).
#' @param path File path to write (should end in \code{.xlsx}).
#' @param format Character; target format. Currently only \code{"odk"}.
#' @param ... Additional arguments passed to the format translator (e.g.
#'   \code{form_title}, \code{form_id} for [to_odk()]).
#'
#' @return \code{path}, invisibly.
#' @export
write_dict <- function(dict, path, format = "odk", ...) {
  if (!requireNamespace("writexl", quietly = TRUE)) {
    stop(
      "Package 'writexl' is required to write dictionaries. ",
      "Install with: install.packages('writexl')",
      call. = FALSE
    )
  }
  format <- match.arg(format, "odk")
  xlsform <- switch(format, odk = to_odk(dict, ...))
  writexl::write_xlsx(xlsform, path = path)
  message("Dictionary written to: ", path)
  invisible(path)
}


# Build the epidict tibble from a data frame -----------------------------------
#
# The epidict tibble format matches read_dict(format = "ODK", compact = TRUE),
# so type strings (e.g. "select_one", "integer") and constraint/relevant
# expressions use ODK/XPath conventions throughout. to_*() translators take
# this tibble and reshape it into their own sheet structure.

gen_dict_core <- function(x, constraints = TRUE,
                          max_choices = 20, id_cols = NULL, clean = TRUE) {

  col_names <- if (clean) tidy_labels(names(x)) else names(x)

  # Type strings follow ODK conventions ("select_one <list>", "integer", etc.)
  # because the epidict tibble format matches read_dict(format = "ODK") output.
  types <- vapply(
    seq_along(x),
    function(i) odk_infer_type(x[[i]], col_names[i], max_choices, id_cols),
    character(1)
  )

  # Split "select_one <list>" into value_type + raw type (list name or primitive)
  has_select  <- grepl("^select_(one|multiple) ", types)
  value_types <- ifelse(has_select, sub(" .*", "", types), NA_character_)
  raw_types   <- sub("^select_(one|multiple) ", "", types)

  # Variable labels: labelled::var_label() if present, else cleaned column name
  labels <- vapply(
    seq_along(x),
    function(i) dict_var_label(x[[i]], col_names[i]),
    character(1)
  )

  # Nested options data frame for each variable (shared, format-agnostic)
  options_list <- vector("list", length(col_names))
  for (i in seq_along(col_names)) {
    options_list[[i]] <- if (!is.na(value_types[i]))
      dict_build_options(x[[i]], raw_types[i], clean)
    else
      dict_empty_options()
  }

  # Constraint and relevant columns using format-specific expression formatters
  constraint_col <- rep(NA_character_, length(col_names))
  constr_msg_col <- rep(NA_character_, length(col_names))
  relevant_col   <- rep(NA_character_, length(col_names))

  if (constraints) {
    # Detection is format-agnostic (gen_dict_constraints.R)
    sex_col    <- detect_sex_col(col_names)
    female_val <- if (!is.null(sex_col)) {
      idx <- match(sex_col, col_names)
      if (!is.na(idx)) detect_female_val(options_list[[idx]]) else NULL
    } else {
      NULL
    }

    for (i in seq_along(col_names)) {
      if (raw_types[i] %in% c("integer", "decimal")) {
        bounds <- detect_numeric_bounds(x[[i]])
        if (!is.null(bounds)) {
          constraint_col[i] <- odk_constraint_expr(bounds$lo, bounds$hi)
          constr_msg_col[i] <- odk_constraint_msg(bounds$lo, bounds$hi)
        }
      }
      if (!is.null(sex_col) && !is.null(female_val) && detect_preg_col(col_names[i])) {
        relevant_col[i] <- odk_relevant_expr(sex_col, female_val)
      }
    }
  }

  tibble::tibble(
    name               = col_names,
    type               = raw_types,
    label              = labels,
    value_type         = value_types,
    hint               = NA_character_,
    required           = NA_character_,
    relevant           = relevant_col,
    constraint         = constraint_col,
    constraint_message = constr_msg_col,
    options            = options_list
  )
}


# Extract variable label, preferring labelled::var_label() --------------------

dict_var_label <- function(col, fallback) {
  if (requireNamespace("labelled", quietly = TRUE)) {
    lbl <- labelled::var_label(col)
    if (!is.null(lbl) && nchar(as.character(lbl)) > 0L) return(as.character(lbl))
  }
  fallback
}


# Build the nested options data frame for one categorical variable -------------
#
# Produces columns: option_list_name, option_name, option_label,
# option_order_in_set — matching the structure from read_dict() so that the
# result works with gen_data() and matchmaker.

dict_build_options <- function(col, list_name, clean) {

  # Logical columns always map to a standard yes/no list
  if (list_name == "yes_no") {
    return(data.frame(
      option_list_name    = "yes_no",
      option_name         = c("yes", "no"),
      option_label        = c("Yes", "No"),
      option_order_in_set = 1:2,
      stringsAsFactors    = FALSE
    ))
  }

  # Use labelled value labels if available (names = display labels, values = codes)
  val_lbl <- NULL
  if (requireNamespace("labelled", quietly = TRUE)) {
    val_lbl <- labelled::val_labels(col)
  }

  if (!is.null(val_lbl) && length(val_lbl) > 0L) {
    codes     <- as.character(unname(val_lbl))
    labels    <- names(val_lbl)
    names_out <- if (clean) tidy_labels(codes) else codes
  } else {
    raw_vals  <- if (is.factor(col)) as.character(levels(col))
                 else as.character(sort(unique(stats::na.omit(col))))
    names_out <- if (clean) tidy_labels(raw_vals) else raw_vals
    labels    <- raw_vals
  }

  # Guard against empty strings produced by tidy_labels (e.g. purely punctuation)
  empty <- nchar(names_out) == 0L
  names_out[empty] <- paste0("opt_", which(empty))

  data.frame(
    option_list_name    = list_name,
    option_name         = names_out,
    option_label        = labels,
    option_order_in_set = seq_along(names_out),
    stringsAsFactors    = FALSE
  )
}


# Empty options data frame (for non-categorical variables) --------------------

dict_empty_options <- function() {
  data.frame(
    option_list_name    = character(),
    option_name         = character(),
    option_label        = character(),
    option_order_in_set = integer(),
    stringsAsFactors    = FALSE
  )
}

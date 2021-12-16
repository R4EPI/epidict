#' Helper for aligning your data to the dictionary
#'
#' @export
#' @param disease Specify which disease you would like to use.
#'   Currently supports "Cholera", "Measles", "Meningitis", "AJS",
#'   "Mortality", "Nutrition", "Vaccination_short" and "Vaccination_long".
#'
#' @param varnames Specify name of column that contains varnames. Currently
#'   default set to "data_element_shortname".
#'   If `dictionary` is a survey ("Mortality", "Nutrition", "Vaccination_short"
#'   or "Vaccination_long") `varnames` needs to be "name"`.
#'
#' @param copy_to_clipboard if `TRUE` (default), the rename template will be
#'   copied to the user's clipboard with [clipr::write_clip()]. If `FALSE`, the
#'   rename template will be printed to the user's console.
#'
#' @return a dplyr command used to rename columns in your data frame according
#' to the dictionary
msf_dict_rename_helper <- function(disease, varnames = "data_element_shortname", copy_to_clipboard = TRUE) {

  # make disease name lower case
  disease <- tolower(disease)

  # get msf disease specific outbreak data dictionary
  if (disease == "cholera" | disease ==  "measles" |
      disease == "meningitis" | disease == "ajs") {

    dat_dict <- msf_dict(disease = disease, compact = TRUE)

    # define the name of the column in the dictionary which has variable class
    var_type_col <- "data_element_valuetype"
  }

  # get msf disease specific survey data dictionary
  if (disease == "mortality" | disease == "nutrition" |
      disease == "vaccination_short" | disease == "vaccination_long") {

    dat_dict <- msf_dict_survey(disease, compact = TRUE)

    # define the name of the column in the dictionary which has variable class
    var_type_col <- "type"
  }

  # change vaccinations to be one
  if (disease == "vaccination_short" | disease == "vaccination_long") {

    disease  <- "vaccination"
  }

  # get the outbreak Rmd to check if the variable is optional or required
  outbreak_file <- available_sitrep_templates(recursive = TRUE, pattern = ".Rmd", full.names = TRUE)
  outbreak_file <- grep(disease, outbreak_file, value = TRUE)[[1]]
  outbreak_file <- readLines(outbreak_file)

  dat_dict[["var_required"]] <- vapply(dat_dict[[varnames]],
    FUN = function(i, o) if (any(grepl(paste0("^[^#]*", i), o))) "REQUIRED" else "optional",
    FUN.VALUE = character(1),
    o = outbreak_file
  )
  dat_dict <- dat_dict[order(dat_dict[["var_required"]] != "REQUIRED",
                             dat_dict[[varnames]]), ]
  msg <- "## Add the appropriate column names after the equals signs\n\n"
  msg <- paste0(msg, "linelist_cleaned <- rename(linelist_cleaned,\n")
  the_renames <- sprintf("  %s =   , # %s (%s)",
    format(dat_dict[[varnames]]),
    format(dat_dict[[var_type_col]]),
    dat_dict[["var_required"]]
  )
  the_renames[length(the_renames)] <- gsub(",", " ", the_renames[length(the_renames)])
  msg <- paste0(msg, paste(the_renames, collapse = "\n"), "\n)\n")
  if (copy_to_clipboard) {
    x <- try(clipr::write_clip(msg), silent = TRUE)
    if (inherits(x, "try-error")) {
      if (interactive()) cat(msg)
      return(invisible())
    }
    message("rename template copied to clipboard. Paste the contents to your RMarkdown file and enter in the column names from your data set.")
  } else {
    cat(msg)
  }
}


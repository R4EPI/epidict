#' Helper for aligning your data to a standardised dictionary or your own dictionary.
#'
#' @export
#' @param disease Specify which disease you would like to use.
#' Currently supports "Cholera", "Measles", "Meningitis", "AJS",
#' "Mortality", "Nutrition", "Vaccination_short" and "Vaccination_long".
#'
#' @param name The name of the dictionary stored in the package. The default is
#' NULL and will use dictionaries from the package. However you can also use
#' dictionaries not stored within this package, to use these:
#' specify `name`as path to .xlsx file and set the `template = False` - nb. this
#' needs to be a dataframe containing `varnames` and `varnames_type`. You will also
#' need to specify a path to `rmd`.
#'
#' @param varnames The name of column that contains variable names. The
#' default set to "data_element_shortname".
#' If `dictionary` is a survey ("Mortality", "Nutrition", "Vaccination_short"
#' or "Vaccination_long") `varnames` needs to be "name"`. Otherwise if using
#' your own dictionary then specify.
#'
#' @param varnames_type The name of column that contains the variable type.
#' The default is NULL and will use "data_element_valuetype" for DHIS2 and "type"
#' for Kobo dictionaries. If you specify your own dictionary then this needs to
#' be the same length as `varnames` in your dictionary.
#'
#' @param rmd The Rmarkdown template which you would like to compare to. Default
#' is NULL and will use those included in the package. However you can also use
#' Rmarkdowns not stored within this package, to use these:
#' specify `rmd`as path to .rmd file and set the `template = False`; nb. you will
#' need to specify a path to file in `name`containing `varnames` and `varnames_type`.
#'
#' @param template If `TRUE` (default) read in a generic
#' dictionary and Rmarkdown based on the MSF OCA ERB pre-approved template.
#' However you can also specify your own dictionary if this differs substantially,
#' by setting `template = FALSE`.
#'
#' @param copy_to_clipboard if `TRUE` (default), the rename template will be
#'   copied to the user's clipboard with [clipr::write_clip()]. If `FALSE`, the
#'   rename template will be printed to the user's console.
#'
#' @return A dplyr command used to rename columns in your data frame according
#' to the dictionary
#'
#' @importFrom readxl read_excel

msf_dict_rename_helper <- function(disease,
                                   name = NULL,
                                   varnames = "data_element_shortname",
                                   varnames_type = NULL,
                                   rmd = NULL,
                                   template = TRUE,
                                   copy_to_clipboard = TRUE) {

  ## TODO:
  ## clean up varnames and varnames_type so it all fits down below

  if (template) {

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

    # remove long and short from vaccination (only one template with 2 dicts)
    if (disease == "vaccination_short" | disease == "vaccination_long") {

      disease  <- "vaccination"
    }

    # get the outbreak Rmd to check if the variable is optional or required
    outbreak_file <- available_sitrep_templates(recursive = TRUE, pattern = ".Rmd", full.names = TRUE)
    outbreak_file <- grep(disease, outbreak_file, value = TRUE)[[1]]

  } else {

    ## if not template - i.e. reading in own dictionary/rmd - define bits here
    dat_dict <- readxl::read_excel(name)
    outbreak_file <- rmd
    varnames <- varnames
    var_type_col <- varnames_type


  }

  # pull in the rmd file
  outbreak_file <- readLines(outbreak_file)

  # for each of the variables - search in the rmd
  # (if found then set to required else optional)
  dat_dict[["var_required"]] <- vapply(dat_dict[[varnames]],
    FUN = function(i, o) if (any(grepl(paste0("^[^#]*", i), o))) "REQUIRED" else "optional",
    FUN.VALUE = character(1),
    o = outbreak_file
  )

  # move the required variables to the top
  dat_dict <- dat_dict[order(dat_dict[["var_required"]] != "REQUIRED",
                             dat_dict[[varnames]]), ]
  # pull together instructions for where users should input recodes
  msg <- "## Add the appropriate column names after the equals signs\n\n"
  msg <- paste0(msg, "linelist_cleaned <- rename(linelist_cleaned,\n")
  the_renames <- sprintf("  %s =   , # %s (%s)",
    format(dat_dict[[varnames]]),
    format(dat_dict[[var_type_col]]),
    dat_dict[["var_required"]]
  )
  # remove commas
  the_renames[length(the_renames)] <- gsub(",", " ", the_renames[length(the_renames)])
  # add linebreaks between
  msg <- paste0(msg, paste(the_renames, collapse = "\n"), "\n)\n")
  # add output to clipboard
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


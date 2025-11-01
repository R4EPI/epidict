#' Helper for aligning your data to MSF standardised dictionaries and analysis templates.
#'
#' @param dictionary Specify which MSF dictionary you would like to use.
#' See [msf_dict()] for options.
#'
#' @param copy_to_clipboard if `TRUE` (default), the rename template will be
#'   copied to the user's clipboard with [clipr::write_clip()]. If `FALSE`, the
#'   rename template will be printed to the user's console.
#'
#' @return A dplyr command used to rename columns in your data frame according
#' to the dictionary
#'
#' @importFrom readxl read_excel
#'
#' @export

msf_dict_rename_helper <- function(dictionary,
                                   copy_to_clipboard = TRUE) {

  # just add dict as "empty" if not defined (for checking errors)
  if (missing("dictionary")) {
    dictionary <- "empty"
    }

  # define dictionary types
  dict <- get_dictionary(dictionary, org = "MSF")
  disease <- unlist(dict, use.names = FALSE)
  is_survey <- length(dict$survey) == 1
  format <- ifelse(is_survey | grepl("_intersectional", disease),
                  "ODK", "DHIS2")

  # get dictionary
  dat_dict <- msf_dict(dictionary = disease, compact = TRUE)

  # define the dictionary columns for variable names and variable type
  varnames <- ifelse(format == "ODK", "name", "data_element_shortname")
  varnames_type <- ifelse(format == "ODK", "type", "data_element_valuetype")

  # remove long and short from vaccination (only one template with 2 dicts)
  if (disease == "vaccination_short" | disease == "vaccination_long") {
    disease  <- "vaccination"
  }

  # only call sitrep if it's installed
  if (!requireNamespace("sitrep", quietly = TRUE)) {
    stop(
      "The 'sitrep' package is required for this function but is not installed.\n",
      "Please install it from GitHub: R4EPI/sitrep"
    )
  }

  # get the outbreak Rmd to check if the variable is optional or required
  outbreak_file <- sitrep::available_sitrep_templates(recursive = TRUE, pattern = ".Rmd", full.names = TRUE)
  outbreak_file <- grep(tolower(disease), outbreak_file, value = TRUE)[[1]]

  # call the dict_rename_helper function
  dict_rename_helper(
    dictionary = dat_dict,
    varnames = varnames,
    varnames_type = varnames_type,
    rmd = outbreak_file,
    copy_to_clipboard = copy_to_clipboard
  )

}


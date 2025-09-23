#' MSF data dictionaries and dummy datasets
#'
#' These function produce MSF dictionaries based on DHIS2 (for OCA outbreaks)
#' and ODK (for intersectional outbreaks and surveys) data sets defining the 
#' data element name, code, short names, types, and key/value pairs for 
#' translating the codes into human-readable format.
#'
#' @param dictionary Specify which dictionary you would like to use.
#'   - MSF OCA outbreaks include: "AJS", "Cholera", "Measles", "Meningitis"
#'   - MSF intersectional outbreaks include: "AJS_intersectional", "Cholera_intersectional",
#'     "Diphtheria_intersectional", "Measles_intersectional", "Meningitis_intersectional"
#'   - MSF OCA surveys include "Mortality", "Nutrition", "Vaccination_long",
#'    "Vaccination_short" and "ebs"
#'
#' @param tibble If `TRUE` (default), return data dictionary as a 
#'    tidyverse tibble otherwise will return a list. 
#' 
#' @param long If `TRUE` (default), the returned data dictionary is in long
#'   format with each option getting one row. If `FALSE`, then two data frames
#'   are returned, one with variables and the other with content options.
#'
#' @param compact If `TRUE` (default), then a nested data frame is returned
#'   where each row represents a single variable and a nested data frame column
#'   called "options", which can be expanded with [tidyr::unnest()]. This only
#'   works if `long = TRUE`.
#'
#' @seealso [read_dict()] [gen_data()] [matchmaker::match_df()] 
#' @export
#' @examples
#'
#' if (require("dplyr") & require("matchmaker")) {
#'   withAutoprint({
#'     # You will often want to use MSF dictionaries to translate codes to human-
#'     # readable variables. Here, we generate a data set of 20 cases:
#'     dat <- gen_data(
#'       dictionary = "Cholera",
#'       varnames = "data_element_shortname",
#'       numcases = 20,
#'       org = "MSF"
#'     )
#'     print(dat)
#'
#'     # We want the expanded dictionary, so we will select `compact = FALSE`
#'     dict <- msf_dict(dictionary = "Cholera", long = TRUE, compact = FALSE, tibble = TRUE)
#'     print(dict)
#'
#'     # Now we can use matchmaker to filter the data:
#'     dat_clean <- matchmaker::match_df(dat, dict,
#'       from = "option_code",
#'       to = "option_name",
#'       by = "data_element_shortname",
#'       order = "option_order_in_set"
#'     )
#'     print(dat_clean)
#'   })
#' }
msf_dict <- function(dictionary, 
                     tibble = TRUE, 
                     long = TRUE,
                     compact = TRUE) {
  
  # define dictionary types 
  dict <- get_dictionary(dictionary, org = "MSF")
  disease <- unlist(dict, use.names = FALSE)
  is_survey <- length(dict$survey) == 1
  format <- ifelse(is_survey | grepl("_intersectional", disease), 
                  "ODK", "DHIS2")

  if (length(disease) == 0) {
    stop("disease must be one of the supported dictionaries", call. = FALSE)
  }

  if (is_survey) {
    name <- "MSF-survey-dict.xlsx"
  } else if (grepl("_intersectional", disease)) {
    name <- "MSF-outbreak-intersectional-dict.xlsx"
    disease <- gsub("_intersectional", "", disease)
  } else {
    name <- "MSF-outbreak-dict.xlsx"
  }

  # get excel file path (need to specify the file name)
  path <- system.file("extdata", name, package = "epidict")

  read_dict(path = path, sheet = disease, format = format, 
            tibble = tibble, long = long, compact = compact)

}

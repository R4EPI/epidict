#' WHO data dictionaries and dummy datasets
#'
#' These function produces WHO AFRO dictionaries based on excel data sets
#' defining the data element name, code, short names, types, and key/value pairs
#' for translating the codes into human-readable format.Nb dictionary format is
#' based of MSF OCA DHIS2.
#'
#' @param disease Specify which disease you would like to use.
#'   - `who_dict()` supports "Cholera"
#'
#' @param name the name of the dictionary stored in the package.
#'
#' @param tibble Return data dictionary as a tidyverse tibble (default is TRUE)
#'
#' @param compact if `TRUE` (default), then a nested data frame is returned
#'   where each row represents a single variable and a nested data frame column
#'   called "options", which can be expanded with [tidyr::unnest()]. This only
#'   works if `long = TRUE`.
#'
#' @param long If `TRUE` (default), the returned data dictionary is in long
#'   format with each option getting one row. If `FALSE`, then two data frames
#'   are returned, one with variables and the other with content options.
#'
#' @seealso [matchmaker::match_df()] [gen_data()] [msf_dict()] [msf_dict_survey()]
#' @export
#' @examples
#'
#' if (require("dplyr") & require("matchmaker")) {
#'   withAutoprint({
#'     # You will often want to use WHO dictionaries to translate codes to human-
#'     # readable variables. Here, we generate a data set of 20 cases:
#'     dat <- gen_data(
#'       dictionary = "Cholera",
#'       varnames = "data_element_shortname",
#'       numcases = 20,
#'       org = "WHO"
#'     )
#'     print(dat)
#'
#'     # We want the expanded dictionary, so we will select `compact = FALSE`
#'     dict <- who_dict(disease = "Cholera", long = TRUE, compact = FALSE, tibble = TRUE)
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
who_dict <- function(disease, name = "WHO-outbreak-dict.xlsx", tibble = TRUE,
                     compact = TRUE, long = TRUE) {
  disease <- get_dictionary(disease, org = "WHO")$outbreak

  if (length(disease) == 0) {
    stop("disease must be one of 'Cholera', 'Lassa fever', 'Measles', 'Yellow fever'", call. = FALSE)
  }

  # get excel file path (need to specify the file name)
  path <- system.file("extdata", name, package = "epidict")

  # read in categorical variable content options
  dat_opts <- readxl::read_xlsx(path, sheet = "OptionCodes")

  # read in data set - pasting the disease name for sheet
  dat_dict <- readxl::read_xlsx(path, sheet = disease)

  # clean col names
  colnames(dat_dict) <- tidy_labels(colnames(dat_dict))
  colnames(dat_opts) <- tidy_labels(colnames(dat_opts))

  # clean future var names
  # excel names (data element shortname)
  # csv names (data_element_name)
  dat_dict$data_element_shortname <- tidy_labels(dat_dict$data_element_shortname)
  dat_dict$data_element_name <- tidy_labels(dat_dict$data_element_name)

  # Adding hardcoded var types to options list
  # 2 types added to - BOOLEAN, TRUE_ONLY
  BOOLEAN <- data.frame(
    option_code = c("1", "0"),
    option_name = c("[1] Yes", "[0] No"),
    option_uid = c(NA, NA),
    option_order_in_set = c(1, 2),
    optionset_uid = c("BOOLEAN", "BOOLEAN")
  )

  TRUE_ONLY <- data.frame(
    option_code = c("1", "NA"),
    option_name = c("[1] TRUE", "[NA] Not TRUE"),
    option_uid = c(NA, NA),
    option_order_in_set = c(1, 2),
    optionset_uid = c("TRUE_ONLY", "TRUE_ONLY")
  )

  # bind these on to the bottom of dat_opts (option list) as rows
  suppressWarnings(dat_opts <- dplyr::bind_rows(dat_opts, BOOLEAN, TRUE_ONLY))



  # add the unique identifier to link above three in dictionary to options list
  for (i in c("BOOLEAN", "TRUE_ONLY")) {
    dat_dict$used_optionset_uid[dat_dict$data_element_valuetype == i] <- i
  }

  # remove back end codes from front end var in the options list
  dat_opts$option_name <- gsub("^\\[.*\\] ", "", dat_opts$option_name)

  if (long) {
    outtie <- dplyr::left_join(dat_dict, dat_opts,
                               by = c("used_optionset_uid" = "optionset_uid")
    )

    outtie <- if (tibble) tibble::as_tibble(outtie) else outtie

    # Return second option: a list with data dictionary and value options seperate
  } else {
    if (tibble) {
      dat_dict <- tibble::as_tibble(dat_dict)
      dat_opts <- tibble::as_tibble(dat_opts)
    }
    outtie <- list(
      dictionary = dat_dict,
      options    = dat_opts
    )
  }

  # produce clean compact data dictionary for use in gen_data
  if (long && compact == TRUE) {
    squished <- dplyr::group_by(outtie, !!quote(data_element_shortname))

    if (utils::packageVersion("tidyr") > "0.8.99") {
      squished <- tidyr::nest(squished, options = dplyr::starts_with("option_"))
    } else {
      squished <- tidyr::nest(squished, dplyr::starts_with("option_"), .key = "options")
      outtie <- dplyr::select(outtie, -dplyr::starts_with("option_"))
      outtie <- dplyr::distinct(outtie)
      squished <- dplyr::left_join(outtie, squished, by = "data_element_shortname")
    }
    return(dplyr::ungroup(squished))
  }

  # return dictionary dataset
  outtie
}

#' Data dictionaries
#'
#' These function read dictionaries in ODK and DHIS2  formats, and reformats them 
#' for dataset recoding into human-readable format. 
#'
#' @param name Define the path to .xlsx file where the dictionary is stored
#' 
#' @param sheet Optional, if your sheets have non-standard names 
#'    (using a disease pre-fix) - this can be specified here. 
#' 
#' @param format The format which the dictionary is in. Currently supports 
#'    "DHIS2" and "ODK". 
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
#' @importFrom readxl read_excel
#' @importFrom dplyr bind_rows left_join group_by mutate ungroup select distinct starts_with n
#' @importFrom tidyr nest
#' @importFrom tibble as_tibble
#' @importFrom utils packageVersion
#' 
#' @export


read_dict <- function(name, sheet, format, 
                     tibble = TRUE, long = TRUE, compact = TRUE) {
  
  #### import dictionaries 

  if (format == "DHIS2")  {

  # read in categorical variable content options
  dat_opts <- readxl::read_excel(name, sheet = "OptionCodes")

  # read in data set - pasting the disease name for sheet
  dat_dict <- readxl::read_excel(name, sheet = sheet)

  }

  if (format == "ODK") {

    if(!missing(sheet)) {
    # read in data set - pasting the disease name for sheet
    dat_dict <- readxl::read_excel(name, sheet = sheet)

    # read in categorical variable content options
    dat_opts <- readxl::read_excel(name, sheet = sprintf("%s_options", sheet))

    } else {
    # read in data set
    dat_dict <- readxl::read_excel(name, sheet = "survey")

    # read in categorical variable content options
    dat_opts <- readxl::read_excel(name, sheet = "choices")

    }

  }

  #### clean dictionaries 

  # clean col names
  colnames(dat_dict) <- tidy_labels(colnames(dat_dict))
  colnames(dat_opts) <- tidy_labels(colnames(dat_opts))

  if (format == "DHIS2")  {
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
  }

  if (format == "ODK") {
    # clean future var names
    dat_dict$name <- tidy_labels(dat_dict$name)

    # prepend "option" to options dataset (otherwise duplicated column names on merge)
    colnames(dat_opts) <- sprintf("option_%s", colnames(dat_opts))

    # drop rows with grouping variables for repeats (not necessary for generating data)
    grps <- dat_dict$type %in% c("begin_group", "end_group", "begin_repeat", "end_repeat")
    dat_dict <- dat_dict[!grps, , drop = FALSE]

    # create a value type column (for whether select one or multiple)
    # these are usually in the format "select_one THING" where thing is
    # the data being selected, but not standard data types (e.g. yn, village, etc)
    dat_dict$value_type <- NA
    dat_dict$value_type[grep("select_one", dat_dict$type)] <- "select_one"
    dat_dict$value_type[grep("select_multiple", dat_dict$type)] <- "select_multiple"


    # make the type column useful as as unique ID for options
    dat_dict$type <- gsub(
      pattern = "select_one |select_multiple ", # n.b. space significant here
      replacement = "",
      x = dat_dict$type
    )

    # create counts for option order
    dat_opts <- dplyr::group_by(dat_opts, .data$option_list_name)
    dat_opts <- dplyr::mutate(dat_opts, option_order_in_set = seq(dplyr::n()))
    dat_opts <- dplyr::ungroup(dat_opts)
  }

  #### reshape dictionaries 

  if (long) {
    outtie <- dplyr::left_join(dat_dict, dat_opts,
      by = switch(
            format,
            ODK  = c("type" = "option_list_name"),
            DHIS2 = c("used_optionset_uid" = "optionset_uid")
    )
    )

    outtie <- if (tibble) tibble::as_tibble(outtie) else outtie

    # Return second option: a list with data dictionary and value options separate
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
    squished <- dplyr::group_by(outtie, .data[[switch(
                  format,
                  ODK  = "name",
                  DHIS2 = "data_element_shortname")]]
                )

    if (utils::packageVersion("tidyr") > "0.8.99") {
      squished <- tidyr::nest(squished, options = dplyr::starts_with("option_"))
    } else {
      ## not sure this is going to be the case anymore?? can probably delete
      squished <- tidyr::nest(squished, dplyr::starts_with("option_"), .key = "options")
      outtie <- dplyr::select(outtie, -dplyr::starts_with("option_"))
      outtie <- dplyr::distinct(outtie)
      squished <- dplyr::left_join(outtie, squished, by = switch(
        format, 
        ODK = c("type" = "option_list_name"), 
        DHIS2 = "data_element_shortname")
      )
    }
    return(dplyr::ungroup(squished))
  }
  
  # return dictionary dataset
  outtie
  
}

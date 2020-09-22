# function to load MSF data dictionary for mortality surveys

#' @importFrom tibble as_tibble
#' @importFrom tidyr fill spread
#' @importFrom dplyr mutate group_by row_number ungroup
#' @importFrom rlang !!
#' @export
#' @rdname msf_dict
msf_dict_survey <- function(disease, name = "MSF-survey-dict.xlsx",
                            tibble = TRUE, compact = TRUE, long = TRUE) {

  disease <- get_dictionary(disease)$survey

  if (length(disease) == 0) {
    stop("disease must be one of 'Mortality', 'Nutrition', 'Vaccination'", call. = FALSE)
  }
  # get excel file path (need to specify the file name)
  path <- system.file("extdata", name, package = "epidict")

  # read in data set - pasting the disease name for sheet
  dat_dict <- readxl::read_xlsx(path, sheet = disease)

  # read in categorical variable content options
  dat_opts <- readxl::read_xlsx(path, sheet = sprintf("%s_options", disease))

  # clean col names
  colnames(dat_dict) <- tidy_labels(colnames(dat_dict))
  colnames(dat_opts) <- tidy_labels(colnames(dat_opts))

  # clean future var names
  dat_dict$name <- tidy_labels(dat_dict$name)

  # pre-pend "option" to options dataset (otherwise duplicated column names on merge)
  colnames(dat_opts) <- sprintf("option_%s", colnames(dat_opts))

  # drop rows with grouping variables for repeats (not necessary for generating data)
  dat_dict <- dat_dict[!dat_dict$type %in% c("begin_group", "end_group",
                                             "begin_repeat", "end_repeat"), ]

  ## create a value type column (for whether select one or multiple)
  dat_dict$value_type <- NA
  dat_dict$value_type[grep("select_one", dat_dict$type)] <- "select_one"
  dat_dict$value_type[grep("select_multiple", dat_dict$type)] <- "select_multiple"


  # make the type column useful as as unique ID for options
  dat_dict$type <- gsub(
    pattern = "select_one |select_multiple ",
    replacement = "",
    x = dat_dict$type
  )

  # create counts for option order
  dat_opts <- dplyr::group_by(dat_opts, option_list_name)
  dat_opts <- dplyr::mutate(dat_opts, option_order_in_set = seq(dplyr::n()))
  dat_opts <- dplyr::ungroup(dat_opts)


  if (long) {
    outtie <- dplyr::left_join(dat_dict, dat_opts,
                               by = c("type" = "option_list_name")
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
    squished <- dplyr::group_by(outtie, !!quote(name))

    if (utils::packageVersion("tidyr") > "0.8.99") {
      squished <- tidyr::nest(squished, options = dplyr::starts_with("option_"))
    } else {
      ## not sure this is going to be the case anymore?? can probably delete
      squished <- tidyr::nest(squished, dplyr::starts_with("option_"), .key = "options")
      outtie <- dplyr::select(outtie, -dplyr::starts_with("option_"))
      outtie <- dplyr::distinct(outtie)
      squished <- dplyr::left_join(outtie, squished, by = c("type" = "option_list_name"))
    }
    return(dplyr::ungroup(squished))
  }


  # return dictionary dataset
  outtie

}

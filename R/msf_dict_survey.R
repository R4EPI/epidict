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
  dat_opts <- readxl::read_xlsx(path, sheet = sprintf("%s_choices", disease))

  # clean col names
  colnames(dat_dict) <- tidy_labels(colnames(dat_dict))
  colnames(dat_opts) <- tidy_labels(colnames(dat_opts))

  # clean future var names
  dat_dict$name <- tidy_labels(dat_dict$name)

  # pre-pend "choices" to options dataset (otherwise duplicated column names on merge)
  colnames(dat_opts) <- sprintf("choices_%s", colnames(dat_opts))

  # drop rows with grouping variables for repeats (not necessary for generating data)
  dat_dict <- dat_dict[!dat_dict$type %in% c("begin_group", "end_group", "end_repeat"), ]


  # minor tidying, make the type column useful as as unique ID for options
  dat_dict$type <- gsub(
    pattern = "select_one |select_multiple ",
    replacement = "",
    x = dat_dict$type
  )

  # create counts for variable order (not entirely sure this is needed?)
  # dat_dict <- dplyr::mutate(dat_dict, option_order_in_set = seq(dplyr::n()))

  ## recode type to fit to DHIS2 (I dont think this is necessary?)
  # dat_dict$type <- dplyr::case_when(
  #   dat_dict$type == "Integer" ~ "INTEGER_POSITIVE",
  #   dat_dict$type == "Binary" ~ "TEXT",
  #   dat_dict$type == "ChoiceMulti" ~ "MULTI",
  #   dat_dict$type == "Text" ~ "LONG_TEXT",
  #   dat_dict$type == "Geo" ~ "LONG_TEXT",
  #   dat_dict$type == "Date" ~ "DATE",
  #   dat_dict$type == "Choice" ~ "TEXT",
  #   dat_dict$type == "Number" ~ "INTEGER_POSITIVE"
  # )



  if (long) {
    outtie <- dplyr::left_join(dat_dict, dat_opts,
                               by = c("type" = "choices_list_name")
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
      squished <- tidyr::nest(squished, options = dplyr::starts_with("choices_"))
    } else {
      ## not sure this is going to be the case anymore?? can probably delete
      squished <- tidyr::nest(squished, dplyr::starts_with("choices_"), .key = "options")
      outtie <- dplyr::select(outtie, -dplyr::starts_with("choices_"))
      outtie <- dplyr::distinct(outtie)
      squished <- dplyr::left_join(outtie, squished, by = c("type" = "choices_list_name"))
    }
    return(dplyr::ungroup(squished))
  }


  # return dictionary dataset
  outtie

}

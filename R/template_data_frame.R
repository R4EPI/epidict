template_data_frame_categories <- function(dat_dict, numcases, varnames, survey = FALSE) {

  # only keep the variable name and corresponding options column from dictionary
  dat_output <- dat_dict[, c(varnames, "options"), drop = FALSE]

  # create a NEW empty dataframe with the names from the data dictionary
  dis_output <- data.frame(matrix(ncol = nrow(dat_output), nrow = numcases))

  # set names of new dataframe according to dictionary names column
  colnames(dis_output) <- dat_dict[[varnames]]


  if (utils::packageVersion("tidyr") > "0.8.99") {
    categories <- tidyr::unnest(dat_dict, cols = "options")
  } else {
    categories <- tidyr::unnest(dat_dict)
  }
  categories <- dplyr::filter(categories, !is.na(!!quote(option_name)))

  # take samples for vars with defined options (non empties)
  for (i in unique(categories[[varnames]])) {
    vals <- categories[categories[[varnames]] == i, ]
    if (survey) {
      vals <- factor(vals$option_name, vals$option_name[vals$option_order_in_set])
    } else {
      vals <- factor(vals$option_code, vals$option_code[vals$option_order_in_set])
    }
    dis_output[[i]] <- sample(vals, numcases, replace = TRUE)
  }

  if ("data_element_valuetype" %in% names(dat_dict)) {
    # Old Dharma-based dictionaries
    predicate <- dat_dict$data_element_valuetype == "MULTI"
  } else {
    predicate <- dat_dict$value_type == "select_multiple"
  }
  # We use which here to indicate that NA is FALSE.
  multivars <- dat_dict[[varnames]][which(predicate)]

  if (length(multivars) > 0) {
    sample_multivars <- lapply(multivars, sample_cats,
      numcases = numcases,
      df = categories, varnames = varnames
    )
    dis_output[, multivars] <- NULL
    dis_output <- dplyr::bind_cols(dis_output, sample_multivars)
  }

  dis_output
}



# sample of a single value and NA
sample_single <- function(x, size, prob = 0.1) {
  sample(c(x, NA), size = size, prob = c(prob, 1 - prob), replace = TRUE)
}


# random data for one single "MULTI" variable (split into multiple columns)
sample_cats <- function(category, numcases, df, varnames) {
  dat <- df[df[[varnames]] == category, , drop = FALSE]

  lvls <- dat$option_name

  # define suffixes for column names
  suffixes <- sprintf("%s/%s", category, lvls)

  # create columns with randomized lvls with randomized probability
  extra_cols <- vapply(lvls, sample_single,
    FUN.VALUE = character(numcases),
    size = numcases, prob = sample(5:15, 1) / 100
  )

  # fix the original variable so it is a combination of others
  og_fix <- apply(extra_cols, 1, function(x) paste(x[!is.na(x)], collapse = " "))

  # change from character to binary
  extra_cols[!is.na(extra_cols)] <- 1
  extra_cols[is.na(extra_cols)]  <- 0

  # add in original column with combination
  extra_cols <- cbind(og_fix, extra_cols)

  # correct the names
  colnames(extra_cols) <- c(category, suffixes)

  ## change to a dataframe
  as.data.frame(extra_cols, stringsAsFactors = FALSE)

}

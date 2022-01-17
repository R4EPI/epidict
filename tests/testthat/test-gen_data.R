
outbreaks <- c("MeAsles", "CHolera", "AjS", "meningitis")
surveys   <- c("MOrtality", "VaCcination_ShoRt", 'Vaccination_LonG', "NutritIon")

# Functions for checking age columns
get_ages <- function(x) x[grepl("age_(year|month|day)s?$", names(x), perl = TRUE)]
check_exclusive_ages <- function(x, n = 300) {
  # Check that the age columns are all cromulent.
  # There should be a total of `n` ages, but no more, indicating that they
  # are all exclusive
  # Alex: changed to less than or equal because have NAs now
  sum(vapply(x, function(i) sum(i > -1, na.rm = TRUE), integer(1))) <= n
}
check_age_integers <- function(x) {
  all(vapply(x, is.integer, logical(1)))
}

test_that("errors are thrown if the wrong dicts are used", {

  expect_error(msf_dict("Mortality"),
    "disease must be one of 'Cholera', 'Measles', 'Meningitis', or 'AJS'",
    fixed = TRUE
  )
  expect_error(msf_dict_survey("Measles"),
    "disease must be one of 'Mortality', 'Nutrition', 'Vaccination_long', 'Vaccination_short'",
    fixed = TRUE
  )
  expect_error(gen_data("Dada"),
    "'dictionary' must be one of: 'Cholera', 'Measles', 'Meningitis', 'AJS', 'Mortality', 'Nutrition', 'Vaccination_long', 'Vaccination_short'",
    fixed = TRUE
  )

})

test_that("msf_dict works", {

  for (disease in c(outbreaks)) {
    nested  <- msf_dict(disease)
    long    <- msf_dict(disease, compact = FALSE)
    neither <- msf_dict(disease, compact = FALSE, long = FALSE)

    expect_is(nested, "tbl_df", label = disease)
    expect_is(long, "tbl_df", label = disease)

    # neither compact nor long is a list of dictionaries and options
    expect_is(neither, "list", label = disease)
    expect_named(neither, c("dictionary", "options"), label = disease)

    # None of the option names have bracketed arguments in front of them
    expect_false(all(grepl("^\\[", long$option_name)))
    expect_false(all(grepl("^\\[", neither$options$option_name)))

    # rows in the dictionary should equal rows in the nested dictionary
    expect_equal(nrow(neither$dictionary), nrow(nested), label = disease)

    # the number of columns in the long data should be equal to the sum of the
    # columns minus 1 in the separated data sets
    expect_equal(ncol(long), sum(vapply(neither, ncol, integer(1))) - 1L, label = disease)

    # the number of columns in the dictionary should be one less than the number
    # of columns in the nested data.
    expect_equal(ncol(neither$dictionary) + 1L, ncol(nested), label = disease, info = disease)
  }

})

test_that("msf_survey_dict works", {

  for (type in surveys) {
    nested <- msf_dict_survey(type, compact = TRUE)
    long   <- msf_dict_survey(type, compact = FALSE)

    # a tibble is produced
    expect_is(nested, "tbl_df", label = type)
    expect_is(long, "tbl_df", label = type)

    # the correct number of variables produced in both formats
    expect_gt(nrow(long), nrow(nested), label = type)
    expect_gt(ncol(long), ncol(nested), label = type)

  }

})

test_that("outbreak data can be generated", {

  for (disease in c(outbreaks)) {
    dictionary <- msf_dict(disease)
    data       <- gen_data(disease, numcases = 300)

    # a tibble is produced
    expect_is(data, "tbl_df", label = disease)

    # data produced has same number vars as dictionary
    expect_equal(nrow(dictionary), ncol(data), label = disease)

    # ages are all appropriate (functions defined at top)
    expect_true(check_exclusive_ages(get_ages(data), 300))
    expect_true(check_age_integers(get_ages(data)))
  }
})

test_that("survey data can be generated", {

  for (disease in surveys) {
    dictionary <- msf_dict_survey(disease)
    data       <- gen_data(disease, varnames = "name", numcases = 300)

    # check that produces a tibble
    expect_is(data, "tbl_df", label = disease)

    # ages are all appropriate (functions defined at top)
    expect_true(check_exclusive_ages(get_ages(data), 300))
    expect_true(check_age_integers(get_ages(data)))


    # define which var is eligible and interviewed for each dictionary
    eligible <- ifelse(tolower(disease) == "mortality",
                      "member_number",
                      "number_children")

    # check appropriate numbers (existing) for eligible
    # (interviewed doesnt exist anymore)
    # we now have NAs due to adding in non-response
    # (i.e. those who dont consent dont get filled in)
    expect_true(sum(data[[eligible]], na.rm = TRUE) > 0)

    # pull together how many variables there should be

    # drop type "note" and count those with value_type "select_one" or NA
    base_count <- sum(dictionary$value_type %in% c("select_one", NA) &
                        dictionary$type != "note"
                        )

    # add the select_multiples
    multiple_vars <- which(dictionary$value_type == "select_multiple")

    multiple_count <- 0
    for (i in multiple_vars) {
      # original variable also added (therefor add one)
      nums <- nrow(dictionary$options[i][[1]]) + 1
      multiple_count <- multiple_count + nums
    }

    # add the extra IDs generated
    id_counts <- 3

    total_counts <- base_count + multiple_count + id_counts

    # generating the correct number of variables
    expect_equal(total_counts, ncol(data), label = disease)
  }
})



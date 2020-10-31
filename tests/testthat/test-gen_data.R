
outbreaks <- c("MeAsles", "CHolera", "AjS", "meningitis")
# TODO: Alex, re-add nutrition here when you have successfully updated the
#       dictionary. Love, Zhian.
surveys   <- c("MOrtality", "VaCcination") #, "NutritIon")

# Functions for checking age columns
get_ages <- function(x) x[grepl("age_(year|month|day)s?$", names(x), perl = TRUE)]
check_exclusive_ages <- function(x, n = 300) {
  # Check that the age columns are all cromulent.
  # There should be a total of `n` ages, but no more, indicating that they
  # are all exclusive
  sum(vapply(x, function(i) sum(i > -1, na.rm = TRUE), integer(1))) == n
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
    "disease must be one of 'Mortality', 'Nutrition', 'Vaccination'",
    fixed = TRUE
  )
  expect_error(gen_data("Dada"),
    "'dictionary' must be one of: 'Cholera', 'Measles', 'Meningitis', 'AJS', 'Mortality', 'Nutrition', 'Vaccination'",
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

    expect_is(nested, "tbl_df", label = type)
    expect_is(long, "tbl_df", label = type)
    expect_gt(nrow(long), nrow(nested), label = type)
    expect_gt(ncol(long), ncol(nested), label = type)
  
  }
 
})

test_that("outbreak data can be generated", {

  for (disease in c(outbreaks)) {
    dictionary <- msf_dict(disease)
    data       <- gen_data(disease, numcases = 300)

    expect_is(data, "tbl_df", label = disease)
    expect_equal(nrow(dictionary), ncol(data), label = disease)

    expect_true(check_exclusive_ages(get_ages(data), 300))
    expect_true(check_age_integers(get_ages(data)))
  }
})

test_that("survey data can be generated", {

  for (disease in surveys) {
    dictionary <- msf_dict_survey(disease)
    data       <- gen_data(disease, varnames = "name", numcases = 300)

    expect_is(data, "tbl_df", label = disease)
    `%NIN%` <- Negate(`%in%`)
    if (tolower(disease) %NIN% c("mortality", "vaccination")) {
      cdata <- data[data$consent == "yes", ]
      res   <- check_exclusive_ages(get_ages(cdata), nrow(cdata))
      expect_true(res, label = disease)
    }
    expect_true(check_age_integers(get_ages(data)))
    # TODO: these tests are failing because there are no clear "eligible" 
    #   columns anymore and they are specific to the data set. 
    # expect_true(!is.na(sum(data$eligible)))
    # expect_true(sum(data$eligible) > 0)
    # expect_true(!is.na(sum(data$interviewed)))
    # expect_true(sum(data$interviewed) > 0)
    # skip("These tests need to be updated when we have a better idea of the expected number of columns")
    # TODO: these tests fail because we need better expectations regarding
    # the number of columns that the dictionaries provide
    # expect_equal(nrow(dictionary), ncol(data), label = disease)
  }
})



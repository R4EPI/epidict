
outbreaks <- c("MeAsles", "CHolera", "AjS", "meningitis")
surveys   <- c("MOrtality", "NutritIon", "VaCcination")

# Functions for checking age columns
get_ages <- function(x) x[grepl("age_(year|month|day)", names(x), perl = TRUE)]
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
    expect_is(neither, "list", label = disease)
    expect_named(neither, c("dictionary", "options"), label = disease)
    expect_false(all(grepl("^\\[", long$option_name)))
    expect_false(all(grepl("^\\[", neither$options$option_name)))
    expect_equal(nrow(neither$dictionary), nrow(nested), label = disease)
    expect_equal(ncol(long), sum(vapply(neither, ncol, integer(1))) - 1L, label = disease)
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

  for (disease in c(surveys)) {
    # print(disease)
    dictionary <- msf_dict_survey(disease)
    data       <- gen_data(disease, varnames = "column_name", numcases = 300)

    expect_is(data, "tbl_df", label = disease)
    if (tolower(disease) != "mortality") {
      expect_true(check_exclusive_ages(get_ages(data), 300), label = disease)
    }
    expect_true(check_age_integers(get_ages(data)))
    skip("These tests need to be updated when we have a better idea of the expected number of columns")
    # TODO: these tests fail because we need better expectations regarding
    # the number of columns that the dictionaries provide
    expect_equal(nrow(dictionary), ncol(data), label = disease)
  }
})


test_that("polygons can be generated", {

  poly <- suppressWarnings(gen_polygon(LETTERS[1:4]))
  expect_equal(dim(poly), c(4, 2))

})

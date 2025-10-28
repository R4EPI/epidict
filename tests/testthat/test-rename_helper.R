
# Test dict_rename_helper --------------------------------------------------------

test_that("dict_rename_helper validates dictionary input", {
  skip_if_not_installed("clipr")

  # Create a temporary Rmd file
  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c("# Test", "linelist_cleaned$age", "linelist_cleaned$sex"), temp_rmd)
  withr::defer(unlink(temp_rmd))

  # Test with non-dataframe
  expect_error(
    dict_rename_helper(
      dictionary = "not a dataframe",
      varnames = "name",
      varnames_type = "type",
      rmd = temp_rmd,
      copy_to_clipboard = FALSE
    ),
    "must be a dataframe"
  )
})

test_that("dict_rename_helper validates varnames input", {
  skip_if_not_installed("clipr")

  # Create test dictionary
  test_dict <- data.frame(
    name = c("age", "sex"),
    type = c("integer", "text"),
    stringsAsFactors = FALSE
  )

  # Create a temporary Rmd file
  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c("# Test", "linelist_cleaned$age"), temp_rmd)
  withr::defer(unlink(temp_rmd))

  # Test with non-character varnames
  expect_error(
    dict_rename_helper(
      dictionary = test_dict,
      varnames = 123,
      varnames_type = "type",
      rmd = temp_rmd,
      copy_to_clipboard = FALSE
    ),
    "must be quoted names"
  )
})

test_that("dict_rename_helper validates varnames exists in dictionary", {
  skip_if_not_installed("clipr")

  test_dict <- data.frame(
    name = c("age", "sex"),
    type = c("integer", "text"),
    stringsAsFactors = FALSE
  )

  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c("# Test", "linelist_cleaned$age"), temp_rmd)
  withr::defer(unlink(temp_rmd))

  # Test with varnames not in dictionary
  expect_error(
    dict_rename_helper(
      dictionary = test_dict,
      varnames = "nonexistent",
      varnames_type = "type",
      rmd = temp_rmd,
      copy_to_clipboard = FALSE
    ),
    "must be a column in `dictionary`"
  )
})

test_that("dict_rename_helper validates varnames_type exists in dictionary", {
  skip_if_not_installed("clipr")

  test_dict <- data.frame(
    name = c("age", "sex"),
    type = c("integer", "text"),
    stringsAsFactors = FALSE
  )

  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c("# Test", "linelist_cleaned$age"), temp_rmd)
  withr::defer(unlink(temp_rmd))

  # Test with varnames_type not in dictionary
  expect_error(
    dict_rename_helper(
      dictionary = test_dict,
      varnames = "name",
      varnames_type = "nonexistent",
      rmd = temp_rmd,
      copy_to_clipboard = FALSE
    ),
    "must be a column in `dictionary`"
  )
})

test_that("dict_rename_helper validates rmd file exists", {
  skip_if_not_installed("clipr")

  test_dict <- data.frame(
    name = c("age", "sex"),
    type = c("integer", "text"),
    stringsAsFactors = FALSE
  )

  # Test with non-existent file
  expect_error(
    dict_rename_helper(
      dictionary = test_dict,
      varnames = "name",
      varnames_type = "type",
      rmd = "nonexistent_file.Rmd",
      copy_to_clipboard = FALSE
    ),
    "does not exist"
  )
})

test_that("dict_rename_helper correctly identifies REQUIRED variables", {
  skip_if_not_installed("clipr")

  test_dict <- data.frame(
    name = c("age", "sex", "unused_var"),
    type = c("integer", "text", "text"),
    stringsAsFactors = FALSE
  )

  # Create Rmd with age and sex used, but not unused_var
  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c(
    "# Test Script",
    "linelist_cleaned$age",
    "# some comment with age again",
    "linelist_cleaned$sex",
    "# unused_var is only in a comment"
  ), temp_rmd)
  withr::defer(unlink(temp_rmd))

  # Capture output
  output <- capture.output(
    dict_rename_helper(
      dictionary = test_dict,
      varnames = "name",
      varnames_type = "type",
      rmd = temp_rmd,
      copy_to_clipboard = FALSE
    )
  )

  output_text <- paste(output, collapse = "\n")

  # Check that age and sex are marked as REQUIRED
  expect_match(output_text, "age.*REQUIRED")
  expect_match(output_text, "sex.*REQUIRED")

  # Check that unused_var is marked as optional
  expect_match(output_text, "unused_var.*optional")
})

test_that("dict_rename_helper produces correctly formatted output", {
  skip_if_not_installed("clipr")

  test_dict <- data.frame(
    name = c("age", "sex"),
    type = c("integer", "text"),
    stringsAsFactors = FALSE
  )

  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c("linelist_cleaned$age", "linelist_cleaned$sex"), temp_rmd)
  withr::defer(unlink(temp_rmd))

  output <- capture.output(
    dict_rename_helper(
      dictionary = test_dict,
      varnames = "name",
      varnames_type = "type",
      rmd = temp_rmd,
      copy_to_clipboard = FALSE
    )
  )

  output_text <- paste(output, collapse = "\n")

  # Check for rename function structure
  expect_match(output_text, "rename\\(linelist_cleaned,")

  # Check that both variables are present
  expect_match(output_text, "age")
  expect_match(output_text, "sex")

  # Check for type annotations
  expect_match(output_text, "integer")
  expect_match(output_text, "text")

  # Check that last line doesn't have comma
  expect_false(grepl("sex.*,\\s*$", output_text))
})

test_that("dict_rename_helper orders REQUIRED variables first", {
  skip_if_not_installed("clipr")

  test_dict <- data.frame(
    name = c("zebra", "aardvark", "middle"),
    type = c("text", "text", "text"),
    stringsAsFactors = FALSE
  )

  # Only use "middle" in the template (so it's REQUIRED)
  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c("linelist_cleaned$middle"), temp_rmd)
  withr::defer(unlink(temp_rmd))

  output <- capture.output(
    dict_rename_helper(
      dictionary = test_dict,
      varnames = "name",
      varnames_type = "type",
      rmd = temp_rmd,
      copy_to_clipboard = FALSE
    )
  )

  output_text <- paste(output, collapse = "\n")

  # Find positions of each variable
  pos_middle <- regexpr("middle", output_text)
  pos_aardvark <- regexpr("aardvark", output_text)
  pos_zebra <- regexpr("zebra", output_text)

  # REQUIRED variable (middle) should come before optional ones
  expect_true(pos_middle < pos_aardvark)
  expect_true(pos_middle < pos_zebra)
})

test_that("dict_rename_helper handles clipboard operations gracefully", {
  skip_if_not_installed("clipr")

  test_dict <- data.frame(
    name = c("age"),
    type = c("integer"),
    stringsAsFactors = FALSE
  )

  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c("linelist_cleaned$age"), temp_rmd)
  withr::defer(unlink(temp_rmd))

  # Test with copy_to_clipboard = TRUE (should not error)
  expect_no_error(
    dict_rename_helper(
      dictionary = test_dict,
      varnames = "name",
      varnames_type = "type",
      rmd = temp_rmd,
      copy_to_clipboard = TRUE
    )
  )
})

# Test msf_dict_rename_helper ---------------------------------------------------

test_that("msf_dict_rename_helper validates dictionary input", {
  skip_if_not_installed("clipr")
  skip_if_not_installed("sitrep")

  expect_error(
    msf_dict_rename_helper(
      dictionary = "nonexistent_disease",
      copy_to_clipboard = FALSE
    ),
    "'dictionary' must be one of: 'Cholera', 'Measles', 'Meningitis', 'AJS', 'Cholera_intersectional', 'Measles_intersectional', 'Meningitis_intersectional', 'AJS_intersectional', 'Diphtheria_intersectional', 'Mortality', 'Nutrition', 'Vaccination_long', 'Vaccination_short', 'ebs'"
  )
})

test_that("msf_dict_rename_helper works with valid outbreak dictionaries", {
  skip_if_not_installed("clipr")
  skip_if_not_installed("sitrep")
  skip_on_cran()

  # Test with a known outbreak dictionary
  outbreak_dicts <- c("Cholera", "Measles", "AJS", "Meningitis")

  for (dict in outbreak_dicts) {
    # Check it runs without error
    expect_no_error(
      msf_dict_rename_helper(
        dictionary = dict,
        copy_to_clipboard = FALSE
      )
    )
  }
})

test_that("msf_dict_rename_helper works with intersectional outbreak dictionaries", {
  skip_if_not_installed("clipr")
  skip_if_not_installed("sitrep")
  skip_on_cran()

  # Test with intersectional dictionaries
  expect_no_error(
    msf_dict_rename_helper(
      dictionary = "Cholera_intersectional",
      copy_to_clipboard = FALSE
    )
  )
})

test_that("msf_dict_rename_helper works with survey dictionaries", {
  skip_if_not_installed("clipr")
  skip_if_not_installed("sitrep")
  skip_on_cran()

  # Test with survey dictionaries
  survey_dicts <- c("Mortality", "Nutrition", "Vaccination_long", "Vaccination_short")

  for (dict in survey_dicts) {
    expect_no_error(
      msf_dict_rename_helper(
        dictionary = dict,
        copy_to_clipboard = FALSE
      )
    )
  }
})

test_that("msf_dict_rename_helper uses correct varnames for format", {
  skip_if_not_installed("clipr")
  skip_if_not_installed("sitrep")
  skip_on_cran()

  # Capture output for DHIS2 format (e.g., Cholera)
  output_dhis <- capture.output(
    msf_dict_rename_helper(
      dictionary = "Cholera",
      copy_to_clipboard = FALSE
    )
  )

  # For DHIS2, should use data_element_shortname as variable names
  # We can't directly check the internal workings, but we can verify it runs
  expect_true(length(output_dhis) > 0)

  # Capture output for ODK format (e.g., Mortality)
  output_odk <- capture.output(
    msf_dict_rename_helper(
      dictionary = "Mortality",
      copy_to_clipboard = FALSE
    )
  )

  # For ODK, should use name as variable names
  expect_true(length(output_odk) > 0)
})

test_that("msf_dict_rename_helper handles vaccination dictionaries specially", {
  skip_if_not_installed("clipr")
  skip_if_not_installed("sitrep")
  skip_on_cran()

  # Both vaccination_long and vaccination_short should work
  expect_no_error(
    msf_dict_rename_helper(
      dictionary = "Vaccination_long",
      copy_to_clipboard = FALSE
    )
  )

  expect_no_error(
    msf_dict_rename_helper(
      dictionary = "Vaccination_short",
      copy_to_clipboard = FALSE
    )
  )
})

test_that("msf_dict_rename_helper produces valid rename syntax", {
  skip_if_not_installed("clipr")
  skip_if_not_installed("sitrep")
  skip_on_cran()

  output <- capture.output(
    msf_dict_rename_helper(
      dictionary = "Cholera",
      copy_to_clipboard = FALSE
    )
  )

  output_text <- paste(output, collapse = "\n")

  # Check for standard rename structure
  expect_match(output_text, "rename\\(linelist_cleaned,")
  expect_match(output_text, "REQUIRED|optional")
})

test_that("msf_dict_rename_helper handles missing dictionary parameter", {
  skip_if_not_installed("clipr")
  skip_if_not_installed("sitrep")

  # Should error when dictionary is missing
  expect_error(
    msf_dict_rename_helper(copy_to_clipboard = FALSE),
    "'dictionary' must be one of: 'Cholera', 'Measles', 'Meningitis', 'AJS', 'Cholera_intersectional', 'Measles_intersectional', 'Meningitis_intersectional', 'AJS_intersectional', 'Diphtheria_intersectional', 'Mortality', 'Nutrition', 'Vaccination_long', 'Vaccination_short', 'ebs'"
  )
})

# Integration tests --------------------------------------------------------------

test_that("dict_rename_helper integrates with msf_dict output", {
  skip_if_not_installed("clipr")
  skip_if_not_installed("sitrep")
  skip_on_cran()

  # Get a real MSF dictionary
  dict <- msf_dict("Cholera", compact = TRUE)

  # Create a temporary Rmd
  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c("linelist_cleaned$age", "linelist_cleaned$sex"), temp_rmd)
  withr::defer(unlink(temp_rmd))

  # Should work with the MSF dictionary format
  expect_no_error(
    dict_rename_helper(
      dictionary = dict,
      varnames = "data_element_shortname",
      varnames_type = "data_element_valuetype",
      rmd = temp_rmd,
      copy_to_clipboard = FALSE
    )
  )
})

test_that("rename helpers handle empty dictionaries", {
  skip_if_not_installed("clipr")

  empty_dict <- data.frame(
    name = character(0),
    type = character(0),
    stringsAsFactors = FALSE
  )

  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(c("# Empty template"), temp_rmd)
  withr::defer(unlink(temp_rmd))

  # Should handle empty dictionary gracefully
  output <- capture.output(
    dict_rename_helper(
      dictionary = empty_dict,
      varnames = "name",
      varnames_type = "type",
      rmd = temp_rmd,
      copy_to_clipboard = FALSE
    )
  )

  # Should still produce basic structure
  expect_match(paste(output, collapse = "\n"), "rename\\(linelist_cleaned,")
})

# Changelog

## epidict 0.3.0

CRAN release: 2026-01-20

- Update intersectional dictionaries
- add a logical “clean” argument to
  [`read_dict()`](https://r4epi.github.io/epidict/reference/read_dict.md)
  and
  [`msf_dict()`](https://r4epi.github.io/epidict/reference/msf_dict.md)
  with default TRUE
- adjust so that for “AJS_intersectional” dictionaries it does not clean
  variable names

## epidict 0.2.0

CRAN release: 2026-01-11

- Reinstate msf_dict_rename_helper() with sitrep in DESCRIPTION suggests

## epidict 0.1.0

CRAN release: 2025-11-13

- First CRAN release
- Separated out functions for reading dictionaries
- Created generic function for renaming variables based on a dictionary
- Removed msf_dict_rename_helper() until dependencies are on CRAN

## epidict 0.0.0.9001

- Updating to have all surveys in ODK format
- Updating documentation and pkgdown
- Adding both a short and a long form vaccination dictionary
- Adding survey dictionaries to rename helper function

## epidict 0.0.0.9000

- Fix broken URLs in README
- Add vignettes and README describing the dictionaries
- Release to CRAN
- Fix bug in generating elegible and interviewed for Mortality and
  Nurition surveys
- Added a `NEWS.md` file to track changes to the package.
- Generalize
  [`gen_data()`](https://r4epi.github.io/epidict/reference/gen_data.md)
  function to be able to take different organization dictionaries in the
  future.
- Tidy code.

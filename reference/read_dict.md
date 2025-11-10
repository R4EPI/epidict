# Data dictionaries

These function read dictionaries in ODK and DHIS2 formats, and reformats
them for dataset recoding into human-readable format.

## Usage

``` r
read_dict(path, sheet, format, tibble = TRUE, long = TRUE, compact = TRUE)
```

## Arguments

- path:

  Define the path to .xlsx file where the dictionary is stored

- sheet:

  Optional, if your sheets have non-standard names (e.g. using a disease
  pre-fix) - this can be specified here.

- format:

  The format which the dictionary is in. Currently supports "DHIS2" and
  "ODK".

- tibble:

  If `TRUE` (default), return data dictionary as a tidyverse tibble
  otherwise will return a list.

- long:

  If `TRUE` (default), the returned data dictionary is in long format
  with each option getting one row. If `FALSE`, then two data frames are
  returned, one with variables and the other with content options.

- compact:

  If `TRUE` (default), then a nested data frame is returned where each
  row represents a single variable and a nested data frame column called
  "options", which can be expanded with
  [`tidyr::unnest()`](https://tidyr.tidyverse.org/reference/unnest.html).
  This only works if `long = TRUE`.

## Value

If `long = TRUE`, returns a tibble of the merged dictionary and value
options. If `long = FALSE`, returns a list with elements `dictionary`
and `options`. If `compact = TRUE`, options are nested as a column of
data frames under "options".

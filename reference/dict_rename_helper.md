# Dictionary-based helper for aligning your data to variables used in a script

Dictionary-based helper for aligning your data to variables used in a
script

## Usage

``` r
dict_rename_helper(
  dictionary,
  varnames,
  varnames_type,
  rmd,
  copy_to_clipboard = TRUE
)
```

## Arguments

- dictionary:

  A dataframe of the dictionary which you would like to use.

- varnames:

  The name of `dictionary` column that contains variable names.

- varnames_type:

  The name of `dictionary` column that contains the variable type. This
  variable needs to be the same number of rows as as `varnames`.

- rmd:

  Path to the Rmarkdown file which you would like to compare to.

- copy_to_clipboard:

  if `TRUE` (default), the rename template will be copied to the user's
  clipboard with
  [`clipr::write_clip()`](http://matthewlincoln.net/clipr/reference/write_clip.md).
  If `FALSE`, the rename template will be printed to the user's console.

## Value

A dplyr command used to rename columns in your data frame according to
the dictionary

## See also

[`read_dict()`](https://r4epi.github.io/epidict/reference/read_dict.md)

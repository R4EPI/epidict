# Helper for aligning your data to MSF standardised dictionaries and analysis templates.

Helper for aligning your data to MSF standardised dictionaries and
analysis templates.

## Usage

``` r
msf_dict_rename_helper(dictionary, copy_to_clipboard = TRUE)
```

## Arguments

- dictionary:

  Specify which MSF dictionary you would like to use. See
  [`msf_dict()`](https://r4epi.github.io/epidict/reference/msf_dict.md)
  for options.

- copy_to_clipboard:

  if `TRUE` (default), the rename template will be copied to the user's
  clipboard with
  [`clipr::write_clip()`](http://matthewlincoln.net/clipr/reference/write_clip.md).
  If `FALSE`, the rename template will be printed to the user's console.

## Value

A dplyr command used to rename columns in your data frame according to
the dictionary

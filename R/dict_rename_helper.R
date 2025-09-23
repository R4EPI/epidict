#' Dictionary-based helper for aligning your data to variables used in a script 
#' 
#' @param dictionary A dataframe of the dictionary which you would like to use. 
#' 
#' @param varnames The name of `dictionary` column that contains variable names. 
#'
#' @param varnames_type The name of `dictionary` column that contains the variable type.
#' This variable needs to be the same number of rows as as `varnames`.
#' 
#' @param rmd Path to the Rmarkdown file which you would like to compare to. 
#'
#' @param copy_to_clipboard if `TRUE` (default), the rename template will be
#'   copied to the user's clipboard with [clipr::write_clip()]. If `FALSE`, the
#'   rename template will be printed to the user's console.
#'
#' @return A dplyr command used to rename columns in your data frame according
#' to the dictionary
#'
#' @importFrom readxl read_excel
#' @importFrom clipr write_clip
#' 
#' @seealso [read_dict()] [msf_dict_rename_helper()]
#' 
#' @export

dict_rename_helper <- function(dictionary, 
                               varnames, 
                               varnames_type, 
                               rmd, 
                               copy_to_clipboard = TRUE) {

  # check format of inputs 
  if (!is.data.frame(dictionary)) {
    stop("`dictionary` must be a dataframe")
  }

  if (!is.character(varnames) | !is.character(varnames_type)) {
    stop("`varnames` and `varnames` must be quoted names of variables in `dictionary`")
  }

  if (!(varnames %in% names(dictionary))) {
    stop(paste0("`varnames` must be a column in `dictionary`, but '", varnames, "' not found"))
  }
  
  if (!(varnames_type %in% names(dictionary))) {
    stop(paste0("`varnames_type` must be a column in `dictionary`, but '", varnames_type, "' not found"))
  }
  
  if (!file.exists(rmd)) {
    stop(paste0("The file '", rmd, "' does not exist"))
  }

  # pull in the rmd file
  template_file <- readLines(rmd)

  # for each of the variables - search in the rmd
  # (if found then set to required else optional)
  dictionary[["var_required"]] <- vapply(dictionary[[varnames]],
    FUN = function(i, o) if (any(grepl(paste0("^[^#]*", i), o))) "REQUIRED" else "optional",
    FUN.VALUE = character(1),
    o = template_file
  )

  # move the required variables to the top
  dictionary <- dictionary[order(dictionary[["var_required"]] != "REQUIRED",
                             dictionary[[varnames]]), ]
  # pull together instructions for where users should input recodes
  msg <- "## Add the appropriate column names after the equals signs\n\n"
  msg <- paste0(msg, "linelist_cleaned <- rename(linelist_cleaned,\n")
  the_renames <- sprintf("  %s =   , # %s (%s)",
    format(dictionary[[varnames]]),
    format(dictionary[[varnames_type]]),
    dictionary[["var_required"]]
  )
  # remove commas
  the_renames[length(the_renames)] <- gsub(",", " ", the_renames[length(the_renames)])
  # add linebreaks between
  msg <- paste0(msg, paste(the_renames, collapse = "\n"), "\n)\n")
  # add output to clipboard
  if (copy_to_clipboard) {
    x <- try(clipr::write_clip(msg), silent = TRUE)
    if (inherits(x, "try-error")) {
      if (interactive()) cat(msg)
      return(invisible())
    }
    message("rename template copied to clipboard. Paste the contents to your RMarkdown file and enter in the column names from your data set.")
  } else {
    cat(msg)
  }
  
}

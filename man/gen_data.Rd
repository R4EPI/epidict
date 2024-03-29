% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gen_data.R
\name{gen_data}
\alias{gen_data}
\title{Generate random linelist or survey data}
\usage{
gen_data(
  dictionary,
  varnames = "data_element_shortname",
  numcases = 300,
  org = "MSF"
)
}
\arguments{
\item{dictionary}{Specify which dictionary you would like to use.}

\item{varnames}{Specify name of column that contains variable names.
If \code{dictionary} is a survey, \code{varnames} needs to be "name"`.}

\item{numcases}{Specify the number of cases you want (default is 300)}

\item{org}{the organization the dictionary belongs to. Currently, only MSF
exists. In the future, dictionaries from WHO and other organizations may
become available.}
}
\value{
a data frame with cases in rows and variables in columns. The number
of columns will vary from dictionary to dictionary, so please use the
dictionary functions to generate a corresponding dictionary.
}
\description{
Based on a dictionary generator like \code{\link[=msf_dict]{msf_dict()}} or \code{\link[=msf_dict_survey]{msf_dict_survey()}},
this function will generate a randomized data set based on values defined in
the dictionaries. The randomized dataset produced should mimic an excel
export from DHIS2 for outbreaks and a Kobo export for surveys.
}
\examples{

if (require("dplyr") & require("matchmaker")) {
  withAutoprint({

    # You will often want to use MSF dictionaries to translate codes to human-
    # readable variables. Here, we generate a data set of 20 cases:
    dat <- gen_data(
      dictionary = "Cholera",
      varnames = "data_element_shortname",
      numcases = 20,
      org = "MSF"
    )
    print(dat)

    # We want the expanded dictionary, so we will select `compact = FALSE`
    dict <- msf_dict(disease = "Cholera", long = TRUE, compact = FALSE, tibble = TRUE)
    print(dict)

    # Now we can use matchmaker to filter the data:
    dat_clean <- matchmaker::match_df(dat, dict,
      from = "option_code",
      to = "option_name",
      by = "data_element_shortname",
      order = "option_order_in_set"
    )
    print(dat_clean)

  })
}
}

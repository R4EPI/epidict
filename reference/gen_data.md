# Generate random linelist or survey data

Based on a dictionary generator like
[`msf_dict()`](https://r4epi.github.io/epidict/reference/msf_dict.md),
this function will generate a randomized dataset based on values defined
in the dictionaries. The randomized dataset produced should mimic an
excel export from DHIS2 or ODK.

## Usage

``` r
gen_data(dictionary, varnames = "name", numcases = 300, org = "MSF")
```

## Arguments

- dictionary:

  Specify which dictionary you would like to use.

- varnames:

  Specify name of column that contains variable names. If `dictionary`
  is in ODK format, `varnames` needs to be "name" (Default), if in DHIS2
  format then change to "data_element_shortname".

- numcases:

  Specify the number of cases you want (default is 300)

- org:

  Specify the organisation which the dictionary belongs to. Currently,
  only MSF exists. In the future, dictionaries from WHO and other
  organizations may become available.

## Value

a data frame with cases in rows and variables in columns. The number of
columns will vary from dictionary to dictionary, so please use the
dictionary functions to generate a corresponding dictionary.

## Examples

``` r
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
    dict <- msf_dict(dictionary = "Cholera", long = TRUE, compact = FALSE, tibble = TRUE)
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
#> Loading required package: dplyr
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
#> Loading required package: matchmaker
#> > dat <- gen_data(dictionary = "Cholera", varnames = "data_element_shortname", 
#> +     numcases = 20, org = "MSF")
#> > print(dat)
#> # A tibble: 20 × 45
#>    case_number date_of_consultation_admiss…¹ patient_origin age_years age_months
#>    <chr>       <date>                        <chr>              <int>      <int>
#>  1 A1          2018-02-23                    Village A             51         NA
#>  2 A2          2018-04-05                    Village A             16         NA
#>  3 A3          2018-03-18                    Village D              5         NA
#>  4 A4          2018-04-10                    Village C              3         NA
#>  5 A5          2018-01-08                    Village A             20         NA
#>  6 A6          2018-03-20                    Village B             35         NA
#>  7 A7          2018-02-23                    Village D             43         NA
#>  8 A8          2018-04-12                    Village D             45         NA
#>  9 A9          2018-01-27                    Village A             21         NA
#> 10 A10         2018-02-12                    Village C              5         NA
#> 11 A11         2018-03-14                    Village B              5         NA
#> 12 A12         2018-03-12                    Village B             53         NA
#> 13 A13         2018-03-12                    Village B              8         NA
#> 14 A14         2018-02-13                    Village A             22         NA
#> 15 A15         2018-02-19                    Village B             75         NA
#> 16 A16         2018-03-25                    Village D             49         NA
#> 17 A17         2018-04-26                    Village D             40         NA
#> 18 A18         2018-01-07                    Village D             18         NA
#> 19 A19         2018-04-20                    Village B             81         NA
#> 20 A20         2018-04-15                    Village B              5         NA
#> # ℹ abbreviated name: ¹​date_of_consultation_admission
#> # ℹ 40 more variables: age_days <int>, sex <fct>, pregnant <fct>,
#> #   trimester <fct>, foetus_alive_at_admission <fct>, exit_status <fct>,
#> #   date_of_exit <date>, time_to_death <fct>, pregnancy_outcome_at_exit <fct>,
#> #   previously_vaccinated <fct>, previous_vaccine_doses_received <fct>,
#> #   readmission <fct>, msf_involvement <fct>,
#> #   cholera_treatment_facility_type <fct>, residential_status_brief <fct>, …
#> > dict <- msf_dict(dictionary = "Cholera", long = TRUE, compact = FALSE, 
#> +     tibble = TRUE)
#> > print(dict)
#> # A tibble: 182 × 11
#>    data_element_uid data_element_name                     data_element_shortname
#>    <chr>            <chr>                                 <chr>                 
#>  1 AafTlSwliVQ      egen_001_patient_case_number          case_number           
#>  2 OTGOtWBz39J      egen_004_date_of_consultation_admiss… date_of_consultation_…
#>  3 wnmMr2V3T3u      egen_006_patient_origin               patient_origin        
#>  4 sbgqjeVwtb8      egen_008_age_years                    age_years             
#>  5 eXYhovYyl61      egen_009_age_months                   age_months            
#>  6 UrYJSk2Wp46      egen_010_age_days                     age_days              
#>  7 D1Ky5K7pFN6      egen_011_sex                          sex                   
#>  8 D1Ky5K7pFN6      egen_011_sex                          sex                   
#>  9 D1Ky5K7pFN6      egen_011_sex                          sex                   
#> 10 dTm5R53YYXC      egen_012_pregnancy_status             pregnant              
#> # ℹ 172 more rows
#> # ℹ 8 more variables: data_element_description <chr>,
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, option_code <chr>, option_name <chr>,
#> #   option_uid <chr>, option_order_in_set <dbl>
#> > dat_clean <- matchmaker::match_df(dat, dict, from = "option_code", to = "option_name", 
#> +     by = "data_element_shortname", order = "option_order_in_set")
#> > print(dat_clean)
#> # A tibble: 20 × 45
#>    case_number date_of_consultation_admiss…¹ patient_origin age_years age_months
#>    <chr>       <date>                        <chr>              <int>      <int>
#>  1 A1          2018-02-23                    Village A             51         NA
#>  2 A2          2018-04-05                    Village A             16         NA
#>  3 A3          2018-03-18                    Village D              5         NA
#>  4 A4          2018-04-10                    Village C              3         NA
#>  5 A5          2018-01-08                    Village A             20         NA
#>  6 A6          2018-03-20                    Village B             35         NA
#>  7 A7          2018-02-23                    Village D             43         NA
#>  8 A8          2018-04-12                    Village D             45         NA
#>  9 A9          2018-01-27                    Village A             21         NA
#> 10 A10         2018-02-12                    Village C              5         NA
#> 11 A11         2018-03-14                    Village B              5         NA
#> 12 A12         2018-03-12                    Village B             53         NA
#> 13 A13         2018-03-12                    Village B              8         NA
#> 14 A14         2018-02-13                    Village A             22         NA
#> 15 A15         2018-02-19                    Village B             75         NA
#> 16 A16         2018-03-25                    Village D             49         NA
#> 17 A17         2018-04-26                    Village D             40         NA
#> 18 A18         2018-01-07                    Village D             18         NA
#> 19 A19         2018-04-20                    Village B             81         NA
#> 20 A20         2018-04-15                    Village B              5         NA
#> # ℹ abbreviated name: ¹​date_of_consultation_admission
#> # ℹ 40 more variables: age_days <int>, sex <fct>, pregnant <fct>,
#> #   trimester <fct>, foetus_alive_at_admission <fct>, exit_status <fct>,
#> #   date_of_exit <date>, time_to_death <fct>, pregnancy_outcome_at_exit <fct>,
#> #   previously_vaccinated <fct>, previous_vaccine_doses_received <fct>,
#> #   readmission <fct>, msf_involvement <fct>,
#> #   cholera_treatment_facility_type <fct>, residential_status_brief <fct>, …
```

epidict
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/epidict)](https://CRAN.R-project.org/package=epidict)
[![R-CMD-check](https://github.com/R4EPI/epidict/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/R4EPI/epidict/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/R4EPI/epidict/graph/badge.svg)](https://app.codecov.io/gh/R4EPI/epidict)
<!-- badges: end -->

The goal of {epidict} is to provide standardized data dictionaries for
use in epidemiological data analysis templates. Currently it supports
standardised dictionaries from MSF OCA. This is a product of the R4EPIs
project; learn more at <https://r4epi.github.io/sitrep/>

## Installation

You can install {epidict} from CRAN:

``` r
install.packages("epidict")
```

<details>

<!--
NOTE: everything inside the details tag will be collapsed and effectively
hidden from the user
-->

<summary style="text-decoration: underline">

Click here for alternative installation options
</summary>

If there is a bugfix or feature that is not yet on CRAN, you can install
it via the {drat} package:

You can also install the in-development version from GitHub using the
{remotes} package (but there’s no guarantee that it will be stable):

``` r
# install.packages("remotes")
remotes::install_github("R4EPI/epidict") 
```

</details>

## Accessing dictionaries

The dictionaries can be obtained via the `msf_dict()` function, which
specifies a variable and their possible options (if categorical).

There are MSF intersectional outbreak dictionaries available in
{epidict} based on ODK exports.

There are MSF OCA outbreak dictionaries available in {epidict} based on
DHIS2 exports. \> You can read more about the outbreak dictionaries at
<https://r4epi.github.io/epidict/articles/Outbreaks.html>

In addition, there are MSF survey dictionaries available based on ODK
exports. \> You can read more about the survey dictionaries at
<https://r4epi.github.io/epidict/articles/Surveys.html>

You can also read in your own ODK dictionaries using `read_dict()`.

## Generating data

The {epidict} package has a function for generating data that’s called
`gen_data()`, which takes three arguments: The dictionary, which column
describes the variable names, and how many rows are needed in the
output.

<details>

<!--
NOTE: everything inside the details tag will be collapsed and effectively
hidden from the user
-->

<summary style="text-decoration: underline">

Click here for code examples
</summary>

``` r
library("epidict")
gen_data("Measles", varnames = "data_element_shortname", numcases = 100, org = "MSF")
#> # A tibble: 100 × 52
#>    case_number date_of_consultation_admis…¹ patient_facility_type patient_origin
#>    <chr>       <date>                       <fct>                 <chr>         
#>  1 A1          2018-03-02                   OP                    Village A     
#>  2 A2          2018-03-19                   IP                    Village A     
#>  3 A3          2018-03-16                   OP                    Village A     
#>  4 A4          2018-01-02                   IP                    Village D     
#>  5 A5          2018-03-30                   IP                    Village D     
#>  6 A6          2018-02-25                   OP                    Village B     
#>  7 A7          2018-02-10                   IP                    Village B     
#>  8 A8          2018-02-22                   IP                    Village B     
#>  9 A9          2018-02-10                   OP                    Village C     
#> 10 A10         2018-01-17                   IP                    Village B     
#> # ℹ 90 more rows
#> # ℹ abbreviated name: ¹​date_of_consultation_admission
#> # ℹ 48 more variables: age_years <int>, age_months <int>, age_days <int>,
#> #   sex <fct>, pregnant <fct>, trimester <fct>,
#> #   foetus_alive_at_admission <fct>, exit_status <fct>, date_of_exit <date>,
#> #   time_to_death <fct>, pregnancy_outcome_at_exit <fct>,
#> #   baby_born_with_complications <fct>, previously_vaccinated <fct>, …
gen_data("Vaccination_long", varnames = "name", numcases = 100, org = "MSF")
#> # A tibble: 100 × 120
#>    start end   today deviceid date       team_number village_name village_other
#>    <lgl> <lgl> <lgl> <lgl>    <date>     <lgl>       <fct>        <lgl>        
#>  1 NA    NA    NA    NA       2018-03-14 NA          village_1    NA           
#>  2 NA    NA    NA    NA       2018-02-24 NA          other        NA           
#>  3 NA    NA    NA    NA       2018-04-28 NA          village_1    NA           
#>  4 NA    NA    NA    NA       2018-03-23 NA          village_5    NA           
#>  5 NA    NA    NA    NA       2018-02-19 NA          village_1    NA           
#>  6 NA    NA    NA    NA       2018-02-23 NA          other        NA           
#>  7 NA    NA    NA    NA       2018-04-23 NA          village_4    NA           
#>  8 NA    NA    NA    NA       2018-03-19 NA          village_10   NA           
#>  9 NA    NA    NA    NA       2018-02-09 NA          village_8    NA           
#> 10 NA    NA    NA    NA       2018-04-10 NA          village_8    NA           
#> # ℹ 90 more rows
#> # ℹ 112 more variables: cluster_number <dbl>, household_number <int>,
#> #   households_building <int>, random_hh <int>, consent <chr>,
#> #   no_consent_reason <fct>, no_consent_other <lgl>, caretaker_relation <fct>,
#> #   caretaker_other <lgl>, number_children <dbl>, child_number <chr>,
#> #   sex <fct>, date_birth <date>, age_years <int>, age_months <int>,
#> #   any_vaccine <fct>, vaccine_card <fct>, hf_records <fct>, …
```

</details>

## Cleaning data with the dictionaries

You can use the dictionaries to clean the data via the
[{matchmaker}](https://www.repidemicsconsortium.org/matchmaker) package:

<details>

<!--
NOTE: everything inside the details tag will be collapsed and effectively
hidden from the user
-->

<summary style="text-decoration: underline">

Click here for code examples
</summary>

``` r
library("matchmaker")
library("dplyr")

dat <- gen_data(dictionary = "Cholera", 
  varnames = "data_element_shortname",
  numcases = 20,
  org = "MSF"
)
print(dat)
#> # A tibble: 20 × 45
#>    case_number date_of_consultation_admiss…¹ patient_origin age_years age_months
#>    <chr>       <date>                        <chr>              <int>      <int>
#>  1 A1          2018-02-01                    Village D             25         NA
#>  2 A2          2018-02-17                    Village A             72         NA
#>  3 A3          2018-04-29                    Village D             79         NA
#>  4 A4          2018-02-15                    Village A             NA         19
#>  5 A5          2018-03-13                    Village C             40         NA
#>  6 A6          2018-01-06                    Village A             32         NA
#>  7 A7          2018-01-26                    Village D             16         NA
#>  8 A8          2018-03-06                    Village B             25         NA
#>  9 A9          2018-02-22                    Village D             10         NA
#> 10 A10         2018-03-29                    Village D             54         NA
#> 11 A11         2018-04-13                    Village B             69         NA
#> 12 A12         2018-02-26                    Village B              6         NA
#> 13 A13         2018-04-27                    Village D             10         NA
#> 14 A14         2018-02-05                    Village B              4         NA
#> 15 A15         2018-02-05                    Village C             23         NA
#> 16 A16         2018-03-25                    Village A             36         NA
#> 17 A17         2018-02-01                    Village D              3         NA
#> 18 A18         2018-04-21                    Village C             20         NA
#> 19 A19         2018-04-08                    Village C             10         NA
#> 20 A20         2018-03-27                    Village C              3         NA
#> # ℹ abbreviated name: ¹​date_of_consultation_admission
#> # ℹ 40 more variables: age_days <int>, sex <fct>, pregnant <fct>,
#> #   trimester <fct>, foetus_alive_at_admission <fct>, exit_status <fct>,
#> #   date_of_exit <date>, time_to_death <fct>, pregnancy_outcome_at_exit <fct>,
#> #   previously_vaccinated <fct>, previous_vaccine_doses_received <fct>,
#> #   readmission <fct>, msf_involvement <fct>,
#> #   cholera_treatment_facility_type <fct>, residential_status_brief <fct>, …

# We want the expanded dictionary, so we will select `compact = FALSE`
dict <- msf_dict(dictionary = "Cholera", 
  long    = TRUE,
  compact = FALSE,
  tibble  = TRUE
)
print(dict)
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

# Now we can use matchmaker to filter the data
dat_clean <- matchmaker::match_df(dat, dict, 
  from  = "option_code",
  to    = "option_name",
  by    = "data_element_shortname",
  order = "option_order_in_set"
)
print(dat_clean)
#> # A tibble: 20 × 45
#>    case_number date_of_consultation_admiss…¹ patient_origin age_years age_months
#>    <chr>       <date>                        <chr>              <int>      <int>
#>  1 A1          2018-02-01                    Village D             25         NA
#>  2 A2          2018-02-17                    Village A             72         NA
#>  3 A3          2018-04-29                    Village D             79         NA
#>  4 A4          2018-02-15                    Village A             NA         19
#>  5 A5          2018-03-13                    Village C             40         NA
#>  6 A6          2018-01-06                    Village A             32         NA
#>  7 A7          2018-01-26                    Village D             16         NA
#>  8 A8          2018-03-06                    Village B             25         NA
#>  9 A9          2018-02-22                    Village D             10         NA
#> 10 A10         2018-03-29                    Village D             54         NA
#> 11 A11         2018-04-13                    Village B             69         NA
#> 12 A12         2018-02-26                    Village B              6         NA
#> 13 A13         2018-04-27                    Village D             10         NA
#> 14 A14         2018-02-05                    Village B              4         NA
#> 15 A15         2018-02-05                    Village C             23         NA
#> 16 A16         2018-03-25                    Village A             36         NA
#> 17 A17         2018-02-01                    Village D              3         NA
#> 18 A18         2018-04-21                    Village C             20         NA
#> 19 A19         2018-04-08                    Village C             10         NA
#> 20 A20         2018-03-27                    Village C              3         NA
#> # ℹ abbreviated name: ¹​date_of_consultation_admission
#> # ℹ 40 more variables: age_days <int>, sex <fct>, pregnant <fct>,
#> #   trimester <fct>, foetus_alive_at_admission <fct>, exit_status <fct>,
#> #   date_of_exit <date>, time_to_death <fct>, pregnancy_outcome_at_exit <fct>,
#> #   previously_vaccinated <fct>, previous_vaccine_doses_received <fct>,
#> #   readmission <fct>, msf_involvement <fct>,
#> #   cholera_treatment_facility_type <fct>, residential_status_brief <fct>, …
```

</details>

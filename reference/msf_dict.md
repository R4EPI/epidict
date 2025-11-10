# MSF data dictionaries and dummy datasets

These function produce MSF dictionaries based on DHIS2 (for OCA
outbreaks) and ODK (for intersectional outbreaks and surveys) data sets
defining the data element name, code, short names, types, and key/value
pairs for translating the codes into human-readable format.

## Usage

``` r
msf_dict(dictionary, tibble = TRUE, long = TRUE, compact = TRUE)
```

## Arguments

- dictionary:

  Specify which dictionary you would like to use.

  - MSF OCA outbreaks include: "AJS", "Cholera", "Measles", "Meningitis"

  - MSF intersectional outbreaks include: "AJS_intersectional",
    "Cholera_intersectional", "Diphtheria_intersectional",
    "Measles_intersectional", "Meningitis_intersectional"

  - MSF OCA surveys include "Mortality", "Nutrition",
    "Vaccination_long", "Vaccination_short" and "ebs"

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

A data frame (tibble) containing the specified MSF data dictionary. If
`long = TRUE`, each variable-option pair is represented as a row. If
`compact = TRUE`, the options are nested as a data frame column named
"options". If `long = FALSE`, a list is returned with two data frames:
`dictionary` and `options`.

## See also

[`read_dict()`](https://r4epi.github.io/epidict/reference/read_dict.md)
[`gen_data()`](https://r4epi.github.io/epidict/reference/gen_data.md)
[`matchmaker::match_df()`](https://www.repidemicsconsortium.org/matchmaker/reference/match_df.html)

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
#> > dat <- gen_data(dictionary = "Cholera", varnames = "data_element_shortname", 
#> +     numcases = 20, org = "MSF")
#> > print(dat)
#> # A tibble: 20 × 45
#>    case_number date_of_consultation_admiss…¹ patient_origin age_years age_months
#>    <chr>       <date>                        <chr>              <int>      <int>
#>  1 A1          2018-01-07                    Village A             46         NA
#>  2 A2          2018-01-29                    Village A              9         NA
#>  3 A3          2018-01-20                    Village D             10         NA
#>  4 A4          2018-04-18                    Village C              9         NA
#>  5 A5          2018-01-18                    Village C             28         NA
#>  6 A6          2018-01-10                    Village C             51         NA
#>  7 A7          2018-01-01                    Village B             16         NA
#>  8 A8          2018-04-09                    Village C             21         NA
#>  9 A9          2018-04-26                    Village A              9         NA
#> 10 A10         2018-02-28                    Village C             40         NA
#> 11 A11         2018-01-03                    Village B             34         NA
#> 12 A12         2018-04-30                    Village A             62         NA
#> 13 A13         2018-03-08                    Village C             43         NA
#> 14 A14         2018-02-28                    Village B             38         NA
#> 15 A15         2018-03-13                    Village A             70         NA
#> 16 A16         2018-04-22                    Village D             17         NA
#> 17 A17         2018-03-14                    Village B             37         NA
#> 18 A18         2018-01-22                    Village A             45         NA
#> 19 A19         2018-01-13                    Village C             59         NA
#> 20 A20         2018-04-24                    Village D             83         NA
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
#>  1 A1          2018-01-07                    Village A             46         NA
#>  2 A2          2018-01-29                    Village A              9         NA
#>  3 A3          2018-01-20                    Village D             10         NA
#>  4 A4          2018-04-18                    Village C              9         NA
#>  5 A5          2018-01-18                    Village C             28         NA
#>  6 A6          2018-01-10                    Village C             51         NA
#>  7 A7          2018-01-01                    Village B             16         NA
#>  8 A8          2018-04-09                    Village C             21         NA
#>  9 A9          2018-04-26                    Village A              9         NA
#> 10 A10         2018-02-28                    Village C             40         NA
#> 11 A11         2018-01-03                    Village B             34         NA
#> 12 A12         2018-04-30                    Village A             62         NA
#> 13 A13         2018-03-08                    Village C             43         NA
#> 14 A14         2018-02-28                    Village B             38         NA
#> 15 A15         2018-03-13                    Village A             70         NA
#> 16 A16         2018-04-22                    Village D             17         NA
#> 17 A17         2018-03-14                    Village B             37         NA
#> 18 A18         2018-01-22                    Village A             45         NA
#> 19 A19         2018-01-13                    Village C             59         NA
#> 20 A20         2018-04-24                    Village D             83         NA
#> # ℹ abbreviated name: ¹​date_of_consultation_admission
#> # ℹ 40 more variables: age_days <int>, sex <fct>, pregnant <fct>,
#> #   trimester <fct>, foetus_alive_at_admission <fct>, exit_status <fct>,
#> #   date_of_exit <date>, time_to_death <fct>, pregnancy_outcome_at_exit <fct>,
#> #   previously_vaccinated <fct>, previous_vaccine_doses_received <fct>,
#> #   readmission <fct>, msf_involvement <fct>,
#> #   cholera_treatment_facility_type <fct>, residential_status_brief <fct>, …
```

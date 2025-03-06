epidict
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/epidict)](https://CRAN.R-project.org/package=epidict)
[![Codecov test
coverage](https://codecov.io/gh/R4EPI/epidict/branch/master/graph/badge.svg)](https://codecov.io/gh/R4EPI/epidict?branch=master)
[![R build
status](https://github.com/R4EPI/epidict/workflows/R-CMD-check/badge.svg)](https://github.com/R4EPI/epidict/actions)
<!-- badges: end -->

The goal of {epidict} is to provide standardized data dictionaries for
use in epidemiological data analysis templates. Currently it supports
standardised dictionaries from MSF OCA. This is a product of the R4EPIs
project; learn more at <https://r4epis.netlify.com>

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

There are four MSF outbreak dictionaries available in {epidict} based on
DHIS2 exports:

-   Acute Jaundice Syndrome (often suspected to be Hepatitis E) (“AJS”)
-   Cholera/Acute watery diarrhea (“Cholera”)
-   Measles/Rubella (“Measles”)
-   Meningitis (“Meningitis”)

> You can read more about the outbreak dictionaries at
> <https://r4epis.netlify.com/outbreaks>

The dictionary can be obtained via the `msf_dict()` function, which
specifies a dictionary that describes recorded variables
(`data_element_shortname`) in rows and their possible options (if
categorical):

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
msf_dict("AJS")
#> # A tibble: 68 × 8
#>    data_element_uid data_elem…¹ data_…² data_…³ data_…⁴ data_…⁵ used_…⁶ options 
#>    <lgl>            <chr>       <chr>   <chr>   <chr>   <chr>   <chr>   <list>  
#>  1 NA               egen_044_e… event_… Is the… TEXT    <NA>    HgdrO8… <tibble>
#>  2 NA               egen_001_p… case_n… Anonym… TEXT    <NA>    <NA>    <tibble>
#>  3 NA               egen_004_d… date_o… Date p… DATE    <NA>    <NA>    <tibble>
#>  4 NA               egen_022_d… detect… How pa… TEXT    <NA>    BlfHX5… <tibble>
#>  5 NA               egen_005_p… patien… Patien… TEXT    <NA>    YNeOOp… <tibble>
#>  6 NA               egen_029_m… msf_in… How ex… TEXT    <NA>    PN5NWt… <tibble>
#>  7 NA               egen_008_a… age_ye… Age of… INTEGE… <NA>    <NA>    <tibble>
#>  8 NA               egen_009_a… age_mo… Age of… INTEGE… <NA>    <NA>    <tibble>
#>  9 NA               egen_010_a… age_da… Age of… INTEGE… <NA>    <NA>    <tibble>
#> 10 NA               egen_011_s… sex     Sex of… TEXT    <NA>    orgc5Y… <tibble>
#> # … with 58 more rows, and abbreviated variable names ¹​data_element_name,
#> #   ²​data_element_shortname, ³​data_element_description,
#> #   ⁴​data_element_valuetype, ⁵​data_element_formname, ⁶​used_optionset_uid
#> # ℹ Use `print(n = ...)` to see more rows
msf_dict("Cholera")
#> # A tibble: 45 × 8
#>    data_element_uid data_elem…¹ data_…² data_…³ data_…⁴ data_…⁵ used_…⁶ options 
#>    <chr>            <chr>       <chr>   <chr>   <chr>   <chr>   <chr>   <list>  
#>  1 AafTlSwliVQ      egen_001_p… case_n… Anonym… TEXT    Case n… <NA>    <tibble>
#>  2 OTGOtWBz39J      egen_004_d… date_o… Date p… DATE    Date o… <NA>    <tibble>
#>  3 wnmMr2V3T3u      egen_006_p… patien… Locati… ORGANI… Patien… <NA>    <tibble>
#>  4 sbgqjeVwtb8      egen_008_a… age_ye… Age of… INTEGE… Age in… <NA>    <tibble>
#>  5 eXYhovYyl61      egen_009_a… age_mo… Age of… INTEGE… Age in… <NA>    <tibble>
#>  6 UrYJSk2Wp46      egen_010_a… age_da… Age of… INTEGE… Age in… <NA>    <tibble>
#>  7 D1Ky5K7pFN6      egen_011_s… sex     Sex of… TEXT    Sex     orgc5Y… <tibble>
#>  8 dTm5R53YYXC      egen_012_p… pregna… Pregna… TEXT    Pregna… IEjzG2… <tibble>
#>  9 FF7d81Zy0yQ      egen_013_p… trimes… If pre… TEXT    Trimes… QjGHFN… <tibble>
#> 10 vLAmA6Pmjip      egen_014_p… foetus… If pre… TEXT    Foetus… SR8Jtf… <tibble>
#> # … with 35 more rows, and abbreviated variable names ¹​data_element_name,
#> #   ²​data_element_shortname, ³​data_element_description,
#> #   ⁴​data_element_valuetype, ⁵​data_element_formname, ⁶​used_optionset_uid
#> # ℹ Use `print(n = ...)` to see more rows
msf_dict("Measles")
#> # A tibble: 52 × 8
#>    data_element_uid data_elem…¹ data_…² data_…³ data_…⁴ data_…⁵ used_…⁶ options 
#>    <chr>            <chr>       <chr>   <chr>   <chr>   <chr>   <chr>   <list>  
#>  1 DE_EGEN_001      egen_001_p… case_n… Anonym… TEXT    Case n… <NA>    <tibble>
#>  2 DE_EGEN_004      egen_004_d… date_o… Date p… DATE    Date o… <NA>    <tibble>
#>  3 DE_EGEN_005      egen_005_p… patien… Patien… TEXT    Patien… YNeOOp… <tibble>
#>  4 DE_EGEN_006      egen_006_p… patien… Locati… ORGANI… Patien… <NA>    <tibble>
#>  5 DE_EGEN_008      egen_008_a… age_ye… Age of… INTEGE… Age in… <NA>    <tibble>
#>  6 DE_EGEN_009      egen_009_a… age_mo… Age of… INTEGE… Age in… <NA>    <tibble>
#>  7 DE_EGEN_010      egen_010_a… age_da… Age of… INTEGE… Age in… <NA>    <tibble>
#>  8 DE_EGEN_011      egen_011_s… sex     Sex of… TEXT    Sex     orgc5Y… <tibble>
#>  9 DE_EGEN_012      egen_012_p… pregna… Pregna… TEXT    Pregna… IEjzG2… <tibble>
#> 10 DE_EGEN_013      egen_013_p… trimes… If pre… TEXT    Trimes… QjGHFN… <tibble>
#> # … with 42 more rows, and abbreviated variable names ¹​data_element_name,
#> #   ²​data_element_shortname, ³​data_element_description,
#> #   ⁴​data_element_valuetype, ⁵​data_element_formname, ⁶​used_optionset_uid
#> # ℹ Use `print(n = ...)` to see more rows
msf_dict("Meningitis")
#> # A tibble: 53 × 8
#>    data_element_uid data_elem…¹ data_…² data_…³ data_…⁴ data_…⁵ used_…⁶ options 
#>    <chr>            <chr>       <chr>   <chr>   <chr>   <chr>   <chr>   <list>  
#>  1 AafTlSwliVQ      egen_001_p… case_n… Anonym… TEXT    Case n… <NA>    <tibble>
#>  2 OTGOtWBz39J      egen_004_d… date_o… Date p… DATE    Date o… <NA>    <tibble>
#>  3 udXAcFEE1dl      egen_005_p… patien… Patien… TEXT    Patien… YNeOOp… <tibble>
#>  4 wnmMr2V3T3u      egen_006_p… patien… Locati… ORGANI… Patien… <NA>    <tibble>
#>  5 sbgqjeVwtb8      egen_008_a… age_ye… Age of… INTEGE… Age in… <NA>    <tibble>
#>  6 eXYhovYyl61      egen_009_a… age_mo… Age of… INTEGE… Age in… <NA>    <tibble>
#>  7 UrYJSk2Wp46      egen_010_a… age_da… Age of… INTEGE… Age in… <NA>    <tibble>
#>  8 D1Ky5K7pFN6      egen_011_s… sex     Sex of… TEXT    Sex     orgc5Y… <tibble>
#>  9 ADfNqpCL5kf      egen_015_e… exit_s… Final … TEXT    Exit s… hO9TET… <tibble>
#> 10 JZ8yqTow79G      egen_016_d… date_o… Date p… DATE    Exit d… <NA>    <tibble>
#> # … with 43 more rows, and abbreviated variable names ¹​data_element_name,
#> #   ²​data_element_shortname, ³​data_element_description,
#> #   ⁴​data_element_valuetype, ⁵​data_element_formname, ⁶​used_optionset_uid
#> # ℹ Use `print(n = ...)` to see more rows
```

</details>

In addition, there are four MSF survey dictionaries available:

-   Retrospective mortality and access to care (“Mortality”)
-   Malnutrition (“Nutrition”)
-   Vaccination coverage long form (“vaccination_long”)
-   Vaccination coverage short form (“vaccination_short”)

> You can read more about the survey dictionaries at
> <https://r4epis.netlify.com/surveys>

These are accessible via `msf_dict_survey()` where the variables are in
`name`. You can also read in your own Kobo (ODK) dictionaries by
specifying `tempalte = FALSE` and then setting
`name = <path to your .xlsx>`.

<details>
<!--
NOTE: everything inside the details tag will be collapsed and effectively
hidden from the user
-->
<summary style="text-decoration: underline">
Click here for code examples
</summary>

``` r
msf_dict_survey("Mortality")
#> # A tibble: 174 × 15
#>    type    name  short…¹ label…² label…³ hint_…⁴ hint_…⁵ default relev…⁶ appea…⁷
#>    <chr>   <chr> <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>  
#>  1 start   start start   Start … <NA>    <NA>    <NA>    <NA>    <NA>    <NA>   
#>  2 end     end   end     End Ti… <NA>    <NA>    <NA>    <NA>    <NA>    <NA>   
#>  3 today   today today   Date o… <NA>    <NA>    <NA>    <NA>    <NA>    <NA>   
#>  4 device… devi… device… Phone … <NA>    <NA>    <NA>    <NA>    <NA>    <NA>   
#>  5 date    date  Date o… Date    Date    <NA>    <NA>    today() <NA>    <NA>   
#>  6 integer team… Team n… Team n… Numéro… <NA>    <NA>    <NA>    <NA>    numbers
#>  7 village vill… Villag… Villag… Nom du… <NA>    <NA>    <NA>    <NA>    <NA>   
#>  8 text    vill… Other … Specif… Autre,… <NA>    <NA>    <NA>    ${vill… <NA>   
#>  9 integer clus… Cluste… Cluste… Numéro… <NA>    <NA>    <NA>    <NA>    numbers
#> 10 integer hous… Househ… Househ… Numéro… <NA>    <NA>    <NA>    <NA>    numbers
#> # … with 164 more rows, 5 more variables: constraint <chr>, repeat_count <chr>,
#> #   calculation <chr>, value_type <chr>, options <list>, and abbreviated
#> #   variable names ¹​short_name, ²​label_english, ³​label_french, ⁴​hint_english,
#> #   ⁵​hint_french, ⁶​relevant, ⁷​appearance
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
msf_dict_survey("Nutrition")
#> # A tibble: 27 × 15
#>    type    name  short…¹ label…² label…³ hint_…⁴ hint_…⁵ repea…⁶ relev…⁷ calcu…⁸
#>    <chr>   <chr> <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <lgl>  
#>  1 start   start <NA>    Start … <NA>    <NA>    <NA>    <NA>    <NA>    NA     
#>  2 end     end   <NA>    End Ti… <NA>    <NA>    <NA>    <NA>    <NA>    NA     
#>  3 today   today <NA>    Date o… <NA>    <NA>    <NA>    <NA>    <NA>    NA     
#>  4 device… devi… <NA>    Phone … <NA>    <NA>    <NA>    <NA>    <NA>    NA     
#>  5 date    date  Date    Date    <NA>    <NA>    <NA>    <NA>    <NA>    NA     
#>  6 integer team… Team n… Team n… <NA>    <NA>    <NA>    <NA>    <NA>    NA     
#>  7 village vill… Villag… Villag… Nom du… <NA>    <NA>    <NA>    <NA>    NA     
#>  8 text    vill… Other … Specif… Précis… <NA>    <NA>    <NA>    ${vill… NA     
#>  9 geopoi… vill… Villag… Villag… Locali… <NA>    <NA>    <NA>    <NA>    NA     
#> 10 integer clus… Cluste… Cluste… Numéro… <NA>    <NA>    <NA>    <NA>    NA     
#> # … with 17 more rows, 5 more variables: constraint <chr>, appearance <chr>,
#> #   default <chr>, value_type <chr>, options <list>, and abbreviated variable
#> #   names ¹​short_name, ²​label_english, ³​label_french, ⁴​hint_english,
#> #   ⁵​hint_french, ⁶​repeat_count, ⁷​relevant, ⁸​calculation
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
msf_dict_survey("Vaccination_long")
#> # A tibble: 106 × 15
#>    type    name  short…¹ label…² label…³ hint_…⁴ hint_…⁵ default relev…⁶ appea…⁷
#>    <chr>   <chr> <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>  
#>  1 start   start <NA>    Start … Start … <NA>    <NA>    <NA>    <NA>    <NA>   
#>  2 end     end   <NA>    End Ti… End Ti… <NA>    <NA>    <NA>    <NA>    <NA>   
#>  3 today   today <NA>    Date o… Date o… <NA>    <NA>    <NA>    <NA>    <NA>   
#>  4 device… devi… <NA>    Phone … Phone … <NA>    <NA>    <NA>    <NA>    <NA>   
#>  5 date    date  Date    Date    Date    <NA>    <NA>    today() <NA>    <NA>   
#>  6 integer team… Team n… Team n… Numéro… <NA>    <NA>    <NA>    <NA>    <NA>   
#>  7 village vill… Villag… Villag… Nom du… <NA>    <NA>    <NA>    <NA>    <NA>   
#>  8 text    vill… Other … Specif… Veuill… <NA>    <NA>    <NA>    ${vill… <NA>   
#>  9 integer clus… Cluste… Cluste… Numéro… <NA>    <NA>    <NA>    <NA>    numbers
#> 10 integer hous… Househ… Househ… Numéro… <NA>    <NA>    <NA>    <NA>    <NA>   
#> # … with 96 more rows, 5 more variables: repeat_count <chr>, constraint <chr>,
#> #   calculation <chr>, value_type <chr>, options <list>, and abbreviated
#> #   variable names ¹​short_name, ²​label_english, ³​label_french, ⁴​hint_english,
#> #   ⁵​hint_french, ⁶​relevant, ⁷​appearance
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
msf_dict_survey("Vaccination_short")
#> # A tibble: 38 × 16
#>    type    name  short…¹ label…² label…³ hint_…⁴ hint_…⁵ default relev…⁶ appea…⁷
#>    <chr>   <chr> <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>  
#>  1 start   start <NA>    Start … Start … <NA>    <NA>    <NA>    <NA>    <NA>   
#>  2 end     end   <NA>    End Ti… End Ti… <NA>    <NA>    <NA>    <NA>    <NA>   
#>  3 today   today <NA>    Date o… Date o… <NA>    <NA>    <NA>    <NA>    <NA>   
#>  4 device… devi… <NA>    Phone … Phone … <NA>    <NA>    <NA>    <NA>    <NA>   
#>  5 date    date  Date    Date    Date    <NA>    <NA>    .today… <NA>    <NA>   
#>  6 integer team… Team n… Team n… Numéro… <NA>    <NA>    <NA>    <NA>    <NA>   
#>  7 village vill… Villag… Villag… Nom du… <NA>    <NA>    <NA>    <NA>    <NA>   
#>  8 text    vill… Other … Specif… Veuill… <NA>    <NA>    <NA>    ${vill… <NA>   
#>  9 integer clus… Cluste… Cluste… Numéro… <NA>    <NA>    <NA>    <NA>    numbers
#> 10 integer hous… Househ… Househ… Numéro… <NA>    <NA>    <NA>    <NA>    <NA>   
#> # … with 28 more rows, 6 more variables: repeat_count <chr>, constraint <chr>,
#> #   calculation <chr>, hxl <chr>, value_type <chr>, options <list>, and
#> #   abbreviated variable names ¹​short_name, ²​label_english, ³​label_french,
#> #   ⁴​hint_english, ⁵​hint_french, ⁶​relevant, ⁷​appearance
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
```

</details>

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
gen_data("Measles", varnames = "data_element_shortname", numcases = 100, org = "MSF")
#> # A tibble: 100 × 52
#>    case_number date_of_c…¹ patie…² patie…³ age_y…⁴ age_m…⁵ age_d…⁶ sex   pregn…⁷
#>    <chr>       <date>      <fct>   <chr>     <int>   <int>   <int> <fct> <fct>  
#>  1 A1          2018-04-05  IP      Villag…      38      NA      NA M     NA     
#>  2 A2          2018-01-07  OP      Villag…      77      NA      NA M     NA     
#>  3 A3          2018-03-18  IP      Villag…      13      NA      NA F     NA     
#>  4 A4          2018-02-16  IP      Villag…      28      NA      NA F     Y      
#>  5 A5          2018-03-25  IP      Villag…      NA      NA       9 U     NA     
#>  6 A6          2018-03-16  IP      Villag…      24      NA      NA F     Y      
#>  7 A7          2018-04-09  OP      Villag…      86      NA      NA M     NA     
#>  8 A8          2018-04-08  IP      Villag…       8      NA      NA U     NA     
#>  9 A9          2018-03-23  OP      Villag…      60      NA      NA M     NA     
#> 10 A10         2018-04-23  OP      Villag…      21      NA      NA U     NA     
#> # … with 90 more rows, 43 more variables: trimester <fct>,
#> #   foetus_alive_at_admission <fct>, exit_status <fct>, date_of_exit <date>,
#> #   time_to_death <fct>, pregnancy_outcome_at_exit <fct>,
#> #   baby_born_with_complications <fct>, previously_vaccinated <fct>,
#> #   previous_vaccine_doses_received <fct>, detected_by <fct>,
#> #   msf_involvement <fct>, residential_status <fct>,
#> #   residential_status_brief <fct>, date_of_last_vaccination <date>, …
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
gen_data("Vaccination_long", varnames = "name", numcases = 100, org = "MSF")
#> # A tibble: 100 × 120
#>    start end   today deviceid date       team_…¹ villa…² villa…³ clust…⁴ house…⁵
#>    <lgl> <lgl> <lgl> <lgl>    <date>     <lgl>   <fct>   <lgl>     <dbl>   <int>
#>  1 NA    NA    NA    NA       2018-02-18 NA      villag… NA            1       1
#>  2 NA    NA    NA    NA       2018-02-13 NA      villag… NA            7       2
#>  3 NA    NA    NA    NA       2018-02-21 NA      villag… NA            6       1
#>  4 NA    NA    NA    NA       2018-02-24 NA      other   NA           11       1
#>  5 NA    NA    NA    NA       2018-03-21 NA      villag… NA            3       1
#>  6 NA    NA    NA    NA       2018-04-06 NA      villag… NA            7       1
#>  7 NA    NA    NA    NA       2018-02-09 NA      villag… NA            3       2
#>  8 NA    NA    NA    NA       2018-04-29 NA      villag… NA            4       3
#>  9 NA    NA    NA    NA       2018-04-15 NA      villag… NA            8       1
#> 10 NA    NA    NA    NA       2018-03-26 NA      villag… NA            8       3
#> # … with 90 more rows, 110 more variables: households_building <int>,
#> #   random_hh <int>, consent <chr>, no_consent_reason <fct>,
#> #   no_consent_other <lgl>, caretaker_relation <fct>, caretaker_other <lgl>,
#> #   number_children <dbl>, child_number <chr>, sex <fct>, date_birth <date>,
#> #   age_years <int>, age_months <int>, any_vaccine <fct>, vaccine_card <fct>,
#> #   hf_records <fct>, health_facility <lgl>, date_records_checked <date>,
#> #   injection_upper_arm <fct>, scar_present <fct>, poliodrop_woc <fct>, …
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
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
#>    case_number date_of_c…¹ patie…² age_y…³ age_m…⁴ age_d…⁵ sex   pregn…⁶ trime…⁷
#>    <chr>       <date>      <chr>     <int>   <int>   <int> <fct> <fct>   <fct>  
#>  1 A1          2018-03-08  Villag…       8      NA      NA M     NA      <NA>   
#>  2 A2          2018-04-09  Villag…       9      NA      NA U     NA      <NA>   
#>  3 A3          2018-02-21  Villag…       8      NA      NA M     NA      <NA>   
#>  4 A4          2018-04-24  Villag…       3      NA      NA U     NA      <NA>   
#>  5 A5          2018-04-07  Villag…      52      NA      NA M     NA      <NA>   
#>  6 A6          2018-01-30  Villag…      24      NA      NA M     NA      <NA>   
#>  7 A7          2018-02-21  Villag…      57      NA      NA U     NA      <NA>   
#>  8 A8          2018-01-10  Villag…      12      NA      NA F     NA      <NA>   
#>  9 A9          2018-01-11  Villag…      NA      NA       3 U     NA      <NA>   
#> 10 A10         2018-04-02  Villag…       7      NA      NA F     Y       2      
#> 11 A11         2018-04-10  Villag…      12      NA      NA F     W       <NA>   
#> 12 A12         2018-02-19  Villag…      23      NA      NA M     NA      <NA>   
#> 13 A13         2018-02-12  Villag…      NA       8      NA F     N       <NA>   
#> 14 A14         2018-01-31  Villag…      66      NA      NA U     NA      <NA>   
#> 15 A15         2018-01-11  Villag…       7      NA      NA U     NA      <NA>   
#> 16 A16         2018-04-22  Villag…      25      NA      NA M     NA      <NA>   
#> 17 A17         2018-01-10  Villag…      27      NA      NA F     NA      <NA>   
#> 18 A18         2018-01-18  Villag…      16      NA      NA F     N       <NA>   
#> 19 A19         2018-03-05  Villag…       9      NA      NA F     NA      <NA>   
#> 20 A20         2018-02-13  Villag…       8      NA      NA M     NA      <NA>   
#> # … with 36 more variables: foetus_alive_at_admission <fct>, exit_status <fct>,
#> #   date_of_exit <date>, time_to_death <fct>, pregnancy_outcome_at_exit <fct>,
#> #   previously_vaccinated <fct>, previous_vaccine_doses_received <fct>,
#> #   readmission <fct>, msf_involvement <fct>,
#> #   cholera_treatment_facility_type <fct>, residential_status_brief <fct>,
#> #   date_of_last_vaccination <date>, prescribed_zinc_supplement <fct>,
#> #   prescribed_antibiotics <fct>, ors_consumed_litres <int>, …
#> # ℹ Use `colnames()` to see all variable names

# We want the expanded dictionary, so we will select `compact = FALSE`
dict <- msf_dict(disease = "Cholera", 
  long    = TRUE,
  compact = FALSE,
  tibble  = TRUE
)
print(dict)
#> # A tibble: 182 × 11
#>    data_elemen…¹ data_…² data_…³ data_…⁴ data_…⁵ data_…⁶ used_…⁷ optio…⁸ optio…⁹
#>    <chr>         <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>  
#>  1 AafTlSwliVQ   egen_0… case_n… Anonym… TEXT    Case n… <NA>    <NA>    <NA>   
#>  2 OTGOtWBz39J   egen_0… date_o… Date p… DATE    Date o… <NA>    <NA>    <NA>   
#>  3 wnmMr2V3T3u   egen_0… patien… Locati… ORGANI… Patien… <NA>    <NA>    <NA>   
#>  4 sbgqjeVwtb8   egen_0… age_ye… Age of… INTEGE… Age in… <NA>    <NA>    <NA>   
#>  5 eXYhovYyl61   egen_0… age_mo… Age of… INTEGE… Age in… <NA>    <NA>    <NA>   
#>  6 UrYJSk2Wp46   egen_0… age_da… Age of… INTEGE… Age in… <NA>    <NA>    <NA>   
#>  7 D1Ky5K7pFN6   egen_0… sex     Sex of… TEXT    Sex     orgc5Y… M       Male   
#>  8 D1Ky5K7pFN6   egen_0… sex     Sex of… TEXT    Sex     orgc5Y… F       Female 
#>  9 D1Ky5K7pFN6   egen_0… sex     Sex of… TEXT    Sex     orgc5Y… U       Unknow…
#> 10 dTm5R53YYXC   egen_0… pregna… Pregna… TEXT    Pregna… IEjzG2… N       Not cu…
#> # … with 172 more rows, 2 more variables: option_uid <chr>,
#> #   option_order_in_set <dbl>, and abbreviated variable names
#> #   ¹​data_element_uid, ²​data_element_name, ³​data_element_shortname,
#> #   ⁴​data_element_description, ⁵​data_element_valuetype, ⁶​data_element_formname,
#> #   ⁷​used_optionset_uid, ⁸​option_code, ⁹​option_name
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

# Now we can use matchmaker to filter the data
dat_clean <- matchmaker::match_df(dat, dict, 
  from  = "option_code",
  to    = "option_name",
  by    = "data_element_shortname",
  order = "option_order_in_set"
)
print(dat_clean)
#> # A tibble: 20 × 45
#>    case_number date_of_c…¹ patie…² age_y…³ age_m…⁴ age_d…⁵ sex   pregn…⁶ trime…⁷
#>    <chr>       <date>      <chr>     <int>   <int>   <int> <fct> <fct>   <fct>  
#>  1 A1          2018-03-08  Villag…       8      NA      NA Male  Not ap… <NA>   
#>  2 A2          2018-04-09  Villag…       9      NA      NA Unkn… Not ap… <NA>   
#>  3 A3          2018-02-21  Villag…       8      NA      NA Male  Not ap… <NA>   
#>  4 A4          2018-04-24  Villag…       3      NA      NA Unkn… Not ap… <NA>   
#>  5 A5          2018-04-07  Villag…      52      NA      NA Male  Not ap… <NA>   
#>  6 A6          2018-01-30  Villag…      24      NA      NA Male  Not ap… <NA>   
#>  7 A7          2018-02-21  Villag…      57      NA      NA Unkn… Not ap… <NA>   
#>  8 A8          2018-01-10  Villag…      12      NA      NA Fema… Not ap… <NA>   
#>  9 A9          2018-01-11  Villag…      NA      NA       3 Unkn… Not ap… <NA>   
#> 10 A10         2018-04-02  Villag…       7      NA      NA Fema… Yes, c… 2nd tr…
#> 11 A11         2018-04-10  Villag…      12      NA      NA Fema… Was pr… <NA>   
#> 12 A12         2018-02-19  Villag…      23      NA      NA Male  Not ap… <NA>   
#> 13 A13         2018-02-12  Villag…      NA       8      NA Fema… Not cu… <NA>   
#> 14 A14         2018-01-31  Villag…      66      NA      NA Unkn… Not ap… <NA>   
#> 15 A15         2018-01-11  Villag…       7      NA      NA Unkn… Not ap… <NA>   
#> 16 A16         2018-04-22  Villag…      25      NA      NA Male  Not ap… <NA>   
#> 17 A17         2018-01-10  Villag…      27      NA      NA Fema… Not ap… <NA>   
#> 18 A18         2018-01-18  Villag…      16      NA      NA Fema… Not cu… <NA>   
#> 19 A19         2018-03-05  Villag…       9      NA      NA Fema… Not ap… <NA>   
#> 20 A20         2018-02-13  Villag…       8      NA      NA Male  Not ap… <NA>   
#> # … with 36 more variables: foetus_alive_at_admission <fct>, exit_status <fct>,
#> #   date_of_exit <date>, time_to_death <fct>, pregnancy_outcome_at_exit <fct>,
#> #   previously_vaccinated <fct>, previous_vaccine_doses_received <fct>,
#> #   readmission <fct>, msf_involvement <fct>,
#> #   cholera_treatment_facility_type <fct>, residential_status_brief <fct>,
#> #   date_of_last_vaccination <date>, prescribed_zinc_supplement <fct>,
#> #   prescribed_antibiotics <fct>, ors_consumed_litres <int>, …
#> # ℹ Use `colnames()` to see all variable names
```

</details>

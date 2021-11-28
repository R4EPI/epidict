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

You can install {epidict} from the R4EPI repository:

``` r
# install.packages("drat")
drat::addRepo("R4EPI")
install.packages("epidict")
```

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
#> # A tibble: 68 x 8
#>    data_element_uid data_element_name   data_element_sho~ data_element_descript~
#>    <lgl>            <chr>               <chr>             <chr>                 
#>  1 NA               egen_044_event_fil~ event_file_type   Is the event file for~
#>  2 NA               egen_001_patient_c~ case_number       Anonymised patient nu~
#>  3 NA               egen_004_date_of_c~ date_of_consulta~ Date patient presents~
#>  4 NA               egen_022_detected_~ detected_by       How patient was ident~
#>  5 NA               egen_005_patient_f~ patient_facility~ Patient is presenting~
#>  6 NA               egen_029_msf_invol~ msf_involvement   How extensive is MSF'~
#>  7 NA               egen_008_age_years  age_years         Age of patient (in ye~
#>  8 NA               egen_009_age_months age_months        Age of patient in mon~
#>  9 NA               egen_010_age_days   age_days          Age of patient in day~
#> 10 NA               egen_011_sex        sex               Sex of patient (If Tr~
#> # ... with 58 more rows, and 4 more variables: data_element_valuetype <chr>,
#> #   data_element_formname <chr>, used_optionset_uid <chr>, options <list>
msf_dict("Cholera")
#> # A tibble: 45 x 8
#>    data_element_uid data_element_name    data_element_sho~ data_element_descrip~
#>    <chr>            <chr>                <chr>             <chr>                
#>  1 FF7d81Zy0yQ      egen_013_pregnancy_~ trimester         If pregnant, trimest~
#>  2 ADfNqpCL5kf      egen_015_exit_status exit_status       Final status of pati~
#>  3 wjCDTwXmtix      egen_064_treatment_~ treatment_facili~ Name of facility/sit~
#>  4 UUVnMdaBY5T      esym_002_dehydratio~ dehydration_leve~ Dehydration based on~
#>  5 BTZdJKpS3S5      egen_059_comments_o~ comments_on_lab_~ Any additional comme~
#>  6 bpT8T341oQG      egen_054_fluids_tre~ fluids_treatment~ What was the fluids ~
#>  7 FqPqIr5m0AQ      egen_017_time_betwe~ time_to_death     Hours between patien~
#>  8 epbKb1GczaS      esym_003_malaria_rd~ malaria_rdt_at_a~ Malaria rapid diagno~
#>  9 F04TM58HHsd      egen_020_previously~ previously_vacci~ Has the patient prev~
#> 10 CfRNuWWuTr5      egen_058_cholera_pc~ cholera_pcr_resu~ Was a PCR test for c~
#> # ... with 35 more rows, and 4 more variables: data_element_valuetype <chr>,
#> #   data_element_formname <chr>, used_optionset_uid <chr>, options <list>
msf_dict("Measles")
#> # A tibble: 52 x 8
#>    data_element_uid data_element_name    data_element_sho~ data_element_descrip~
#>    <chr>            <chr>                <chr>             <chr>                
#>  1 DE_ESYM_012      esym_012_seizures    seizure_episodes  Complication (Seizur~
#>  2 DE_EGEN_013      egen_013_pregnancy_~ trimester         If pregnant, trimest~
#>  3 DE_ESYM_014      esym_014_croup       croup             Complication (Croup)~
#>  4 DE_ESYM_002      esym_002_dehydratio~ dehydration_leve~ Dehydration based on~
#>  5 DE_EGEN_030      egen_030_residentia~ residential_stat~ Whether the patient ~
#>  6 DE_EGEN_020      egen_020_previously~ previously_vacci~ Has the patient prev~
#>  7 DE_EGEN_062      egen_062_patient_or~ patient_origin_f~ Name of village or p~
#>  8 DE_EGEN_010      egen_010_age_days    age_days          Age of patient in da~
#>  9 DE_EGEN_029      egen_029_msf_involv~ msf_involvement   How extensive is MSF~
#> 10 DE_EGEN_053      egen_053_nutrition_~ nutrition_status~ What is the nutritio~
#> # ... with 42 more rows, and 4 more variables: data_element_valuetype <chr>,
#> #   data_element_formname <chr>, used_optionset_uid <chr>, options <list>
msf_dict("Meningitis")
#> # A tibble: 53 x 8
#>    data_element_uid data_element_name    data_element_sh~ data_element_descript~
#>    <chr>            <chr>                <chr>            <chr>                 
#>  1 Ow8ss6T1tT5      esym_028_seizures_a~ seizures_at_adm~ Presenting symptoms (~
#>  2 CEEr9lcwKVG      esym_036_kernigs_br~ kernigs_brudzin~ Presenting symptoms (~
#>  3 tIe59Htd2Ba      esym_012_seizures    seizure_episodes Complication (Seizure~
#>  4 Sjms36Aj6bT      esym_023_febrile_co~ febrile_coma     Complication (Febrile~
#>  5 BTZdJKpS3S5      egen_059_comments_o~ comments_on_lab~ Any additional commen~
#>  6 wHnNEMRrS5A      esym_025_chills_at_~ chills           Presenting symptoms (~
#>  7 T3Gn8mTYu0c      esym_026_stiff_neck~ stiff_neck       Presenting symptoms (~
#>  8 JCexRYsmjmS      eobr_006_ti_sample_~ ti_result_organ~ TI sample result - or~
#>  9 myL5BYzy6zW      esym_034_coma_at_ad~ coma             Presenting symptoms (~
#> 10 AhllpMovCeu      egen_062_patient_or~ patient_origin_~ Name of village or pa~
#> # ... with 43 more rows, and 4 more variables: data_element_valuetype <chr>,
#> #   data_element_formname <chr>, used_optionset_uid <chr>, options <list>
```

</details>

In addition, there are three MSF survey dictionaries available:

-   Retrospective mortality and access to care (“mortality”)
-   Malnutrition (“nutrition”)
-   Vaccination Coverage (“vaccination”)

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
#> # A tibble: 174 x 14
#>    type     name    label_english  label_french hint_english hint_french default
#>    <chr>    <chr>   <chr>          <chr>        <chr>        <chr>       <chr>  
#>  1 start    start   Start Time     <NA>         <NA>         <NA>        <NA>   
#>  2 end      end     End Time       <NA>         <NA>         <NA>        <NA>   
#>  3 today    today   Date of Survey <NA>         <NA>         <NA>        <NA>   
#>  4 deviceid device~ Phone Serial ~ <NA>         <NA>         <NA>        <NA>   
#>  5 date     date    Date           Date         <NA>         <NA>        today()
#>  6 integer  team_n~ Team number    Numéro d'éq~ <NA>         <NA>        <NA>   
#>  7 village  villag~ Village name   Nom du vill~ <NA>         <NA>        <NA>   
#>  8 text     villag~ Specify other  Autre, spéc~ <NA>         <NA>        <NA>   
#>  9 integer  cluste~ Cluster number Numéro de l~ <NA>         <NA>        <NA>   
#> 10 integer  househ~ Household num~ Numéro du m~ <NA>         <NA>        <NA>   
#> # ... with 164 more rows, and 7 more variables: relevant <chr>,
#> #   appearance <chr>, constraint <chr>, repeat_count <chr>, calculation <chr>,
#> #   value_type <chr>, options <list>
msf_dict_survey("Nutrition")
#> # A tibble: 27 x 14
#>    type     name  label_english label_french hint_english hint_french repeat_count
#>    <chr>    <chr> <chr>         <chr>        <chr>        <chr>       <chr>       
#>  1 start    start Start Time    <NA>         <NA>         <NA>        <NA>        
#>  2 end      end   End Time      <NA>         <NA>         <NA>        <NA>        
#>  3 today    today Date of Surv~ <NA>         <NA>         <NA>        <NA>        
#>  4 deviceid devi~ Phone Serial~ <NA>         <NA>         <NA>        <NA>        
#>  5 date     date  Date          <NA>         <NA>         <NA>        <NA>        
#>  6 integer  team~ Team number   <NA>         <NA>         <NA>        <NA>        
#>  7 village  vill~ Village name  Nom du vill~ <NA>         <NA>        <NA>        
#>  8 text     vill~ Specify other Précisez au~ <NA>         <NA>        <NA>        
#>  9 geopoint vill~ Village loca~ Localisatio~ <NA>         <NA>        <NA>        
#> 10 integer  clus~ Cluster numb~ Numéro de g~ <NA>         <NA>        <NA>        
#> # ... with 17 more rows, and 7 more variables: relevant <chr>,
#> #   calculation <lgl>, constraint <chr>, appearance <chr>, default <chr>,
#> #   value_type <chr>, options <list>
msf_dict_survey("Vaccination")
#> # A tibble: 106 x 14
#>    type     name   label_english  label_french  hint_english hint_french default
#>    <chr>    <chr>  <chr>          <chr>         <chr>        <chr>       <chr>  
#>  1 start    start  Start Time     Start Time    <NA>         <NA>        <NA>   
#>  2 end      end    End Time       End Time      <NA>         <NA>        <NA>   
#>  3 today    today  Date of Survey Date of Surv~ <NA>         <NA>        <NA>   
#>  4 deviceid devic~ Phone Serial ~ Phone Serial~ <NA>         <NA>        <NA>   
#>  5 date     date   Date           Date          <NA>         <NA>        today()
#>  6 integer  team_~ Team number    Numéro de l'~ <NA>         <NA>        <NA>   
#>  7 village  villa~ Village name   Nom du villa~ <NA>         <NA>        <NA>   
#>  8 text     villa~ Specify other  Veuillez spé~ <NA>         <NA>        <NA>   
#>  9 integer  clust~ Cluster number Numéro de la~ <NA>         <NA>        <NA>   
#> 10 integer  house~ Household num~ Numéro du mé~ <NA>         <NA>        <NA>   
#> # ... with 96 more rows, and 7 more variables: relevant <chr>,
#> #   appearance <chr>, repeat_count <chr>, constraint <chr>, calculation <chr>,
#> #   value_type <chr>, options <list>
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
#> # A tibble: 100 x 52
#>    seizure_episodes trimester croup dehydration_level_at_admi~ residential_stat~
#>    <fct>            <fct>     <fct> <fct>                      <fct>            
#>  1 0                3         1     SO                         3                
#>  2 1                <NA>      0     SO                         4                
#>  3 1                <NA>      1     NO                         5                
#>  4 1                <NA>      1     SE                         5                
#>  5 1                <NA>      1     SO                         2                
#>  6 0                <NA>      1     UN                         3                
#>  7 0                <NA>      1     SE                         1                
#>  8 0                <NA>      1     SO                         5                
#>  9 0                <NA>      1     SE                         4                
#> 10 0                <NA>      0     NO                         4                
#> # ... with 90 more rows, and 47 more variables: previously_vaccinated <fct>,
#> #   patient_origin_free_text <chr>, age_days <int>, msf_involvement <fct>,
#> #   nutrition_status_at_admission <fct>, fever <fct>, sex <fct>,
#> #   patient_origin <chr>, pregnancy_outcome_at_exit <fct>,
#> #   prescribed_vitamin_a <fct>, date_of_exit <date>,
#> #   date_of_consultation_admission <date>, event_file_type <fct>,
#> #   residential_status_brief <fct>, other_eye_complications <fct>, ...
gen_data("Vaccination", varnames = "name", numcases = 100, org = "MSF")
#> # A tibble: 100 x 123
#>    start end   today deviceid date       team_number village_name village_other
#>    <lgl> <lgl> <lgl> <lgl>    <date>     <lgl>       <fct>        <lgl>        
#>  1 NA    NA    NA    NA       2018-04-23 NA          village_5    NA           
#>  2 NA    NA    NA    NA       2018-01-06 NA          village_4    NA           
#>  3 NA    NA    NA    NA       2018-03-30 NA          village_6    NA           
#>  4 NA    NA    NA    NA       2018-02-09 NA          village_10   NA           
#>  5 NA    NA    NA    NA       2018-04-02 NA          village_4    NA           
#>  6 NA    NA    NA    NA       2018-01-05 NA          village_3    NA           
#>  7 NA    NA    NA    NA       2018-01-07 NA          village_4    NA           
#>  8 NA    NA    NA    NA       2018-01-11 NA          village_10   NA           
#>  9 NA    NA    NA    NA       2018-04-11 NA          village_1    NA           
#> 10 NA    NA    NA    NA       2018-01-05 NA          village_3    NA           
#> # ... with 90 more rows, and 115 more variables: cluster_number <dbl>,
#> #   household_number <int>, households_building <int>, random_hh <int>,
#> #   consent <chr>, no_consent_reason <fct>, no_consent_other <lgl>,
#> #   caretaker_relation <fct>, caretaker_other <lgl>, children_count <dbl>,
#> #   child_number <chr>, sex <fct>, date_birth <date>, age_years <int>,
#> #   age_months <int>, any_vaccine <fct>, vaccine_card <fct>, hf_records <fct>,
#> #   health_facility <lgl>, date_records_checked <date>, ...
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
#> # A tibble: 20 x 45
#>    trimester exit_status treatment_facilit~ dehydration_level~ comments_on_lab_~
#>    <fct>     <fct>       <lgl>              <fct>              <lgl>            
#>  1 <NA>      DOA         NA                 NO                 NA               
#>  2 2         DOA         NA                 NO                 NA               
#>  3 <NA>      DH          NA                 SO                 NA               
#>  4 <NA>      DD          NA                 SE                 NA               
#>  5 <NA>      DD          NA                 SE                 NA               
#>  6 <NA>      DD          NA                 SO                 NA               
#>  7 <NA>      AD          NA                 UN                 NA               
#>  8 <NA>      DD          NA                 NO                 NA               
#>  9 <NA>      LA          NA                 NO                 NA               
#> 10 <NA>      TR          NA                 NO                 NA               
#> 11 1         LA          NA                 SE                 NA               
#> 12 <NA>      TR          NA                 SE                 NA               
#> 13 <NA>      DH          NA                 SO                 NA               
#> 14 <NA>      TR          NA                 SE                 NA               
#> 15 <NA>      DOA         NA                 NO                 NA               
#> 16 <NA>      DH          NA                 SE                 NA               
#> 17 <NA>      DH          NA                 SE                 NA               
#> 18 <NA>      DH          NA                 SE                 NA               
#> 19 <NA>      LA          NA                 SE                 NA               
#> 20 <NA>      DD          NA                 SO                 NA               
#> # ... with 40 more variables: fluids_treatment_plan <fct>, time_to_death <fct>,
#> #   malaria_rdt_at_admission <fct>, previously_vaccinated <fct>,
#> #   cholera_pcr_result <fct>, iv_fluids_received_litres <int>,
#> #   patient_origin_free_text <chr>, previous_vaccine_doses_received <fct>,
#> #   age_years <int>, arrival_date_in_area_if_3m <date>, age_days <int>,
#> #   msf_involvement <fct>, date_lab_sample_taken <date>, readmission <fct>,
#> #   age_months <int>, date_of_last_vaccination <date>, case_number <chr>, ...

# We want the expanded dictionary, so we will select `compact = FALSE`
dict <- msf_dict(disease = "Cholera", 
  long    = TRUE,
  compact = FALSE,
  tibble  = TRUE
)
print(dict)
#> # A tibble: 182 x 11
#>    data_element_uid data_element_name   data_element_shor~ data_element_descrip~
#>    <chr>            <chr>               <chr>              <chr>                
#>  1 FF7d81Zy0yQ      egen_013_pregnancy~ trimester          If pregnant, trimest~
#>  2 FF7d81Zy0yQ      egen_013_pregnancy~ trimester          If pregnant, trimest~
#>  3 FF7d81Zy0yQ      egen_013_pregnancy~ trimester          If pregnant, trimest~
#>  4 ADfNqpCL5kf      egen_015_exit_stat~ exit_status        Final status of pati~
#>  5 ADfNqpCL5kf      egen_015_exit_stat~ exit_status        Final status of pati~
#>  6 ADfNqpCL5kf      egen_015_exit_stat~ exit_status        Final status of pati~
#>  7 ADfNqpCL5kf      egen_015_exit_stat~ exit_status        Final status of pati~
#>  8 ADfNqpCL5kf      egen_015_exit_stat~ exit_status        Final status of pati~
#>  9 ADfNqpCL5kf      egen_015_exit_stat~ exit_status        Final status of pati~
#> 10 wjCDTwXmtix      egen_064_treatment~ treatment_facilit~ Name of facility/sit~
#> # ... with 172 more rows, and 7 more variables: data_element_valuetype <chr>,
#> #   data_element_formname <chr>, used_optionset_uid <chr>, option_code <chr>,
#> #   option_name <chr>, option_uid <chr>, option_order_in_set <dbl>

# Now we can use matchmaker to filter the data
dat_clean <- matchmaker::match_df(dat, dict, 
  from  = "option_code",
  to    = "option_name",
  by    = "data_element_shortname",
  order = "option_order_in_set"
)
print(dat_clean)
#> # A tibble: 20 x 45
#>    trimester     exit_status  treatment_facil~ dehydration_lev~ comments_on_lab~
#>    <fct>         <fct>        <lgl>            <fct>            <lgl>           
#>  1 <NA>          Dead on arr~ NA               None             NA              
#>  2 2nd trimester Dead on arr~ NA               None             NA              
#>  3 <NA>          Discharged ~ NA               Some             NA              
#>  4 <NA>          Dead in fac~ NA               Severe           NA              
#>  5 <NA>          Dead in fac~ NA               Severe           NA              
#>  6 <NA>          Dead in fac~ NA               Some             NA              
#>  7 <NA>          Transferred~ NA               Unknown          NA              
#>  8 <NA>          Dead in fac~ NA               None             NA              
#>  9 <NA>          Left agains~ NA               None             NA              
#> 10 <NA>          Transferred~ NA               None             NA              
#> 11 1st trimester Left agains~ NA               Severe           NA              
#> 12 <NA>          Transferred~ NA               Severe           NA              
#> 13 <NA>          Discharged ~ NA               Some             NA              
#> 14 <NA>          Transferred~ NA               Severe           NA              
#> 15 <NA>          Dead on arr~ NA               None             NA              
#> 16 <NA>          Discharged ~ NA               Severe           NA              
#> 17 <NA>          Discharged ~ NA               Severe           NA              
#> 18 <NA>          Discharged ~ NA               Severe           NA              
#> 19 <NA>          Left agains~ NA               Severe           NA              
#> 20 <NA>          Dead in fac~ NA               Some             NA              
#> # ... with 40 more variables: fluids_treatment_plan <fct>, time_to_death <fct>,
#> #   malaria_rdt_at_admission <fct>, previously_vaccinated <fct>,
#> #   cholera_pcr_result <fct>, iv_fluids_received_litres <int>,
#> #   patient_origin_free_text <chr>, previous_vaccine_doses_received <fct>,
#> #   age_years <int>, arrival_date_in_area_if_3m <date>, age_days <int>,
#> #   msf_involvement <fct>, date_lab_sample_taken <date>, readmission <fct>,
#> #   age_months <int>, date_of_last_vaccination <date>, case_number <chr>, ...
```

</details>

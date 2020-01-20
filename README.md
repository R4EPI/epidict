epidict
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/epidict)](https://CRAN.R-project.org/package=epidict)
[![Travis build
status](https://travis-ci.org/R4EPI/epidict.svg?branch=master)](https://travis-ci.org/R4EPI/epidict)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/R4EPI/epidict?branch=master&svg=true)](https://ci.appveyor.com/project/R4EPI/epidict)
[![Codecov test
coverage](https://codecov.io/gh/R4EPI/epidict/branch/master/graph/badge.svg)](https://codecov.io/gh/R4EPI/epidict?branch=master)
<!-- badges: end -->

The goal of {epidict} is to provide standardized data dictionaries for
the MSF R4EPIs project.

## Installation

To install a stable version of {epidict}, please use the R4epis
repository:

``` r
# install.packages("drat")
drat::addRepo("R4EPI")
install.packages("epidict")
```

## Accessing dictionaries

There are four MSF outbreak dictionaries available in {epidict}:

  - Cholera/Acute watery diarrhea (“cholera”)
  - Meningitis
  - Measles/Rubella (“measles”)
  - Acute Jaundice Syndrome (often suspected to be Hepatitis E) (“ajs”)

> You can read more about the outbreak dictionaries at
> <https://r4epis.netilfy.com/outbreaks>

The dictionary can be obtained via the `msf_dict()` function, which
specifies a dictionary that describes recorded variables
(`data_element_shortname`) in rows and their possible options (if
categorical):

``` r
library("epidict")
msf_dict("Measles", compact = FALSE)
#> # A tibble: 176 x 11
#>    data_element_uid data_element_na… data_element_sh… data_element_de…
#>    <chr>            <chr>            <chr>            <chr>           
#>  1 DE_ESYM_012      esym_012_seizur… seizure_episodes Complication (S…
#>  2 DE_ESYM_012      esym_012_seizur… seizure_episodes Complication (S…
#>  3 DE_EGEN_013      egen_013_pregna… trimester        If pregnant, tr…
#>  4 DE_EGEN_013      egen_013_pregna… trimester        If pregnant, tr…
#>  5 DE_EGEN_013      egen_013_pregna… trimester        If pregnant, tr…
#>  6 DE_ESYM_014      esym_014_croup   croup            Complication (C…
#>  7 DE_ESYM_014      esym_014_croup   croup            Complication (C…
#>  8 DE_ESYM_002      esym_002_dehydr… dehydration_lev… Dehydration bas…
#>  9 DE_ESYM_002      esym_002_dehydr… dehydration_lev… Dehydration bas…
#> 10 DE_ESYM_002      esym_002_dehydr… dehydration_lev… Dehydration bas…
#> # … with 166 more rows, and 7 more variables:
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, option_code <chr>, option_name <chr>,
#> #   option_uid <chr>, option_order_in_set <dbl>
msf_dict("AJS", compact = FALSE)
#> # A tibble: 215 x 11
#>    data_element_uid data_element_na… data_element_sh… data_element_de…
#>    <lgl>            <chr>            <chr>            <chr>           
#>  1 NA               egen_044_event_… event_file_type  Is the event fi…
#>  2 NA               egen_044_event_… event_file_type  Is the event fi…
#>  3 NA               egen_044_event_… event_file_type  Is the event fi…
#>  4 NA               egen_001_patien… case_number      Anonymised pati…
#>  5 NA               egen_004_date_o… date_of_consult… Date patient pr…
#>  6 NA               egen_022_detect… detected_by      How patient was…
#>  7 NA               egen_022_detect… detected_by      How patient was…
#>  8 NA               egen_022_detect… detected_by      How patient was…
#>  9 NA               egen_022_detect… detected_by      How patient was…
#> 10 NA               egen_005_patien… patient_facilit… Patient is pres…
#> # … with 205 more rows, and 7 more variables:
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, option_code <chr>, option_name <chr>,
#> #   option_uid <chr>, option_order_in_set <dbl>
msf_dict("Cholera", compact = FALSE)
#> # A tibble: 182 x 11
#>    data_element_uid data_element_na… data_element_sh… data_element_de…
#>    <chr>            <chr>            <chr>            <chr>           
#>  1 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr…
#>  2 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr…
#>  3 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr…
#>  4 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  5 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  6 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  7 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  8 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  9 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#> 10 wjCDTwXmtix      egen_064_treatm… treatment_facil… Name of facilit…
#> # … with 172 more rows, and 7 more variables:
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, option_code <chr>, option_name <chr>,
#> #   option_uid <chr>, option_order_in_set <dbl>
msf_dict("Meningitis", compact = FALSE)
#> # A tibble: 173 x 11
#>    data_element_uid data_element_na… data_element_sh… data_element_de…
#>    <chr>            <chr>            <chr>            <chr>           
#>  1 Ow8ss6T1tT5      esym_028_seizur… seizures_at_adm… Presenting symp…
#>  2 Ow8ss6T1tT5      esym_028_seizur… seizures_at_adm… Presenting symp…
#>  3 CEEr9lcwKVG      esym_036_kernig… kernigs_brudzin… Presenting symp…
#>  4 CEEr9lcwKVG      esym_036_kernig… kernigs_brudzin… Presenting symp…
#>  5 tIe59Htd2Ba      esym_012_seizur… seizure_episodes Complication (S…
#>  6 tIe59Htd2Ba      esym_012_seizur… seizure_episodes Complication (S…
#>  7 Sjms36Aj6bT      esym_023_febril… febrile_coma     Complication (F…
#>  8 Sjms36Aj6bT      esym_023_febril… febrile_coma     Complication (F…
#>  9 BTZdJKpS3S5      egen_059_commen… comments_on_lab… Any additional …
#> 10 wHnNEMRrS5A      esym_025_chills… chills           Presenting symp…
#> # … with 163 more rows, and 7 more variables:
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, option_code <chr>, option_name <chr>,
#> #   option_uid <chr>, option_order_in_set <dbl>
```

In addition, there are three MSF survey dictionaries available:

  - Retrospective mortality and access to care (“mortality”)
  - Malnutrition (“nutrition”)
  - Vaccination Coverage (“vaccination”)

> You can read more about the survey dictionaries at
> <https://r4epis.netilfy.com/surveys>

These are accessible via `msf_dict_survey()` where the variables are in
`column_name` and are often labeled by question number.

``` r
msf_dict_survey("Mortality", compact = FALSE)
#> # A tibble: 128 x 7
#>    level column_name description data_element_va… option_code option_name
#>    <dbl> <chr>       <chr>       <chr>            <chr>       <chr>      
#>  1     0 q65_iq4     What house… INTEGER_POSITIVE <NA>        <NA>       
#>  2     0 q66_locati… GPS locati… LONG_TEXT        <NA>        <NA>       
#>  3     0 health_dis… Health Dis… LONG_TEXT        <NA>        <NA>       
#>  4     0 village     Village     LONG_TEXT        <NA>        <NA>       
#>  5     0 cluster_nu… Cluster     INTEGER_POSITIVE 0           <NA>       
#>  6     0 q28_cq1     Head of Ho… TEXT             0           Yes        
#>  7     0 q28_cq1     Head of Ho… TEXT             1           No         
#>  8     0 q45_cq2     Head of Ho… TEXT             0           Yes        
#>  9     0 q45_cq2     Head of Ho… TEXT             1           No         
#> 10     0 q49_cq3     Head of Ho… TEXT             0           Yes        
#> # … with 118 more rows, and 1 more variable: option_order_in_set <int>
msf_dict_survey("Nutrition", compact = FALSE)
#> # A tibble: 29 x 7
#>    level column_name description data_element_va… option_code option_name
#>    <dbl> <chr>       <chr>       <chr>            <chr>       <chr>      
#>  1     0 health_dis… Health Dis… LONG_TEXT        <NA>        <NA>       
#>  2     0 village     Village     LONG_TEXT        <NA>        <NA>       
#>  3     0 cluster_nu… Cluster     INTEGER_POSITIVE 0           <NA>       
#>  4     0 household_… Number of … INTEGER_POSITIVE 0           <NA>       
#>  5     0 q28_cq1     Head of Ho… TEXT             0           Yes        
#>  6     0 q28_cq1     Head of Ho… TEXT             1           No         
#>  7     0 q45_cq2     Head of Ho… TEXT             0           Yes        
#>  8     0 q45_cq2     Head of Ho… TEXT             1           No         
#>  9     0 q49_cq3     Head of Ho… TEXT             0           Yes        
#> 10     0 q49_cq3     Head of Ho… TEXT             1           No         
#> # … with 19 more rows, and 1 more variable: option_order_in_set <int>
msf_dict_survey("Vaccination", compact = FALSE)
#> # A tibble: 113 x 7
#>    level column_name description data_element_va… option_code option_name
#>    <dbl> <chr>       <chr>       <chr>            <chr>       <chr>      
#>  1     0 q77_what_i… What is th… INTEGER_POSITIVE <NA>        <NA>       
#>  2     0 health_dis… Health Dis… LONG_TEXT        <NA>        <NA>       
#>  3     0 village     Village     LONG_TEXT        <NA>        <NA>       
#>  4     0 q14_hh_no   What house… INTEGER_POSITIVE <NA>        <NA>       
#>  5     0 q15_home    Are any oc… TEXT             1           Yes        
#>  6     0 q15_home    Are any oc… TEXT             0           No         
#>  7     0 q16_occupa… How old is… INTEGER_POSITIVE <NA>        <NA>       
#>  8     0 q58_consent Does the o… TEXT             1           Yes        
#>  9     0 q58_consent Does the o… TEXT             0           No         
#> 10     0 q75_careta… What is th… TEXT             1           Mother     
#> # … with 103 more rows, and 1 more variable: option_order_in_set <int>
```

## Generating data

The {epidict} package has a function for generating data that’s called
`gen_data()`, which takes three arguments: The dictionary, which column
describes the variable names, and how many rows are needed in the
output.

``` r
gen_data("Measles", varnames = "data_element_shortname", numcases = 100, org = "MSF")
#> # A tibble: 100 x 52
#>    seizure_episodes trimester croup dehydration_lev… residential_sta…
#>    <fct>            <fct>     <fct> <fct>            <fct>           
#>  1 1                <NA>      0     SO               5               
#>  2 0                <NA>      1     UN               2               
#>  3 1                <NA>      1     SO               3               
#>  4 1                <NA>      1     SE               4               
#>  5 1                <NA>      0     SE               3               
#>  6 1                <NA>      1     SO               2               
#>  7 0                <NA>      1     UN               2               
#>  8 0                1         0     UN               4               
#>  9 1                <NA>      1     UN               5               
#> 10 1                <NA>      0     SO               5               
#> # … with 90 more rows, and 47 more variables:
#> #   previously_vaccinated <fct>, patient_origin_free_text <chr>,
#> #   age_days <int>, msf_involvement <fct>,
#> #   nutrition_status_at_admission <fct>, fever <fct>, sex <fct>,
#> #   patient_origin <chr>, pregnancy_outcome_at_exit <fct>,
#> #   prescribed_vitamin_a <fct>, date_of_exit <date>,
#> #   date_of_consultation_admission <date>, event_file_type <fct>,
#> #   residential_status_brief <fct>, other_eye_complications <fct>,
#> #   treatment_facility_site <int>, prescribed_antibiotics <fct>,
#> #   treatment_location <chr>, date_of_onset <date>, exit_status <fct>,
#> #   treatment_facility_name <lgl>, severe_oral_lesions <fct>,
#> #   candidiasis <fct>, time_to_death <fct>,
#> #   malaria_rdt_at_admission <fct>, patient_facility_type <fct>,
#> #   previous_vaccine_doses_received <fct>, age_years <int>,
#> #   arrival_date_in_area_if_3m <date>, severity_of_illness <fct>,
#> #   age_months <int>, date_of_last_vaccination <date>,
#> #   baby_born_with_complications <fct>, case_number <chr>,
#> #   xerophthalmia <fct>, cough <fct>, contact_history <fct>,
#> #   detected_by <fct>, delivery_event <fct>, encephalitis <fct>,
#> #   nasal_discharge <fct>, acute_otitis_media <fct>, pregnant <fct>,
#> #   foetus_alive_at_admission <fct>, maculopapular_rash <fct>,
#> #   pneumonia <fct>, late_complications <fct>
gen_data("Vaccination", varnames = "column_name", numcases = 100, org = "MSF")
#> # A tibble: 100 x 41
#>    q77_what_is_the… health_district village q14_hh_no q15_home
#>               <dbl> <chr>           <chr>       <int> <fct>   
#>  1                3 District B      Villag…         5 No      
#>  2                1 District A      Villag…         4 Yes     
#>  3                2 District A      Villag…         6 Yes     
#>  4                3 District B      Villag…         4 No      
#>  5                3 District B      Villag…         3 Yes     
#>  6                2 District A      Villag…         2 No      
#>  7                2 District A      Villag…         4 Yes     
#>  8                1 District A      Villag…         3 Yes     
#>  9                4 District B      Villag…         3 Yes     
#> 10                4 District B      Villag…         5 No      
#> # … with 90 more rows, and 36 more variables: q16_occupant_age <lgl>,
#> #   q58_consent <fct>, q75_caretaker <fct>, q76_caretaker_other <lgl>,
#> #   q65_consent_no_reason <fct>, q66_consent_no_reason_other <lgl>,
#> #   q5_sex <fct>, q10_age_yr <int>, q55_age_mth <int>,
#> #   q2_vaccine_9months <fct>, q20_routine_vaccine_age_yr <lgl>,
#> #   q56_routine_vaccine_age_mth <lgl>, q21_routine_location <fct>,
#> #   q72_routine_location_other <lgl>, q7_no_routine_vacc_r <fct>,
#> #   q14_no_routine_vacc_other_r <lgl>, q17_vaccine_mass <fct>,
#> #   q28_no_campaign_vacc_r <fct>, q29_no_campaign_vacc_other_r <lgl>,
#> #   q18_campaign_vacc_age_yr <lgl>, q57_campaign_vacc_age_mth <lgl>,
#> #   q25_campaign_vacc_location <fct>, q69_campaign_vacc_loc_oth <lgl>,
#> #   q32_vaccine_sia <fct>, q41_vaccine_sia_age_yr <lgl>,
#> #   q58_vaccine_sia_age_mth <lgl>, q42_vaccine_sia_location <fct>,
#> #   q70_vac_sia_loc_oth <lgl>, q38_no_sia_vacc_reason <fct>,
#> #   q39_no_sia_vacc_other_r <lgl>, q47_disease_diagnosis <fct>,
#> #   q48_diagnosis_age_yr <lgl>, q71_diagnosis_age_mth <lgl>,
#> #   eligible <int>, interviewed <dbl>, fact_0_id <int>
```

## Cleaning data with the dictionaries

You can use the dictionaries to clean the data via the
[{matchmaker}](https://repidemicsconsortium.org/matchmaker) package
(currently on GitHub):

``` r
# remotes::install_github("reconhub/matchmaker@*release")
library("matchmaker")
library("dplyr")

dat <- gen_data(dictionary = "Cholera", 
  varnames = "data_element_shortname",
  numcases = 20,
  org = "MSF"
)
print(dat)
#> # A tibble: 20 x 45
#>    trimester exit_status treatment_facil… dehydration_lev…
#>    <fct>     <fct>       <lgl>            <fct>           
#>  1 <NA>      DH          NA               SE              
#>  2 <NA>      TR          NA               SE              
#>  3 <NA>      DH          NA               NO              
#>  4 <NA>      DD          NA               UN              
#>  5 <NA>      TR          NA               NO              
#>  6 <NA>      TR          NA               NO              
#>  7 <NA>      DOA         NA               NO              
#>  8 <NA>      AD          NA               SO              
#>  9 <NA>      AD          NA               NO              
#> 10 <NA>      LA          NA               SO              
#> 11 <NA>      TR          NA               NO              
#> 12 <NA>      AD          NA               UN              
#> 13 <NA>      DD          NA               SO              
#> 14 <NA>      DOA         NA               UN              
#> 15 <NA>      LA          NA               UN              
#> 16 <NA>      DD          NA               SO              
#> 17 <NA>      DD          NA               SE              
#> 18 <NA>      DD          NA               UN              
#> 19 <NA>      AD          NA               SE              
#> 20 1         LA          NA               SO              
#> # … with 41 more variables: comments_on_lab_results <lgl>,
#> #   fluids_treatment_plan <fct>, time_to_death <fct>,
#> #   malaria_rdt_at_admission <fct>, previously_vaccinated <fct>,
#> #   cholera_pcr_result <fct>, iv_fluids_received_litres <int>,
#> #   patient_origin_free_text <chr>,
#> #   previous_vaccine_doses_received <fct>, age_years <int>,
#> #   arrival_date_in_area_if_3m <date>, age_days <int>,
#> #   msf_involvement <fct>, date_lab_sample_taken <date>,
#> #   readmission <fct>, age_months <int>, date_of_last_vaccination <date>,
#> #   case_number <chr>, sex <fct>, patient_origin <chr>,
#> #   prescribed_zinc_supplement <fct>, delivery_event <fct>,
#> #   pregnancy_outcome_at_exit <fct>, date_of_exit <date>,
#> #   date_of_consultation_admission <date>, oedema <fct>,
#> #   event_file_type <fct>, residential_status_brief <fct>,
#> #   pregnant <fct>, cholera_rdt_result <fct>,
#> #   dehydration_severity_during_stay <fct>, cholera_culture_result <fct>,
#> #   foetus_alive_at_admission <fct>, treatment_facility_site <int>,
#> #   prescribed_antibiotics <fct>, cholera_referred_to <fct>,
#> #   ors_consumed_litres <int>, treatment_location <chr>,
#> #   cholera_referred_from <fct>, cholera_treatment_facility_type <fct>,
#> #   date_of_onset <date>

# We want the expanded dictionary, so we will select `compact = FALSE`
dict <- msf_dict(disease = "Cholera", 
  long = TRUE, 
  compact = FALSE, 
  tibble = TRUE
)
print(dict)
#> # A tibble: 182 x 11
#>    data_element_uid data_element_na… data_element_sh… data_element_de…
#>    <chr>            <chr>            <chr>            <chr>           
#>  1 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr…
#>  2 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr…
#>  3 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr…
#>  4 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  5 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  6 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  7 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  8 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  9 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#> 10 wjCDTwXmtix      egen_064_treatm… treatment_facil… Name of facilit…
#> # … with 172 more rows, and 7 more variables:
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, option_code <chr>, option_name <chr>,
#> #   option_uid <chr>, option_order_in_set <dbl>

# We can use linelist's clean_variable_spelling to translate the codes. First,
# we want to reorder the columns of the dictionary like so:
#
#  - 1st column: option codes
#  - 2nd column: translations
#  - 3rd column: data column name
#  - 4th column: order of options

# Now we can use linelist to filter the data:
dat_clean <- matchmaker::match_df(dat, dict, 
  from  = "option_code",
  to    = "option_name",
  by    = "data_element_shortname",
  order = "option_order_in_set"
)
print(dat_clean)
#> # A tibble: 20 x 45
#>    trimester exit_status treatment_facil… dehydration_lev…
#>    <fct>     <fct>       <lgl>            <fct>           
#>  1 <NA>      Discharged… NA               Severe          
#>  2 <NA>      Transferre… NA               Severe          
#>  3 <NA>      Discharged… NA               None            
#>  4 <NA>      Dead in fa… NA               Unknown         
#>  5 <NA>      Transferre… NA               None            
#>  6 <NA>      Transferre… NA               None            
#>  7 <NA>      Dead on ar… NA               None            
#>  8 <NA>      Transferre… NA               Some            
#>  9 <NA>      Transferre… NA               None            
#> 10 <NA>      Left again… NA               Some            
#> 11 <NA>      Transferre… NA               None            
#> 12 <NA>      Transferre… NA               Unknown         
#> 13 <NA>      Dead in fa… NA               Some            
#> 14 <NA>      Dead on ar… NA               Unknown         
#> 15 <NA>      Left again… NA               Unknown         
#> 16 <NA>      Dead in fa… NA               Some            
#> 17 <NA>      Dead in fa… NA               Severe          
#> 18 <NA>      Dead in fa… NA               Unknown         
#> 19 <NA>      Transferre… NA               Severe          
#> 20 1st trim… Left again… NA               Some            
#> # … with 41 more variables: comments_on_lab_results <lgl>,
#> #   fluids_treatment_plan <fct>, time_to_death <fct>,
#> #   malaria_rdt_at_admission <fct>, previously_vaccinated <fct>,
#> #   cholera_pcr_result <fct>, iv_fluids_received_litres <int>,
#> #   patient_origin_free_text <chr>,
#> #   previous_vaccine_doses_received <fct>, age_years <int>,
#> #   arrival_date_in_area_if_3m <date>, age_days <int>,
#> #   msf_involvement <fct>, date_lab_sample_taken <date>,
#> #   readmission <fct>, age_months <int>, date_of_last_vaccination <date>,
#> #   case_number <chr>, sex <fct>, patient_origin <chr>,
#> #   prescribed_zinc_supplement <fct>, delivery_event <fct>,
#> #   pregnancy_outcome_at_exit <fct>, date_of_exit <date>,
#> #   date_of_consultation_admission <date>, oedema <fct>,
#> #   event_file_type <fct>, residential_status_brief <fct>,
#> #   pregnant <fct>, cholera_rdt_result <fct>,
#> #   dehydration_severity_during_stay <fct>, cholera_culture_result <fct>,
#> #   foetus_alive_at_admission <fct>, treatment_facility_site <chr>,
#> #   prescribed_antibiotics <fct>, cholera_referred_to <fct>,
#> #   ors_consumed_litres <int>, treatment_location <chr>,
#> #   cholera_referred_from <fct>, cholera_treatment_facility_type <fct>,
#> #   date_of_onset <date>
```

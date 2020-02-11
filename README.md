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
the MSF R4EPIs project. Learn more about R4EPIs at
<https://r4epis.netlify.com>

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

<summary style='text-decoration: underline'>Click here for alternative
installation options</summary> If there is a bugfix or feature that is
not yet on CRAN, you can install it via the {drat} package:

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

  - Cholera/Acute watery diarrhea (“cholera”)
  - Meningitis
  - Measles/Rubella (“measles”)
  - Acute Jaundice Syndrome (often suspected to be Hepatitis E) (“ajs”)

> You can read more about the outbreak dictionaries at
> <https://r4epis.netlify.com/outbreaks>

The dictionary can be obtained via the `msf_dict()` function, which
specifies a dictionary that describes recorded variables
(`data_element_shortname`) in rows and their possible options (if
categorical):

``` r
library("epidict")
msf_dict("Measles")
#> # A tibble: 52 x 8
#>    data_element_uid data_element_na… data_element_sh… data_element_de…
#>    <chr>            <chr>            <chr>            <chr>           
#>  1 DE_ESYM_012      esym_012_seizur… seizure_episodes Complication (S…
#>  2 DE_EGEN_013      egen_013_pregna… trimester        If pregnant, tr…
#>  3 DE_ESYM_014      esym_014_croup   croup            Complication (C…
#>  4 DE_ESYM_002      esym_002_dehydr… dehydration_lev… Dehydration bas…
#>  5 DE_EGEN_030      egen_030_reside… residential_sta… Whether the pat…
#>  6 DE_EGEN_020      egen_020_previo… previously_vacc… Has the patient…
#>  7 DE_EGEN_062      egen_062_patien… patient_origin_… Name of village…
#>  8 DE_EGEN_010      egen_010_age_da… age_days         Age of patient …
#>  9 DE_EGEN_029      egen_029_msf_in… msf_involvement  How extensive i…
#> 10 DE_EGEN_053      egen_053_nutrit… nutrition_statu… What is the nut…
#> # … with 42 more rows, and 4 more variables:
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, options <list>
msf_dict("AJS")
#> # A tibble: 68 x 8
#>    data_element_uid data_element_na… data_element_sh… data_element_de…
#>    <lgl>            <chr>            <chr>            <chr>           
#>  1 NA               egen_044_event_… event_file_type  Is the event fi…
#>  2 NA               egen_001_patien… case_number      Anonymised pati…
#>  3 NA               egen_004_date_o… date_of_consult… Date patient pr…
#>  4 NA               egen_022_detect… detected_by      How patient was…
#>  5 NA               egen_005_patien… patient_facilit… Patient is pres…
#>  6 NA               egen_029_msf_in… msf_involvement  How extensive i…
#>  7 NA               egen_008_age_ye… age_years        Age of patient …
#>  8 NA               egen_009_age_mo… age_months       Age of patient …
#>  9 NA               egen_010_age_da… age_days         Age of patient …
#> 10 NA               egen_011_sex     sex              Sex of patient …
#> # … with 58 more rows, and 4 more variables:
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, options <list>
msf_dict("Cholera")
#> # A tibble: 45 x 8
#>    data_element_uid data_element_na… data_element_sh… data_element_de…
#>    <chr>            <chr>            <chr>            <chr>           
#>  1 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr…
#>  2 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of…
#>  3 wjCDTwXmtix      egen_064_treatm… treatment_facil… Name of facilit…
#>  4 UUVnMdaBY5T      esym_002_dehydr… dehydration_lev… Dehydration bas…
#>  5 BTZdJKpS3S5      egen_059_commen… comments_on_lab… Any additional …
#>  6 bpT8T341oQG      egen_054_fluids… fluids_treatmen… What was the fl…
#>  7 FqPqIr5m0AQ      egen_017_time_b… time_to_death    Hours between p…
#>  8 epbKb1GczaS      esym_003_malari… malaria_rdt_at_… Malaria rapid d…
#>  9 F04TM58HHsd      egen_020_previo… previously_vacc… Has the patient…
#> 10 CfRNuWWuTr5      egen_058_choler… cholera_pcr_res… Was a PCR test …
#> # … with 35 more rows, and 4 more variables:
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, options <list>
msf_dict("Meningitis")
#> # A tibble: 53 x 8
#>    data_element_uid data_element_na… data_element_sh… data_element_de…
#>    <chr>            <chr>            <chr>            <chr>           
#>  1 Ow8ss6T1tT5      esym_028_seizur… seizures_at_adm… Presenting symp…
#>  2 CEEr9lcwKVG      esym_036_kernig… kernigs_brudzin… Presenting symp…
#>  3 tIe59Htd2Ba      esym_012_seizur… seizure_episodes Complication (S…
#>  4 Sjms36Aj6bT      esym_023_febril… febrile_coma     Complication (F…
#>  5 BTZdJKpS3S5      egen_059_commen… comments_on_lab… Any additional …
#>  6 wHnNEMRrS5A      esym_025_chills… chills           Presenting symp…
#>  7 T3Gn8mTYu0c      esym_026_stiff_… stiff_neck       Presenting symp…
#>  8 JCexRYsmjmS      eobr_006_ti_sam… ti_result_organ… TI sample resul…
#>  9 myL5BYzy6zW      esym_034_coma_a… coma             Presenting symp…
#> 10 AhllpMovCeu      egen_062_patien… patient_origin_… Name of village…
#> # … with 43 more rows, and 4 more variables:
#> #   data_element_valuetype <chr>, data_element_formname <chr>,
#> #   used_optionset_uid <chr>, options <list>
```

In addition, there are three MSF survey dictionaries available:

  - Retrospective mortality and access to care (“mortality”)
  - Malnutrition (“nutrition”)
  - Vaccination Coverage (“vaccination”)

> You can read more about the survey dictionaries at
> <https://r4epis.netlify.com/surveys>

These are accessible via `msf_dict_survey()` where the variables are in
`column_name` and are often labeled by question number.

``` r
msf_dict_survey("Mortality")
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
msf_dict_survey("Nutrition")
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
msf_dict_survey("Vaccination")
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
#>  1 0                <NA>      1     UN               4               
#>  2 1                1         1     UN               2               
#>  3 1                <NA>      0     SE               2               
#>  4 1                <NA>      0     UN               4               
#>  5 1                <NA>      0     UN               2               
#>  6 1                <NA>      0     SE               2               
#>  7 0                <NA>      0     SE               2               
#>  8 1                <NA>      1     SO               5               
#>  9 1                <NA>      1     NO               4               
#> 10 1                2         0     NO               5               
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
#>  1                1 District A      Villag…         1 No      
#>  2                3 District B      Villag…         3 Yes     
#>  3                3 District B      Villag…         1 Yes     
#>  4                4 District B      Villag…         3 Yes     
#>  5                1 District A      Villag…         4 Yes     
#>  6                2 District A      Villag…         3 No      
#>  7                4 District B      Villag…         3 Yes     
#>  8                1 District A      Villag…         1 Yes     
#>  9                4 District B      Villag…         1 No      
#> 10                1 District A      Villag…         2 No      
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
[{matchmaker}](https://www.repidemicsconsortium.org/matchmaker) package:

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
#>    trimester exit_status treatment_facil… dehydration_lev…
#>    <fct>     <fct>       <lgl>            <fct>           
#>  1 <NA>      TR          NA               NO              
#>  2 3         DD          NA               NO              
#>  3 <NA>      DH          NA               UN              
#>  4 <NA>      LA          NA               UN              
#>  5 1         DD          NA               SO              
#>  6 <NA>      LA          NA               SO              
#>  7 <NA>      DD          NA               UN              
#>  8 <NA>      LA          NA               NO              
#>  9 <NA>      LA          NA               SE              
#> 10 3         DH          NA               UN              
#> 11 <NA>      DD          NA               UN              
#> 12 <NA>      AD          NA               SO              
#> 13 <NA>      DD          NA               SO              
#> 14 <NA>      DOA         NA               NO              
#> 15 <NA>      LA          NA               SO              
#> 16 <NA>      DOA         NA               UN              
#> 17 <NA>      DOA         NA               NO              
#> 18 <NA>      TR          NA               UN              
#> 19 <NA>      DOA         NA               NO              
#> 20 <NA>      DD          NA               UN              
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
  long    = TRUE,
  compact = FALSE,
  tibble  = TRUE
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

# Now we can use matchmaker to filter the data
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
#>  1 <NA>      Transferre… NA               None            
#>  2 3rd trim… Dead in fa… NA               None            
#>  3 <NA>      Discharged… NA               Unknown         
#>  4 <NA>      Left again… NA               Unknown         
#>  5 1st trim… Dead in fa… NA               Some            
#>  6 <NA>      Left again… NA               Some            
#>  7 <NA>      Dead in fa… NA               Unknown         
#>  8 <NA>      Left again… NA               None            
#>  9 <NA>      Left again… NA               Severe          
#> 10 3rd trim… Discharged… NA               Unknown         
#> 11 <NA>      Dead in fa… NA               Unknown         
#> 12 <NA>      Transferre… NA               Some            
#> 13 <NA>      Dead in fa… NA               Some            
#> 14 <NA>      Dead on ar… NA               None            
#> 15 <NA>      Left again… NA               Some            
#> 16 <NA>      Dead on ar… NA               Unknown         
#> 17 <NA>      Dead on ar… NA               None            
#> 18 <NA>      Transferre… NA               Unknown         
#> 19 <NA>      Dead on ar… NA               None            
#> 20 <NA>      Dead in fa… NA               Unknown         
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

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
#>    data_element_uid data_element_na… data_element_sh… data_element_de… data_element_va…
#>    <chr>            <chr>            <chr>            <chr>            <chr>           
#>  1 DE_ESYM_012      esym_012_seizur… seizure_episodes Complication (S… BOOLEAN         
#>  2 DE_EGEN_013      egen_013_pregna… trimester        If pregnant, tr… TEXT            
#>  3 DE_ESYM_014      esym_014_croup   croup            Complication (C… BOOLEAN         
#>  4 DE_ESYM_002      esym_002_dehydr… dehydration_lev… Dehydration bas… TEXT            
#>  5 DE_EGEN_030      egen_030_reside… residential_sta… Whether the pat… TEXT            
#>  6 DE_EGEN_020      egen_020_previo… previously_vacc… Has the patient… TEXT            
#>  7 DE_EGEN_062      egen_062_patien… patient_origin_… Name of village… TEXT            
#>  8 DE_EGEN_010      egen_010_age_da… age_days         Age of patient … INTEGER_POSITIVE
#>  9 DE_EGEN_029      egen_029_msf_in… msf_involvement  How extensive i… TEXT            
#> 10 DE_EGEN_053      egen_053_nutrit… nutrition_statu… What is the nut… TEXT            
#> # … with 42 more rows, and 3 more variables: data_element_formname <chr>, used_optionset_uid <chr>,
#> #   options <list>
msf_dict("AJS")
#> # A tibble: 68 x 8
#>    data_element_uid data_element_na… data_element_sh… data_element_de… data_element_va…
#>    <lgl>            <chr>            <chr>            <chr>            <chr>           
#>  1 NA               egen_044_event_… event_file_type  Is the event fi… TEXT            
#>  2 NA               egen_001_patien… case_number      Anonymised pati… TEXT            
#>  3 NA               egen_004_date_o… date_of_consult… Date patient pr… DATE            
#>  4 NA               egen_022_detect… detected_by      How patient was… TEXT            
#>  5 NA               egen_005_patien… patient_facilit… Patient is pres… TEXT            
#>  6 NA               egen_029_msf_in… msf_involvement  How extensive i… TEXT            
#>  7 NA               egen_008_age_ye… age_years        Age of patient … INTEGER_POSITIVE
#>  8 NA               egen_009_age_mo… age_months       Age of patient … INTEGER_POSITIVE
#>  9 NA               egen_010_age_da… age_days         Age of patient … INTEGER_POSITIVE
#> 10 NA               egen_011_sex     sex              Sex of patient … TEXT            
#> # … with 58 more rows, and 3 more variables: data_element_formname <chr>, used_optionset_uid <chr>,
#> #   options <list>
msf_dict("Cholera")
#> # A tibble: 45 x 8
#>    data_element_uid data_element_na… data_element_sh… data_element_de… data_element_va…
#>    <chr>            <chr>            <chr>            <chr>            <chr>           
#>  1 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr… TEXT            
#>  2 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of… TEXT            
#>  3 wjCDTwXmtix      egen_064_treatm… treatment_facil… Name of facilit… TEXT            
#>  4 UUVnMdaBY5T      esym_002_dehydr… dehydration_lev… Dehydration bas… TEXT            
#>  5 BTZdJKpS3S5      egen_059_commen… comments_on_lab… Any additional … LONG_TEXT       
#>  6 bpT8T341oQG      egen_054_fluids… fluids_treatmen… What was the fl… TEXT            
#>  7 FqPqIr5m0AQ      egen_017_time_b… time_to_death    Hours between p… TEXT            
#>  8 epbKb1GczaS      esym_003_malari… malaria_rdt_at_… Malaria rapid d… TEXT            
#>  9 F04TM58HHsd      egen_020_previo… previously_vacc… Has the patient… TEXT            
#> 10 CfRNuWWuTr5      egen_058_choler… cholera_pcr_res… Was a PCR test … TEXT            
#> # … with 35 more rows, and 3 more variables: data_element_formname <chr>, used_optionset_uid <chr>,
#> #   options <list>
msf_dict("Meningitis")
#> # A tibble: 53 x 8
#>    data_element_uid data_element_na… data_element_sh… data_element_de… data_element_va…
#>    <chr>            <chr>            <chr>            <chr>            <chr>           
#>  1 Ow8ss6T1tT5      esym_028_seizur… seizures_at_adm… Presenting symp… BOOLEAN         
#>  2 CEEr9lcwKVG      esym_036_kernig… kernigs_brudzin… Presenting symp… BOOLEAN         
#>  3 tIe59Htd2Ba      esym_012_seizur… seizure_episodes Complication (S… BOOLEAN         
#>  4 Sjms36Aj6bT      esym_023_febril… febrile_coma     Complication (F… BOOLEAN         
#>  5 BTZdJKpS3S5      egen_059_commen… comments_on_lab… Any additional … LONG_TEXT       
#>  6 wHnNEMRrS5A      esym_025_chills… chills           Presenting symp… BOOLEAN         
#>  7 T3Gn8mTYu0c      esym_026_stiff_… stiff_neck       Presenting symp… BOOLEAN         
#>  8 JCexRYsmjmS      eobr_006_ti_sam… ti_result_organ… TI sample resul… TEXT            
#>  9 myL5BYzy6zW      esym_034_coma_a… coma             Presenting symp… BOOLEAN         
#> 10 AhllpMovCeu      egen_062_patien… patient_origin_… Name of village… TEXT            
#> # … with 43 more rows, and 3 more variables: data_element_formname <chr>, used_optionset_uid <chr>,
#> #   options <list>
```

In addition, there are three MSF survey dictionaries available:

  - Retrospective mortality and access to care (“mortality”)
  - Malnutrition (“nutrition”)
  - Vaccination Coverage (“vaccination”)

> You can read more about the survey dictionaries at
> <https://r4epis.netlify.com/surveys>

These are accessible via `msf_dict_survey()` where the variables are in
`name`.

``` r
msf_dict_survey("Mortality")
#> # A tibble: 46 x 14
#>    type  name  label_english label_french hint_english hint_french default relevant appearance
#>    <chr> <chr> <chr>         <chr>        <chr>        <chr>       <chr>   <chr>    <chr>     
#>  1 start start Start Time    <NA>         <NA>         <NA>        <NA>    <NA>     <NA>      
#>  2 end   end   End Time      <NA>         <NA>         <NA>        <NA>    <NA>     <NA>      
#>  3 today today Date of Surv… <NA>         <NA>         <NA>        <NA>    <NA>     <NA>      
#>  4 devi… devi… Phone Serial… <NA>         <NA>         <NA>        <NA>    <NA>     <NA>      
#>  5 date  date  Date          Date         <NA>         <NA>        .today… <NA>     <NA>      
#>  6 inte… team… Team number   Numéro d'éq… <NA>         <NA>        <NA>    <NA>     numbers   
#>  7 vill… vill… Village name  Nom du vill… <NA>         <NA>        <NA>    <NA>     <NA>      
#>  8 text  vill… Specify other Autre, spéc… <NA>         <NA>        <NA>    ${villa… <NA>      
#>  9 inte… clus… Cluster numb… Numéro de l… <NA>         <NA>        <NA>    <NA>     numbers   
#> 10 inte… hous… Household nu… Numéro du m… <NA>         <NA>        <NA>    <NA>     numbers   
#> # … with 36 more rows, and 5 more variables: constraint <chr>, repeat_count <chr>,
#> #   calculation <chr>, value_type <chr>, options <list>
# msf_dict_survey("Nutrition")
msf_dict_survey("Vaccination")
#> # A tibble: 41 x 14
#>    type  name  label_english label_french hint_english hint_french default relevant appearance
#>    <chr> <chr> <chr>         <chr>        <chr>        <chr>       <chr>   <chr>    <chr>     
#>  1 start start Start Time    Start Time   <NA>         <NA>        <NA>    <NA>     <NA>      
#>  2 end   end   End Time      End Time     <NA>         <NA>        <NA>    <NA>     <NA>      
#>  3 today today Date of Surv… Date of Sur… <NA>         <NA>        <NA>    <NA>     <NA>      
#>  4 devi… devi… Phone Serial… Phone Seria… <NA>         <NA>        <NA>    <NA>     <NA>      
#>  5 date  date  Date          Date         <NA>         <NA>        .today… <NA>     <NA>      
#>  6 inte… team… Team number   Numéro de l… <NA>         <NA>        <NA>    <NA>     <NA>      
#>  7 vill… vill… Village name  Nom du vill… <NA>         <NA>        <NA>    <NA>     <NA>      
#>  8 text  vill… Specify other Veuillez sp… <NA>         <NA>        <NA>    ${villa… <NA>      
#>  9 inte… clus… Cluster numb… Numéro de l… <NA>         <NA>        <NA>    <NA>     numbers   
#> 10 inte… hous… Household nu… Numéro du m… <NA>         <NA>        <NA>    <NA>     <NA>      
#> # … with 31 more rows, and 5 more variables: repeat_count <chr>, constraint <chr>,
#> #   calculation <chr>, value_type <chr>, options <list>
```

## Generating data

The {epidict} package has a function for generating data that’s called
`gen_data()`, which takes three arguments: The dictionary, which column
describes the variable names, and how many rows are needed in the
output.

``` r
gen_data("Measles", varnames = "data_element_shortname", numcases = 100, org = "MSF")
#> # A tibble: 100 x 52
#>    seizure_episodes trimester croup dehydration_lev… residential_sta… previously_vacc…
#>    <fct>            <fct>     <fct> <fct>            <fct>            <fct>           
#>  1 0                <NA>      1     SE               1                V               
#>  2 1                <NA>      0     SO               1                V               
#>  3 0                <NA>      0     NO               2                C               
#>  4 1                1         1     NO               3                U               
#>  5 0                <NA>      1     SO               5                U               
#>  6 1                <NA>      0     NO               4                V               
#>  7 0                <NA>      1     SO               2                U               
#>  8 0                <NA>      0     SE               3                C               
#>  9 0                <NA>      0     NO               5                V               
#> 10 1                <NA>      0     NO               1                N               
#> # … with 90 more rows, and 46 more variables: patient_origin_free_text <chr>, age_days <int>,
#> #   msf_involvement <fct>, nutrition_status_at_admission <fct>, fever <fct>, sex <fct>,
#> #   patient_origin <chr>, pregnancy_outcome_at_exit <fct>, prescribed_vitamin_a <fct>,
#> #   date_of_exit <date>, date_of_consultation_admission <date>, event_file_type <fct>,
#> #   residential_status_brief <fct>, other_eye_complications <fct>, treatment_facility_site <int>,
#> #   prescribed_antibiotics <fct>, treatment_location <chr>, date_of_onset <date>,
#> #   exit_status <fct>, treatment_facility_name <lgl>, severe_oral_lesions <fct>, candidiasis <fct>,
#> #   time_to_death <fct>, malaria_rdt_at_admission <fct>, patient_facility_type <fct>,
#> #   previous_vaccine_doses_received <fct>, age_years <int>, arrival_date_in_area_if_3m <date>,
#> #   severity_of_illness <fct>, age_months <int>, date_of_last_vaccination <date>,
#> #   baby_born_with_complications <fct>, case_number <chr>, xerophthalmia <fct>, cough <fct>,
#> #   contact_history <fct>, detected_by <fct>, delivery_event <fct>, encephalitis <fct>,
#> #   nasal_discharge <fct>, acute_otitis_media <fct>, pregnant <fct>,
#> #   foetus_alive_at_admission <fct>, maculopapular_rash <fct>, pneumonia <fct>,
#> #   late_complications <fct>
gen_data("Vaccination", varnames = "name", numcases = 100, org = "MSF")
#> # A tibble: 100 x 44
#>    start end   today deviceid date       team_number village_name village_other cluster_number
#>    <lgl> <lgl> <lgl> <lgl>    <date>     <lgl>       <fct>        <lgl>                  <dbl>
#>  1 NA    NA    NA    NA       2018-01-28 NA          village_8    NA                         8
#>  2 NA    NA    NA    NA       2018-02-07 NA          village_6    NA                         6
#>  3 NA    NA    NA    NA       2018-04-30 NA          village_8    NA                         8
#>  4 NA    NA    NA    NA       2018-01-07 NA          village_1    NA                         1
#>  5 NA    NA    NA    NA       2018-04-16 NA          village_6    NA                         6
#>  6 NA    NA    NA    NA       2018-04-18 NA          village_4    NA                         4
#>  7 NA    NA    NA    NA       2018-01-29 NA          village_5    NA                         5
#>  8 NA    NA    NA    NA       2018-04-01 NA          village_7    NA                         7
#>  9 NA    NA    NA    NA       2018-01-24 NA          village_5    NA                         5
#> 10 NA    NA    NA    NA       2018-02-21 NA          village_7    NA                         7
#> # … with 90 more rows, and 35 more variables: household_number <int>, households_building <lgl>,
#> #   random_hh <lgl>, random_hh_note <lgl>, consent <fct>, caretaker <fct>, other_caretaker <lgl>,
#> #   age_caretaker <lgl>, no_consent_reason <fct>, no_consent_other <lgl>, children_count <dbl>,
#> #   child_number <lgl>, sex <fct>, age_years <int>, age_months <int>, routine_vacc <fct>,
#> #   age_routine_vacc <int>, place_routine_vacc <fct>, reason_route_vacc <fct>,
#> #   reason_route_other <lgl>, msf_vacc <fct>, age_msf_vacc <int>, place_msf_vacc <fct>,
#> #   reason_msf_vacc <fct>, reason_msf_other <lgl>, sia_vacc <fct>, age_sia_vacc <int>,
#> #   place_sia_vacc <lgl>, reason_sia_vacc <fct>, reason_sia_other <lgl>, diagnosis_disease <fct>,
#> #   age_diagnosis <int>, index <int>, index_y <int>, uid <chr>
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
#>    trimester exit_status treatment_facil… dehydration_lev… comments_on_lab… fluids_treatmen…
#>    <fct>     <fct>       <lgl>            <fct>            <lgl>            <fct>           
#>  1 <NA>      TR          NA               NO               NA               B               
#>  2 <NA>      DOA         NA               UN               NA               C               
#>  3 <NA>      DOA         NA               SE               NA               U               
#>  4 <NA>      DOA         NA               SE               NA               C               
#>  5 <NA>      DH          NA               SO               NA               B               
#>  6 <NA>      DOA         NA               NO               NA               U               
#>  7 <NA>      DD          NA               UN               NA               A               
#>  8 <NA>      AD          NA               NO               NA               A               
#>  9 <NA>      LA          NA               UN               NA               C               
#> 10 <NA>      DD          NA               NO               NA               U               
#> 11 <NA>      DOA         NA               SO               NA               U               
#> 12 <NA>      TR          NA               UN               NA               N               
#> 13 <NA>      DOA         NA               SO               NA               U               
#> 14 2         TR          NA               UN               NA               B               
#> 15 <NA>      TR          NA               SE               NA               U               
#> 16 <NA>      DH          NA               UN               NA               C               
#> 17 <NA>      DOA         NA               SO               NA               C               
#> 18 <NA>      DH          NA               SO               NA               A               
#> 19 <NA>      LA          NA               UN               NA               C               
#> 20 <NA>      TR          NA               SE               NA               U               
#> # … with 39 more variables: time_to_death <fct>, malaria_rdt_at_admission <fct>,
#> #   previously_vaccinated <fct>, cholera_pcr_result <fct>, iv_fluids_received_litres <int>,
#> #   patient_origin_free_text <chr>, previous_vaccine_doses_received <fct>, age_years <int>,
#> #   arrival_date_in_area_if_3m <date>, age_days <int>, msf_involvement <fct>,
#> #   date_lab_sample_taken <date>, readmission <fct>, age_months <int>,
#> #   date_of_last_vaccination <date>, case_number <chr>, sex <fct>, patient_origin <chr>,
#> #   prescribed_zinc_supplement <fct>, delivery_event <fct>, pregnancy_outcome_at_exit <fct>,
#> #   date_of_exit <date>, date_of_consultation_admission <date>, oedema <fct>,
#> #   event_file_type <fct>, residential_status_brief <fct>, pregnant <fct>,
#> #   cholera_rdt_result <fct>, dehydration_severity_during_stay <fct>, cholera_culture_result <fct>,
#> #   foetus_alive_at_admission <fct>, treatment_facility_site <int>, prescribed_antibiotics <fct>,
#> #   cholera_referred_to <fct>, ors_consumed_litres <int>, treatment_location <chr>,
#> #   cholera_referred_from <fct>, cholera_treatment_facility_type <fct>, date_of_onset <date>

# We want the expanded dictionary, so we will select `compact = FALSE`
dict <- msf_dict(disease = "Cholera", 
  long    = TRUE,
  compact = FALSE,
  tibble  = TRUE
)
print(dict)
#> # A tibble: 182 x 11
#>    data_element_uid data_element_na… data_element_sh… data_element_de… data_element_va…
#>    <chr>            <chr>            <chr>            <chr>            <chr>           
#>  1 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr… TEXT            
#>  2 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr… TEXT            
#>  3 FF7d81Zy0yQ      egen_013_pregna… trimester        If pregnant, tr… TEXT            
#>  4 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of… TEXT            
#>  5 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of… TEXT            
#>  6 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of… TEXT            
#>  7 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of… TEXT            
#>  8 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of… TEXT            
#>  9 ADfNqpCL5kf      egen_015_exit_s… exit_status      Final status of… TEXT            
#> 10 wjCDTwXmtix      egen_064_treatm… treatment_facil… Name of facilit… TEXT            
#> # … with 172 more rows, and 6 more variables: data_element_formname <chr>,
#> #   used_optionset_uid <chr>, option_code <chr>, option_name <chr>, option_uid <chr>,
#> #   option_order_in_set <dbl>

# Now we can use matchmaker to filter the data
dat_clean <- matchmaker::match_df(dat, dict, 
  from  = "option_code",
  to    = "option_name",
  by    = "data_element_shortname",
  order = "option_order_in_set"
)
print(dat_clean)
#> # A tibble: 20 x 45
#>    trimester exit_status treatment_facil… dehydration_lev… comments_on_lab… fluids_treatmen…
#>    <fct>     <fct>       <lgl>            <fct>            <lgl>            <fct>           
#>  1 <NA>      Transferre… NA               None             NA               Treatment plan B
#>  2 <NA>      Dead on ar… NA               Unknown          NA               Treatment plan C
#>  3 <NA>      Dead on ar… NA               Severe           NA               Unknown         
#>  4 <NA>      Dead on ar… NA               Severe           NA               Treatment plan C
#>  5 <NA>      Discharged… NA               Some             NA               Treatment plan B
#>  6 <NA>      Dead on ar… NA               None             NA               Unknown         
#>  7 <NA>      Dead in fa… NA               Unknown          NA               Treatment plan A
#>  8 <NA>      Transferre… NA               None             NA               Treatment plan A
#>  9 <NA>      Left again… NA               Unknown          NA               Treatment plan C
#> 10 <NA>      Dead in fa… NA               None             NA               Unknown         
#> 11 <NA>      Dead on ar… NA               Some             NA               Unknown         
#> 12 <NA>      Transferre… NA               Unknown          NA               None            
#> 13 <NA>      Dead on ar… NA               Some             NA               Unknown         
#> 14 2nd trim… Transferre… NA               Unknown          NA               Treatment plan B
#> 15 <NA>      Transferre… NA               Severe           NA               Unknown         
#> 16 <NA>      Discharged… NA               Unknown          NA               Treatment plan C
#> 17 <NA>      Dead on ar… NA               Some             NA               Treatment plan C
#> 18 <NA>      Discharged… NA               Some             NA               Treatment plan A
#> 19 <NA>      Left again… NA               Unknown          NA               Treatment plan C
#> 20 <NA>      Transferre… NA               Severe           NA               Unknown         
#> # … with 39 more variables: time_to_death <fct>, malaria_rdt_at_admission <fct>,
#> #   previously_vaccinated <fct>, cholera_pcr_result <fct>, iv_fluids_received_litres <int>,
#> #   patient_origin_free_text <chr>, previous_vaccine_doses_received <fct>, age_years <int>,
#> #   arrival_date_in_area_if_3m <date>, age_days <int>, msf_involvement <fct>,
#> #   date_lab_sample_taken <date>, readmission <fct>, age_months <int>,
#> #   date_of_last_vaccination <date>, case_number <chr>, sex <fct>, patient_origin <chr>,
#> #   prescribed_zinc_supplement <fct>, delivery_event <fct>, pregnancy_outcome_at_exit <fct>,
#> #   date_of_exit <date>, date_of_consultation_admission <date>, oedema <fct>,
#> #   event_file_type <fct>, residential_status_brief <fct>, pregnant <fct>,
#> #   cholera_rdt_result <fct>, dehydration_severity_during_stay <fct>, cholera_culture_result <fct>,
#> #   foetus_alive_at_admission <fct>, treatment_facility_site <chr>, prescribed_antibiotics <fct>,
#> #   cholera_referred_to <fct>, ors_consumed_litres <int>, treatment_location <chr>,
#> #   cholera_referred_from <fct>, cholera_treatment_facility_type <fct>, date_of_onset <date>
```

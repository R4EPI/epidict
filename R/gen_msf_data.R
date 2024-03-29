#' @noRd
#'
#' @param dictionary Specify which dictionary you would like to use.
#'   Currently supports "Cholera", "Measles", "Meningitis", "AJS",
#'    "Mortality", "Nutrition", "Vaccination_long" and "Vaccination_short"
#'
#' @param varnames Specify name of column that contains variable names. Currently
#'   default set to "data_element_shortname". If `dictionary` is a survey,
#'   `varnames` needs to be "name".
#'
#' @param numcases For fake data, specify the number of cases you want (default is 300)
#'
#' @keywords internal
gen_msf_data <- function(dictionary, dat_dict, is_survey, varnames = "data_element_shortname", numcases = 300) {

  # Three datasets:
  # 1) dat_dict = msf data dictionary generated by (msf_dict)
  # 2) dat_output = formatting of data dictionary to make use for sampling
  # 3) dis_output = dataset generated by sampling from dictionary (exported)

  ## drop notes from survey kobo dictionaries (dont want them as variables)
  if(is_survey) {
    dat_dict <- dat_dict[dat_dict$type != "note", ]
  }

  ## drop extra columns (keep varnames and code options)
  dis_output <- template_data_frame_categories(dat_dict, numcases, varnames, survey = is_survey)

  # Use data dictionary to define which vars are dates
  if(is_survey) {
    datevars <- dat_dict[[varnames]][dat_dict$type == "date"]
  } else {
    datevars <- dat_dict[[varnames]][dat_dict$data_element_valuetype == "DATE"]
  }


  # sample between two dates
  posidates <- seq(as.Date("2018-01-01"), as.Date("2018-04-30"), by = "day")

  # fill the date columns with dates
  for (i in datevars) {
    dis_output[[i]] <- sample(posidates, numcases, replace = TRUE)
  }

  if (!is_survey) {

    # Make sure exit dates don't come before entrance dates
    dis_output <- fix_dates(dis_output)

    # Patient identifiers
    dis_output$case_number <- sprintf("A%d", seq(numcases))

    # treatment site facility
    dis_output$treatment_facility_site <- sample(1:50, numcases, replace = TRUE)

    # patient origin (categorical from a dropdown)
    dis_output$patient_origin <- gen_village(numcases)

    # treatment location (categorical from a dropdown)
    dis_output$treatment_location <- gen_ward(numcases)

    # patient origin free text
    dis_output$patient_origin_free_text <- gen_freetext(numcases)
  }

  # GENERATE AGES --------------------------------------------------------------

  # works for both outbreaks and surveys
  dis_output <- gen_ages(
    dis_output,
    numcases,
    set_age_na = !is_survey,
    year_cutoff = if (is_survey) 0 else 2
  )


  # DISEASE-SPECIFIC GENERATORS ------------------------------------------------
  if (dictionary == "Cholera" | dictionary == "Measles" | dictionary == "AJS") {
    # In this case, not female == not applicable
    dis_output$pregnant[dis_output$sex != "F"] <- "NA"

    # This includes all who are either not female or female and currently
    # pregnant
    NOT_CURRENTLY_PREGNANT <- dis_output$sex != "F" | dis_output$pregnant != "Y"

    dis_output$foetus_alive_at_admission[NOT_CURRENTLY_PREGNANT] <- NA
    dis_output$trimester[NOT_CURRENTLY_PREGNANT] <- NA
    # delivery event is a TRUE only category, meaning that it either is a 1 or
    # NA kind of thing.
    dis_output$delivery_event[NOT_CURRENTLY_PREGNANT] <- "NA"

    NO_DELIVERY <- dis_output$delivery_event != "1"

    dis_output$pregnancy_outcome_at_exit[NOT_CURRENTLY_PREGNANT] <- NA
    dis_output$pregnancy_outcome_at_exit[NO_DELIVERY] <- NA
  }


  if (dictionary == "Cholera") {
    dis_output$ors_consumed_litres <- sample(1:10, numcases, replace = TRUE)
    dis_output$iv_fluids_received_litres <- sample(1:10, numcases, replace = TRUE)
  }

  if (dictionary == "Measles") {
    dis_output$baby_born_with_complications[NO_DELIVERY] <- NA

    # fix vaccine stuff among non vaccinated
    NOTVACC <- which(!dis_output$previously_vaccinated %in% c("C", "V"))

    dis_output$previous_vaccine_doses_received[NOTVACC] <- NA
    dis_output$date_of_last_vaccination[NOTVACC] <- NA
  }

  if (dictionary == "Meningitis") {
    # T1 lab sample dates before admission
    # add 2 to admission....
    dis_output <- enforce_timing(dis_output,
      first  = "date_of_consultation_admission",
      second = "date_ti_sample_sent",
      2
    )

    # fix pregnancy delivery
    dis_output$delivery_event[dis_output$sex != "F"] <- "NA"

    # fix vaccine stuff among not vaccinated
    NOTVACC <- which(
      !dis_output$vaccinated_meningitis_routine %in% c("C", "V") &
        !dis_output$vaccinated_meningitis_mvc %in% c("C", "V")
    )

    dis_output$name_meningitis_vaccine[NOTVACC] <- NA
    dis_output$date_of_last_vaccination[NOTVACC] <- NA
  }

  if (dictionary == "Mortality") {

    # create household numbers within cluster numbers
    dis_output <- gen_hh_clusters(dis_output,
      cluster = "cluster_number",
      household = "household_number",
      eligible = "member_number",
      inc_building = TRUE,
      building = "households_building",
      select_household = "random_hh"
    )


    # create index numbers and unique IDs
    # index is the unique household (the parent_index for kobo outputs)
    # index_y is the unique individual within households (index for kobo outputs)
    # uid combines these to produce a unique identifier for each individual
    dis_output <- gen_survey_uid(dis_output)


    # number of people ill in household
    dis_output <- gen_ill_hh(dis_output)

    # fix consent
    dis_output <- gen_consent(dis_output)


    # select children under fifteen yrs
    dis_under_15 <- dis_output$age_years < 15 &
      !is.na(dis_output$age_years)

    # select children under five yrs
    UNDER_FIVE <- dis_output$age_years < 5 &
      !is.na(dis_output$age_years)

    # select children over one yr
    OVER_ONE <- dis_output$age_years > 1 &
      !is.na(dis_output$age_years)

    # anthropometric measurements for nutrition module
    dis_output <- gen_anthro(dis_output,
                             weight_var = "weight",
                             height_var = "height",
                             muac_var   = "muac",
                             age_var    = "age_years")
    # make oedema na for those over 5
    dis_output$oedema[!UNDER_FIVE] <- NA


    # only read write if over fifteen years
    dis_output$read_write[dis_under_15] <- NA
    no_read_write <- dis_under_15 | dis_output$read_write != "yes"
    dis_output$education_level[no_read_write] <- NA

    # measles vaccination only for those between 5 and 60 months (or just over 5yrs)
    no_vaccine <- with(dis_output,
                       age_months <= 5 | age_months >= 61 |
                         age_years >= 5)
    dis_output$measles_vaccination[no_vaccine] <- NA

    # vaccination card only if answered yes to measles vaccination
    dis_output$vaccination_card[dis_output$measles_vaccination != "yes" |
                                  is.na(dis_output$measles_vaccination)] <- NA

    # fix pregnancy
    # define rows that cant be pregnant
    pregnancy_not_possible <- with(
      dis_output,
      sex == "male" | age_years >= 50 | age_years < 15
    )

    # set those who cant be pregnant to NA for pregnant variable
    dis_output[["pregnant"]][pregnancy_not_possible] <- NA

    # set pregnancy related cause of death for those who arent pregnant to be unknown
    no_pregnancy <- dis_output$cause %in% c("during_pregnancy",
                                            "during_delivery",
                                            "post_partum") &
      pregnancy_not_possible

    no_pregnancy[is.na(no_pregnancy)] <- FALSE # replace NAs

    # pregnancy related cause of death n.a. for too old/young and for males
    dis_output[["cause"]][no_pregnancy] <- "dont_know"


    # malaria in pregnancies

    # malaria treatment only among pregnant people
    dis_output$malaria_treatment_preg[dis_output$pregnant != "yes" |
                                   is.na(dis_output$pregnant)] <- NA

    # duplicated malaria pregnancy variable from standard Questions (?pat remove)
    dis_output$malaria_treatment[dis_output$pregnant != "yes" |
                                        is.na(dis_output$pregnant)] <- NA

    # antenatal care bed net (among those with appropriate malaria doses)
    dis_output$anc_bednet[dis_output$pregnant != "yes" |
                            is.na(dis_output$pregnant) |
                            !dis_output$malaria_treatment_preg %in%
                              c("three_doses", "less_three_doses")] <- NA

    # prevention of malaria in infants
    dis_output$malaria_treatment_infant[dis_output$age_years >= 1] <- NA

    # health seeking behaviour in children being sick with malaria

    # only among children below 5 yrs
    dis_output[!UNDER_FIVE,
               c("fever_past_weeks",
                 "fever_now",
                 "care_fever")] <- NA

    # places of health care among those who sought it (care_fever == "yes")
    dis_output[dis_output$care_fever != "yes" |
                 is.na(dis_output$care_fever),
               c("place_healthcare",
                 "herbal_medicines",
                 "malaria_test",
                 "anti_malarials")] <- NA

    # antimalarials among those who received
    dis_output$anti_malarials_listed[dis_output$anti_malarials != "yes" |
                                       is.na(dis_output$anti_malarials)] <- NA

    # reason no healthcare
    dis_output$reason_no_care[!dis_output$care_fever %in% c("no", "dont_know") |
                                is.na(dis_output$care_fever)] <- NA


    # baseline malaria

    # only among children below 5 yrs
    dis_output[!UNDER_FIVE,
               c("thick_smear",
                 "thin_smear",
                 "rdt",
                 "oedema_mal")] <- NA



    # temperature in celsius
    dis_output$axiliary_temp[UNDER_FIVE] <- gen_eral(36.5:39.5,
                                                     sum(UNDER_FIVE))

    # clinical staging of spleen
    dis_output$spleen[UNDER_FIVE] <- gen_eral(0:4,
                                              sum(UNDER_FIVE))

    # anthropometric measurements for malaria module
    dis_output <- gen_anthro(dis_output,
                             weight_var = "weight_mal",
                             height_var = "height_mal",
                             muac_var   = "muac_mal",
                             age_var    = "age_years")

    # number of previous malaria episodes
    dis_output$malaria_episodes[UNDER_FIVE] <- gen_eral(0:9,
                                                        sum(UNDER_FIVE))


    # assume person is not born during study when age > 1
    dis_output$born[OVER_ONE] <- factor("No", levels(dis_output$born))
    dis_output$remember_dob[OVER_ONE] <- NA
    dis_output$date_birth[OVER_ONE] <- NA



    # resample death yes/no to have lower death rates
    dis_output$died <- sample(c("yes", "no"),
      size = nrow(dis_output),
      prob = c(0.05, 0.95),
      replace = TRUE
    )

    # set columns that are relate to "death" as NA if "died" is "no"
    died <- dis_output$died == "no" | is.na(dis_output$died)
    dcols <- c(
      "remember_death",
      "date_death",
      "cause",
      "place_death",
      # HSB module
      "source_death_hsb",
      "source_date_death_hsb",
      "period_illness_hsb",
      "place_death_hsb",
      "care_dying",
      "place_care_dying",
      "reason_no_care_hsb",
      # Violence module
      "source_death_viol",
      "source_date_death_viol",
      "period_illness_viol",
      "place_death_viol"
    )

    dis_output[died, dcols] <- NA


    # fix arrival/leave dates

    # cascaded of yeses dates and causes
    # and if did not arrive during study period or dont know date then NA

    not_arrived  <- dis_output$arrived != "yes"
    not_left     <- dis_output$left    != "yes"
    not_born     <- dis_output$born    != "yes"
    not_died     <- dis_output$died    != "yes"

    dis_output$remember_arrival[not_arrived] <- NA
    not_remember_arrival <- dis_output$remember_arrival != "yes"

    dis_output$date_arrived[not_arrived | not_remember_arrival] <- NA

    dis_output$remember_departure[not_left] <- NA
    not_remember_departure <- dis_output$remember_departure != "yes"

    dis_output$date_left[not_left | not_remember_departure] <- NA

    dis_output$remember_dob[not_born] <- NA
    not_remember_dob <- dis_output$remember_dob != "yes"

    dis_output$date_birth[not_born | not_remember_dob] <- NA

    dis_output$remember_death[not_died] <- NA
    not_remember_death <- dis_output$remember_death != "yes"

    dis_output$date_death[not_died | not_remember_death] <- NA

    dis_output$cause[not_died] <- NA


    # set arrival date to the earliest date from those given
    dis_output$date_arrived <- with(
      dis_output,
      pmin(
        date_arrived,
        date_left,
        date_birth,
        na.rm = TRUE
      )
    )

    # leave date
    dis_output <- enforce_timing(dis_output,
      first  = "date_arrived",
      second = "date_left",
      5:30
    )
    dis_output <- enforce_timing(dis_output,
      first  = "date_birth",
      second = "date_left",
      5:30,
      inclusive = TRUE
    )

    # died date
    dis_output <- enforce_timing(dis_output,
      first  = "date_arrived",
      second = "date_death",
      5:30
    )
    dis_output <- enforce_timing(dis_output,
      first  = "date_birth",
      second = "date_death",
      5:30,
      inclusive = TRUE
    )

    # set alternative questions to empty (not sure the purpose of these)
    dis_output[, c("present_start",
                   "born_later",
                   "present_today",
                   "reason_not_present",
                   "date_death_alt")] <- NA_character_


    # HSB module - death
    # note that NAs have already been set in the death section above

    dis_output$source_date_death_hsb[dis_output$source_death_hsb != "written" |
                                       is.na(dis_output$source_date_death_hsb)] <- NA

    dis_output$place_care_dying[dis_output$care_dying != "yes" |
                                  is.na(dis_output$care_dying)] <- NA

    dis_output$reason_no_care_hsb[!dis_output$place_care_dying %in% c("home",
                                                                      "other") |
                                    is.na(dis_output$place_care_dying)] <- NA

    # HSB module - last person ill

    # generate if this was the last person ill for each household (one each)
    dis_output <- gen_last_ill_hh(dis_output)

    # fix responses according to dictionary restrictions

    # set all illness questions to NA if not last person ill
    dis_output[dis_output$last_person_ill != "yes" |
                 is.na(dis_output$last_person_ill),
               c("cause_illness_last",
                 "current_status",
                 "start_illness",
                 "care_illness_last",
                 "treatment_delay",
                 "place_first_hf",
                 "reason_first_hf_selected",
                 "visit_second_hf",
                 "place_second_hf",
                 "reason_second_hf_selected",
                 names(dis_output)[
                   grep("source_money_last", names(dis_output))
                   ]
                 )] <- NA

    # reason for not seeking care only among those who did not
    dis_output$no_care_illness_last[dis_output$care_illness_last != "no" |
                                      is.na(dis_output$care_illness_last)] <- NA

    # set questions regarding type of healthcare saught to missing if did not seek
    dis_output[dis_output$care_illness_last != "yes" |
                 is.na(dis_output$care_illness_last),
               c("place_first_hf",
                 "reason_first_hf_selected",
                 "place_second_hf",
                 "reason_second_hf_selected",
                 "source_money_last"
                 )] <- NA


    # HSB module - diarrhoea

    # set all diarrhoea questions to NA if not diarrhoea
    dis_output[dis_output$diarrhoea_fever_2weeks != "yes" |
                 is.na(dis_output$diarrhoea_fever_2weeks),
               c("cause_illness_df",
                 "status_df",
                 "care_illness_df",
                 "no_care_illness_df",
                 "treatment_delay_df",
                 "place_first_hf_df",
                 "reason_first_hf_selected_df",
                 "visit_second_hf_df",
                 "place_second_hf_df",
                 "reason_second_hf_selected_df",
                 names(dis_output)[
                   grep("source_money_df", names(dis_output))
                   ]
                 )] <- NA

    # reason for not seeking care only among those who did not
    dis_output$no_care_illness_df[dis_output$care_illness_df != "no" |
                                      is.na(dis_output$care_illness_df)] <- NA

    # set questions regarding type of healthcare saught to missing if did not seek
    dis_output[dis_output$care_illness_df != "yes" |
                 is.na(dis_output$care_illness_df),
               c("place_first_hf_df",
                 "reason_first_hf_selected_df",
                 "place_second_hf_df",
                 "reason_second_hf_selected_df",
                 "source_money_df"
               )] <- NA

    # Violence - death
    ## note that death variables have been dealt with higher up already

    dis_output$source_date_death_viol[dis_output$source_death_viol != "written" |
                                       is.na(dis_output$source_date_death_hsb)] <- NA


    # Violence - generic questions

    # fix cascade of violence
    vtype <- c(
      "violent_episodes_number",
      "violence_nature",
      "violence_nature/beaten",
      "violence_nature/sexual",
      "violence_nature/shot",
      "violence_nature/detained_kidnapped",
      "violence_nature/other",
      "violence_nature/no_response",
      "uniform",
      "remember_violence_date",
      "date_violence",
      "place_violence"
    )
    dis_output[which(dis_output$violent_episode != "yes"), vtype] <- NA


    # add random number of violent episodes
    dis_output$violent_episodes_number <- as.numeric(dis_output$violent_episodes_number)
    dis_output[which(dis_output$violent_episode == "yes"),
               "violent_episodes_number"] <- gen_eral(1:5,
                                                      nrow(dis_output[which(dis_output$violent_episode == "yes"),]))

    dis_output[which(dis_output$violence_nature == ""),
               "violence_nature/no_response"] <- "1"
    dis_output$violence_nature[dis_output$violence_nature == ""] <- "no_response"

  }

  if (dictionary == "Nutrition") {

    # create household numbers within cluster numbers
    dis_output <- gen_hh_clusters(dis_output,
                                  cluster = "cluster_number",
                                  household = "household_number",
                                  eligible = "number_children",
                                  inc_building = TRUE,
                                  building = "households_building",
                                  select_household = "random_hh"
    )


    # create index numbers and unique IDs
    # index is the unique household (the parent_index for kobo outputs)
    # index_y is the unique individual within households (index for kobo outputs)
    # uid combines these to produce a unique identifier for each individual
    dis_output <- gen_survey_uid(dis_output)

    # fix consent
    dis_output <- gen_consent(dis_output)

    # age in yr (0 to 5) - assuming doing nutrition in under 5 year olds
    dis_output$age_years <- sample_age(5L, numcases)
    dis_output$age_months <- NA_integer_

    # age in mth (0 to 11)
    zero_yrs <- dis_output$age_years < 1
    dis_output$age_months[zero_yrs] <- sample_age(11L, sum(zero_yrs, na.rm = TRUE))


    # set vars to numeric
    anthro_vars <- c("weight",
                     "height",
                     "muac",
                     "whz")

    for (i in anthro_vars) {
      dis_output[[i]] <- as.numeric(dis_output[[i]])
    }

    # anthropometric measurements for nutrition module
    dis_output <- gen_anthro(dis_output,
                             weight_var = "weight",
                             height_var = "height",
                             muac_var   = "muac",
                             age_var    = "age_years")
    # make oedema na for those over 5
    dis_output$oedema[dis_output$age_years >= 5] <- NA

  }

  if (dictionary == "Vaccination_long") {


    # create household numbers within cluster numbers
    dis_output <- gen_hh_clusters(dis_output,
                                  cluster = "cluster_number",
                                  household = "household_number",
                                  eligible = "number_children",
                                  inc_building = TRUE,
                                  building = "households_building",
                                  select_household = "random_hh"
    )


    # create index numbers and unique IDs
    # index is the unique household (the parent_index for kobo outputs)
    # index_y is the unique individual within households (index for kobo outputs)
    # uid combines these to produce a unique identifier for each individual
    dis_output <- gen_survey_uid(dis_output)

    # cumulatively count children by household
    dis_output$child_number <- ave(as.character(dis_output$index),
                      as.character(dis_output$index),
                      FUN = function(x) rank(x, ties.method = "first"))

    # age in yr (0 to 15) - assuming doing vaccination coverage among those aged less than 15 yrs
    dis_output$age_years <- sample_age(15L, numcases)
    dis_output$age_months <- NA_integer_

    # age in mth (0 to 11)
    zero_yrs <- dis_output$age_years < 1
    dis_output$age_months[zero_yrs] <- sample_age(11L, sum(zero_yrs, na.rm = TRUE))

    # fix consent
    dis_output <- gen_consent(dis_output)

    # vaccine card only among those who have received vacccine
    dis_output$vaccine_card[dis_output$any_vaccine != "yes" |
                              is.na(dis_output$any_vaccine)] <- NA

    # health facility records checked only among those who have records
    dis_output$date_records_checked[dis_output$hf_records != "yes" |
                                      is.na(dis_output$hf_records)] <- NA

    ## vaccination history without card

    # variables relevant to without card questions
    woc_vars <- c("injection_upper_arm"       ,
                  "scar_present"              ,
                  "poliodrop_woc"             ,
                  "poliodrop_hf_woc"          ,
                  "poliodrop_camp_woc"        ,
                  "polioinjection_woc"        ,
                  "num_polioinjection_woc"    ,
                  "quad_penta_woc"            ,
                  "num_quad_penta_woc"        ,
                  "pcv_woc"                   ,
                  "num_pcv_woc"               ,
                  "measles_woc"               ,
                  "num_measles_woc"           ,
                  "measles_hf_woc"            ,
                  "measles_camp_woc"          ,
                  "yellow_fever_woc"          ,
                  "num_yellow_fever_woc"      ,
                  "yellow_fever_hf_woc"       ,
                  "yellow_fever_camp_woc"     ,
                  "rotavirus_woc"             ,
                  "num_rotavirus_woc"         ,
                  "vacc_facility_woc"         ,
                  "other_facility_woc"        ,
                  "name_hf_woc"               ,
                  "all_vaccines_caretaker_woc",
                  "all_vaccines_survey_woc")

    # set all "without card" variables to missing if vaccination card present
    dis_output[dis_output$vaccine_card != "no" |
                 is.na(dis_output$vaccine_card),
               woc_vars] <- NA

    # scar present only where upper arm injection yes
    dis_output$scar_present[dis_output$injection_upper_arm != "yes" |
                              is.na(dis_output$injection_upper_arm)] <- NA


    # vaccines with single number question

    vacc_vars <- c(# single number questions
                 "polioinjection",
                 "quad_penta",
                 "pcv",
                 "rotavirus",
                 # double number questions
                 "poliodrop",
                 "measles",
                 "yellow_fever"
                 )

    for (i in vacc_vars) {

      # pull together names of variables want to use
      varz <- paste0(i, "_woc")
      numvarz <- paste0("num_", varz)
      numvarz_hf <- paste0(i, "_hf_woc")
      numvarz_camp <- paste0(i, "_camp_woc")

      # find the rows which have that vaccine
      filter_rows <- dis_output[[varz]] == "yes" &
        !is.na(dis_output[[varz]])

      # for single number questions
      if (i %in% c("polioinjection",
                   "quad_penta",
                   "pcv",
                   "rotavirus")) {

        # create a random number of doses given
        dis_output[[numvarz]][filter_rows] <- gen_eral(1:2,
                                          sum(filter_rows))

      } else if (i %in% "poliodrop") {
        # create a random number of doses given in hf
        dis_output[[numvarz_hf]][filter_rows]  <- gen_eral(1:2,
                                          sum(filter_rows))
        #create a random number of doses given in camp
        dis_output[[numvarz_camp]][filter_rows]  <- gen_eral(1:2,
                                             sum(filter_rows))
      } else {

        # create a random number of doses given
        dis_output[[numvarz]][filter_rows]  <- gen_eral(1:2,
                                          sum(filter_rows))

        # create a random number of doses given in hf
        dis_output[[numvarz_hf]][filter_rows]  <- dis_output[[numvarz]][filter_rows] - 1
        #create a random number of doses given in camp
        dis_output[[numvarz_camp]][filter_rows] <- dis_output[[numvarz]][filter_rows] - dis_output[[numvarz_hf]][filter_rows]

      }

    }

    # if care-taker thinks all vaccines taken or unsure then surveyor answer
    dis_output$all_vaccines_survey_woc[!dis_output$all_vaccines_caretaker_woc %in%
                                         c("yes", "dont_know")] <- NA

    ## vaccination history with a card

    vacc_vars <- dat_dict$name[dat_dict$type == "vaccine_card"]


    # if have answered the without car section then this section NA
    dis_output[which(dis_output$vaccine_card == "yes"),
               vacc_vars] <- NA

    for (i in vacc_vars) {

      vaccine <- gsub("[0-9]+", "", i)
      dose <- suppressWarnings(as.numeric(gsub("[a-z]+", "", i)))
      date_var <- paste0("date_", i)

      # take in to account previous doses not given (then current not given)
      if (!is.na(dose) & dose > 1) {
        # find the previous dose variable
        prev_dose <- dose - 1
        prev_vaccine <- paste0(vaccine, prev_dose)
        # define if previous dose given or not
        no_prev_vaccine <- !dis_output[[prev_vaccine]] %in% c("yes_date", "yes_nodate")

        # for previous doses not given, set current dose to missing
        dis_output[[i]][no_prev_vaccine] <- "no"
        dis_output[[date_var]][no_prev_vaccine] <- NA

      }

      # set current date to missing if vaccine not given (or date not known)
      dis_output[[date_var]][dis_output[[i]] != "yes_date" |
                                 is.na(dis_output[[i]])] <- NA

    }

    # reasons not vaccinated
    not_vacc <- !dis_output$all_vaccines_survey_card %in% c("yes") &
      !dis_output$all_vaccines_survey_woc %in% c("yes")

    reasons <- grep("reason_not_all_vacc", names(dis_output))

    dis_output[not_vacc, reasons] <- NA

  }

  if (dictionary == "Vaccination_short") {

    # create household numbers within cluster numbers
    dis_output <- gen_hh_clusters(dis_output,
                                  cluster = "cluster_number",
                                  household = "household_number",
                                  eligible = "number_children",
                                  inc_building = TRUE,
                                  building = "households_building",
                                  select_household = "random_hh"
    )


    # create index numbers and unique IDs
    # index is the unique household (the parent_index for kobo outputs)
    # index_y is the unique individual within households (index for kobo outputs)
    # uid combines these to produce a unique identifier for each individual
    dis_output <- gen_survey_uid(dis_output)

    # cumulatively count children by household
    dis_output$child_number <- ave(as.character(dis_output$index),
                                   as.character(dis_output$index),
                                   FUN = function(x) rank(x, ties.method = "first"))

    # age in yr (0 to 15) - assuming doing vaccination coverage among those aged less than 15 yrs
    dis_output$age_years <- sample_age(15L, numcases)
    dis_output$age_months <- NA_integer_

    # age in mth (0 to 11)
    zero_yrs <- dis_output$age_years < 1
    dis_output$age_months[zero_yrs] <- sample_age(11L, sum(zero_yrs, na.rm = TRUE))

    # fix consent
    dis_output <- gen_consent(dis_output)


    # clean up routine vaccination
    dis_output <- gen_vaccs(dis_output,
                            vacc_var =     "routine_vacc",
                            age_vacc_var = "age_routine_vacc",
                            age_var =      "age_months",
                            place_var =    "place_routine_vacc",
                            reason_var =   "reason_route_vacc"
                            )

    # clean up msf vaccination
    dis_output <- gen_vaccs(dis_output,
                            vacc_var =     "msf_vacc",
                            age_vacc_var = "age_msf_vacc",
                            age_var =      "age_months",
                            place_var =    "place_msf_vacc",
                            reason_var =   "reason_msf_vacc"
                            )

    # clean up sia vaccination
    dis_output <- gen_vaccs(dis_output,
                            vacc_var =     "sia_vacc",
                            age_vacc_var = "age_sia_vacc",
                            age_var =      "age_months",
                            place_var =    "place_sia_vacc",
                            reason_var =   "reason_sia_vacc"
                            )

    # add in age for children with measles
    meas_diag <- dis_output$diagnosis_disease == "yes"
    meas_diag[is.na(meas_diag)] <- FALSE

    # sample months
    dis_output$age_diagnosis[meas_diag] <- sample_age(11L, sum(meas_diag, na.rm = TRUE))
    # if age months not empty just use that (otherwise will have some in future)
    dis_output$age_diagnosis[meas_diag &
                               has_value(dis_output$age_months) &
                               dis_output$age_diagnosis > dis_output$age_months] <- dis_output$age_months[meas_diag &
                                                                                                            has_value(dis_output$age_months) &
                                                                                                            dis_output$age_diagnosis > dis_output$age_months]

  }


  # return dataset as a tibble
  dplyr::as_tibble(dis_output)
}

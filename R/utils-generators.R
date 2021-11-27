
sample_age <- function(x, n) {
  # Sample the value of x n times
  v <- sample(0:x, size = n, replace = TRUE, prob = (x+1):1)
  return(v)
}

#' generate ages and insert in data frame
#'
#' @param dis_output a data frame with some age columns
#' @param numcases number of cases to generate
#' @param set_age_na whether or not to set higher-order ages to NA if they are
#'   below the thresholds
#'
#' @return a data frame with ages in the dis_output
#' @noRd
gen_ages <- function(dis_output, numcases, set_age_na = TRUE,
                     year_cutoff = 2, month_cutoff = 2) {

  # GENERATE AGES --------------------------------------------------------------

  # sample age_month and age_days if appropriate
  age_year_var <- grep("age.*year", names(dis_output), value = TRUE)[1]
  age_month_var <- grep("age.*month", names(dis_output), value = TRUE)[1]
  age_day_var <- grep("age.*day", names(dis_output), value = TRUE)[1]

  # indicator vectors for ages under two years and months, respectively. Ages
  # under two years/months should go down to a more fine-grained age
  U2_YEARS <- integer(0)
  U2_MONTHS <- integer(0)


  if (has_value(age_year_var)) {
    # sample 0:100
    years <- sample_age(100L, numcases)
    U2_YEARS <- which(years <= year_cutoff)
    if (set_age_na) {
      years[U2_YEARS] <- NA_integer_
    }

    dis_output[[age_year_var]] <- years
  } else {
    if (has_value(age_year_var)) {
      dis_output[[age_year_var]] <- NA_integer_
    }
    years <- NA
  }

  if (has_value(age_month_var) && length(U2_YEARS) > 0 && sum(U2_YEARS) > 0) {
    # age_month
    months <- sample_age((year_cutoff + 1) * 12, length(U2_YEARS))
    damv <- dis_output[[age_month_var]]
    damv[U2_YEARS] <- months
    U2_MONTHS <- which(damv <= month_cutoff)
    if (set_age_na) {
      damv[U2_MONTHS] <- NA_integer_
    }

    dis_output[[age_month_var]] <- damv
  } else {
    if (has_value(age_month_var)) {
      dis_output[[age_month_var]] <- NA_integer_
    }
    months <- NA
  }

  if (has_value(age_day_var) && length(U2_MONTHS) > 0 && sum(U2_MONTHS) > 0) {
    # age_days
    dis_output[[age_day_var]][U2_MONTHS] <- sample_age((month_cutoff + 1) * 20,
                                                       length(U2_MONTHS))
  } else {
    if (has_value(age_day_var)) {
      dis_output[[age_day_var]] <- NA_integer_
    }
  }

  return(dis_output)
}

gen_eral <- function(what, n) {
  sample(what, n, replace = TRUE)
}

gen_village <- function(n) {
  gen_eral(c("Village A", "Village B", "Village C", "Village D"), n)
}

gen_ward <- function(n) {
  gen_eral(c("Ward A", "Ward B", "Ward C", "Ward D"), n)
}

gen_ward <- function(n) {
  gen_eral(c("Ward A", "Ward B", "Ward C", "Ward D"), n)
}

gen_freetext <- function(n) {
  gen_eral(c("Messy location A", "Messy location B", "Messy location C", "Messy location D"), n)
}


#' generate household clusters
#'
#' @param dis_output a data frame
#' @param cluster the name of the cluster columns
#' @param household the name of the household column
#' @param eligible the name of the column counting the number to be interviewed
#' @param inc_building whether to include variables for buildings with multiple
#' households (i.e. count num hh and select a random one) - default is TRUE
#' @param building the name of the column counting the number of households in a
#' building (only used if inc_building == TRUE)
#' @param select_household = the name of the column selecting a random household
#' in a building (only used if inc_building == TRUE)
#'
#' @return a data frame with household and clusters
#' @noRd
gen_hh_clusters <- function(dis_output,
                            cluster = "cluster_number",
                            household = "household_number",
                            eligible = "member_number",
                            inc_building = TRUE,
                            building = "households_building",
                            select_household = "random_hh"
                            ) {

  # cluster ID (based on village)
  dis_output[[cluster]] <- as.numeric(factor(dis_output$village_name))


  # household ID (numbering starts again for each cluster)
  for (i in unique(dis_output[[cluster]])) {
    nums <- sum(dis_output[[cluster]] == i)
    hhid <- sample(1:(as.integer(nums / 5) + 1), nums, replace = TRUE)

    dis_output[[household]][dis_output[[cluster]] == i] <- hhid
  }

  dis_output[[eligible]] <- gen_eligible_interviewed(
    dis_output,
    household = household,
    cluster = cluster,
    eligible = eligible
  )

  # add if there are multiple households in one building
  if (inc_building) {
    dis_output <- gen_hh_rand(dis_output,
                              cluster,
                              household,
                              building,
                              select_household)
  }

  return(dis_output)
}

#' generate appropriate "eligible" count columns in a data frame
#'
#' @param dis_output a data frame containing household and cluster
#' @param household [character] the column specifying household
#' @param cluster [character] the column specifying cluster
#'
#' @return vector of numbers with appropriate length for eligible column in dis_output
#'   - eligible: the number of individuals within each household increased by 25%
#'
#' @noRd
gen_eligible_interviewed <- function(dis_output,
                                     household = "household_number",
                                     cluster = "cluster_number",
                                     eligible = "member_number") {

  # make variables tidy-accessible
  hh <- rlang::sym(household)
  cl <- rlang::sym(cluster)
  el <- rlang::sym(eligible)

  # get counts of people by household and cluster
  hh_count <- dplyr::count(dis_output, !!hh, !!cl, .drop = FALSE, name = "eligible")

  # make the number of eligible 25% more than count of actually interviewed
  hh_count$eligible <- round(hh_count$eligible * 1.25, digits = 0L)

  # merge with dis_output to get the correct number
  intermed <- dplyr::left_join(dis_output, hh_count, by = c(household, cluster))

  # return just the counts
  intermed$eligible
}


#' generate appropriate random household selection columns in a data frame
#'
#' @param dis_output a data frame containing household and cluster
#' @param household [character] the column specifying household
#' @param cluster [character] the column specifying cluster
#' @param building the name of the column counting the number of households in a
#' building
#' @param select_household = the name of the column selecting a random household
#' in a building
#'
#' @importFrom dplyr distinct mutate left_join
#' @importFrom rlang .data :=
#'
#' @return vector of numbers with appropriate length for columns in dis_output that
#' show how many households are in a building and which household was selecteds
#'
#' @noRd
gen_hh_rand <- function(dis_output,
                        cluster = "cluster_number",
                        household = "household_number",
                        building = "households_building",
                        select_household = "random_hh") {

  # unique households (buildings)
  multi_building <- dplyr::distinct(dis_output,
                         .data[[{{cluster}}]],
                         .data[[{{household}}]])

  building_intermed <- paste0(building, "_new")
  select_household_intermed <- paste0(select_household, "_new")

  # how many households per building
  multi_building <- dplyr::mutate(multi_building,
                                  {{building_intermed}} := gen_eral(1:3,
                                                          nrow(multi_building))
                                  )

  # add which household selected if more than one in building
  multiples <- which(multi_building[[building_intermed]] > 1)

  multi_building[[select_household_intermed]] <- NA_integer_

  for (i in multiples) {
    max_num <- multi_building[[building_intermed]][i]
    multi_building[i, select_household_intermed] <- gen_eral(1:max_num, 1)
  }

  # create an intermediate dataframe (so we can overwrite individual cols later)
  intermed <- dplyr::left_join(dis_output, multi_building, by = c({{cluster}},
                                                                  {{household}}))

  # overwrite original variables in dataframe
  dis_output[[{{building}}]] <- intermed[[building_intermed]]
  dis_output[[{{select_household}}]] <- intermed[[select_household_intermed]]

  # return dataframe
  return(dis_output)

}




#' generate unique identifiers for individuals in a data frame
#'
#' @param dis_output a data frame containing household and cluster
#' @param household [character] the column specifying household
#' @param cluster [character] the column specifying cluster
#' @param parent_index [character] name of a new column to be created with unique identifiers at the household level
#' @param child_index [character] name of a new column to be created with unique identifiers of individuals
#' @param uid_name [character] name of a new column to be created with unique identifiers
#'
#' @importFrom dplyr group_by mutate cur_group_id ungroup
#' @importFrom rlang .data :=
#'
#' @return a new variable in your dataframe which successively numbers individuals
#' in unique households to create an identifier
#'
#' @noRd

gen_survey_uid <- function(dis_output,
                           cluster = "cluster_number",
                           household = "household_number",
                           parent_index = "index",
                           child_index = "index_y",
                           uid_name = "uid") {

  dis_output <- dplyr::group_by(dis_output,
                          .data[[cluster]],
                          .data[[household]])

  dis_output <- dplyr::mutate(dis_output,
                       {{parent_index}} := dplyr::cur_group_id(),
                       {{child_index}} := rank(.data[[household]], ties.method = "first"),
                       {{uid_name}} := sprintf("%s_%s", .data[[parent_index]], .data[[child_index]]))

  dplyr::ungroup(dis_output)

}


#' generate appropriate ill people count ("ill_hh_number") column in a data frame
#'
#' @param dis_output a data frame containing household and cluster
#' @param parent_index [character] name of column with unique identifiers at the household level
#' @param eligible name of column with number of individuals within each household
#' @param ill_count name of column where counts should be added to
#'
#' @importFrom dplyr relocate
#'
#' @return a variable in your dataframe which gives the number of ill people
#' in a household (appropriately repeated for unique households)
#'
#' @noRd

gen_ill_hh <- function(dis_output,
                       parent_index = "index",
                       eligible = "member_number",
                       ill_count = "ill_hh_number") {

  # get individual households (parent_index unique incl for clusters)
  hhs <- unique(dis_output[[parent_index]])

  # get random proportions to multiply by
  ill_member_mult <- gen_eral(seq(0, 0.5, by = 0.1),
                              length(hhs))

  # create a dataframe for households with multiplier
  mrgr <- data.frame(hhs, ill_member_mult)

  # rename appropriately
  names(mrgr) <- c(parent_index, "ill_member_mult")

  # combine with original dataset
  dis_output <- merge(dis_output, mrgr, by = parent_index)

  # move parent_index variable back to original position
  dis_output <- dplyr::relocate(dis_output,
                                {{parent_index}},
                                .before = paste0(parent_index, "_y"),
                                )

  # create ill variable by multiplying household count by multiplier
  dis_output[[ill_count]] <- ceiling(
    dis_output[[eligible]] * dis_output[["ill_member_mult"]]
  )

  # remove multiplier variable
  dis_output$ill_member_mult <- NULL

  # return dataset
  return(dis_output)
}




#' generate appropriate consent column and set non-responders to empty
#'
#' @param dis_output a data frame containing household and cluster
#' @param parent_index [character] name of column with unique identifiers at the household level
#' @param consent name of a column where consent (y/n) should be added
#'
#' @importFrom dplyr distinct
#'
#' @return a variable in your dataframe which gives consent (y/n), with the same
#' response for all individuals of a household
#'
#' @noRd

gen_consent <- function(dis_output,
                        parent_index = "index",
                        consent = "consent",
                        no_consent_reason = "no_consent_reason") {


  # get individual households (parent_index unique incl for clusters)
  hhs <- dplyr::distinct(dis_output, .data[[parent_index]])

  # resample consent to have a 10% non-response rate
  hhs[[paste0(consent, "_new")]] <- sample(c("yes", "no"),
                               size = nrow(hhs),
                               prob = c(0.9, 0.1),
                               replace = TRUE
                           )

  # create an intermediate dataframe (so we can overwrite individual cols later)
  intermed <- dplyr::left_join(dis_output, hhs, by = {{parent_index}})

  # overwrite original variables in dataframe
  dis_output[[{{consent}}]] <- intermed[[paste0(consent, "_new")]]

  # if consent is no then make everything else NA
  consent_columns <- which(names(dis_output) == consent) + 2
  consent_columns <- seq(consent_columns, ncol(dis_output))
  no_consent <- dis_output[[consent]] == "no"
  dis_output[no_consent, consent_columns] <- NA

  # no_consent_reason should be NA if consent is yes
  dis_output[[no_consent_reason]][!no_consent] <- NA

  return(dis_output)
}



#' generate appropriate last person ill column in a data frame
#'
#' @param dis_output a data frame containing household and cluster
#' @param parent_index [character] name of column with unique identifiers at the household level
#' @param eligible name of column with number of individuals within each household
#' @param ill_count name of column where counts should be added to
#'
#' @importFrom dplyr group_by mutate
#'
#' @return a variable in your dataframe which gives only one person being the
#' last one ill in a household in a household
#'
#' @noRd

gen_last_ill_hh <- function(dis_output,
                       parent_index = "index",
                       last_ill = "last_person_ill") {

  # group by household identifier
  dis_output <- dplyr::group_by(dis_output, .data[[parent_index]])

  # create var to count the number of in a household
  dis_output <- dplyr::mutate(dis_output,
                              counter = cumsum(.data[[last_ill]] == "yes"))

  # if last_person_ill is yes and the yes_count > 1 then set to "no"
  dis_output[[last_ill]][dis_output$counter > 1] <- "no"

  dis_output$counter <- NULL

  return(dis_output)
}


#' generate appropriate anthropometric variables for mortality and nutrition
#'
#' @param dis_output a data frame containing household and cluster
#' @param weight_var name of variable for weight in kilograms
#' @param height_var name of variable for height in centimetres
#' @param muac_var   name of variable for mid-upper arm circumference (MUAC) in milimetres
#' @param age_var    name of a variable for age in years (used for filtering)
#'
#' @return three variables in your dataframe with the appropriate measures
#'
#' @noRd

gen_anthro <- function(dis_output,
                       weight_var,
                       height_var,
                       muac_var,
                       age_var) {

  age_filter <- which(dis_output[[age_var]] < 5)
  nums <- length(age_filter)

  # weight in kg
  dis_output[age_filter, weight_var] <- round(
    runif(nums, 2, 30),
    digits = 1
  )

  # height in cm
  dis_output[age_filter, height_var] <- round(
    runif(nums, 40, 120),
    digits = 1
  )

  # MUAC in mm
  dis_output[age_filter, muac_var] <- sample(80:190, nums, replace = TRUE)

  # return dataset
  return(dis_output)

}


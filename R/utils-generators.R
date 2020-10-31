
sample_age <- function(x, n) {
  # Sample the value of x n times
  v <- sample(0:x, size = n, replace = TRUE)
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
    # sample 0:120
    years <- sample_age(120L, numcases)
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
#'
#' @return a data frame with household and clusters
#' @noRd
gen_hh_clusters <- function(dis_output, n, cluster = "cluster_number",
                            household = "household_number", eligible = "member_number") {

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
gen_eligible_interviewed <- function(dis_output, household = "household_number",
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


#' generate appropriate "eligible" count columns in a data frame
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

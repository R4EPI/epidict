
#' generate ages and insert in data frame
#'
#' @param dis_output a data frame with some age columns
#' @param numcases number of cases to generate
#' @param set_age_na whether or not to set higher-order ages to NA if they are
#'   below the thresholds
#'
#' @return a data frame with ages in the dis_output
#' @noRd
gen_ages <- function(dis_output, numcases, set_age_na = TRUE) {

  # GENERATE AGES --------------------------------------------------------------

  # sample age_month and age_days if appropriate
  age_year_var  <- grep("age.*year",  names(dis_output), value = TRUE)[1]
  age_month_var <- grep("age.*month", names(dis_output), value = TRUE)[1]
  age_day_var   <- grep("age.*day",   names(dis_output), value = TRUE)[1]

  # indicator vectors for ages under two years and months, respectively. Ages
  # under two years/months should go down to a more fine-grained age
  U2_YEARS  <- integer(0)
  U2_MONTHS <- integer(0)
  
  sample_age <- function(x = 120, n = numcases) {
    # Sample the value of x n times
    v      <- sample(0:x, size = n, replace = TRUE)
    return(v)
  }

  if (has_value(age_year_var)) {
    # sample 0:120
    years    <- sample_age(120L, numcases)
    U2_YEARS <- which(years <= 2)
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
    months          <- sample_age(24L, length(U2_YEARS))
    damv            <- dis_output[[age_month_var]]
    damv[U2_YEARS]  <- months
    U2_MONTHS       <- which(damv <= 2)
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
    dis_output[[age_day_var]][U2_MONTHS] <- sample_age(60L, length(U2_MONTHS))
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
#'
#' @return a data frame with household and clusters
#' @noRd
gen_hh_clusters <- function(dis_output, n, cluster = "cluster_number", household = "household_id") {

    # sample villages
    dis_output$village <- gen_village(n)
    # make two health districts
    dis_output$health_district <- ifelse(grepl("[AB]", dis_output$village),
      yes = "District A", 
      no = "District B"
    )

    # cluster ID (based on village)
    dis_output[[cluster]] <- as.numeric(factor(dis_output$village))


    # household ID (numbering starts again for each cluster)
    for (i in unique(dis_output[[cluster]])) {

      nums <- sum(dis_output[[cluster]] == i)
      hhid <- sample(1:(as.integer(nums/5) + 1), nums, replace = TRUE)

      dis_output[[household]][dis_output[[cluster]] == i] <- hhid
    }

    return(dis_output)

}

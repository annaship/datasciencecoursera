rankhospital <- function(state, outcome, num = "best") { 
  read_outcome_data <- function() {
    ## Read outcome data
    all_outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    all_outcome[, 11] <- as.numeric(all_outcome[, 11]) # "heart attack"
    all_outcome[, 17] <- as.numeric(all_outcome[, 17]) # "heart failure"
    all_outcome[, 23] <- as.numeric(all_outcome[, 23]) # "pneumonia
    all_outcome
  }
  
  check_vars <- function() {
    ## Check that state and outcome are valid
    states <- unique(all_outcome[, 7])
    state.valid <- state %in% states
    if (!state.valid) {
      stop("invalid state")
    }
    
    correct_outcomes <- c("heart attack", "heart failure", "pneumonia")
    outcome.valid <- outcome %in% correct_outcomes
    if (!outcome.valid) {
      stop("invalid outcome")
    }
  }
  
  simplify_names <- function() {
    colnames_idx <- data.frame(colnames(all_outcome))
    short_names <- c(colnames_idx[11, ], colnames_idx[17, ], colnames_idx[23, ])
    names(short_names) <- c("heart attack", "heart failure", "pneumonia")
    full_outcome_name <- short_names[outcome]
    full_outcome_name
  }
  
  handle_ties <- function(res) {
    ## Handling ties
    if(length(res) > 1) {
      return(sort(res)[1])
    }
    else res
  }
  
  ## RUN ##
  all_outcome <- read_outcome_data()
  check_vars()
  full_outcome_name <- simplify_names()
  
  # subset(airquality, Temp > 80, select = c(Ozone, Temp))
  
  not_na_outcome <- subset(all_outcome, (!is.na(all_outcome[, full_outcome_name])))
  this_state_data <- subset(not_na_outcome, State == state)

  ## Return hospital name in that state with the given rank 30-day death rate
  ranked_hsp <- this_state_data[order(this_state_data[, full_outcome_name], this_state_data$Hospital.Name), "Hospital.Name"]

  cnt_hospitals <- length(ranked_hsp)
  if (num == "best") {
    num = 1
  }
  else if (num == "worst") {
    num = cnt_hospitals
  }
  else if (num > cnt_hospitals) {
    return(NA)
  }
  
  handle_ties(ranked_hsp[num])
}

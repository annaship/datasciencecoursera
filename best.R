# TODO: Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals when deciding the rankings.

# Write a function called best that take two arguments: the 2-character abbreviated name of a state [7] and an outcome name. The function reads the outcome-of-care-measures.csv file and returns a character vector with the name of the hospital [2] that has the best (i.e. lowest) 30-day mortality for the specified outcome in that state. The hospital name is the name provided in the Hospital.Name variable. The outcomes can be one of “heart attack” [11], “heart failure” [17], or “pneumonia” [23]. Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals when deciding the rankings.
# Handling ties. If there is a tie for the best hospital for a given outcome, then the hospital names should be sorted in alphabetical order and the first hospital in that set should be chosen (i.e. if hospitals “b”, “c”, and “f” are tied for best, then hospital “b” should be returned).

best <- function(state, outcome) {
  ## Read outcome data
  read_outcome_data <- function() {
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
  
  all_outcome <- read_outcome_data()
  check_vars()
  
  ## Return hospital name in that state with lowest 30-day death rate
  colnames_idx <- data.frame(colnames(all_outcome))
  short_names <- c(colnames_idx[11, ], colnames_idx[17, ], colnames_idx[23, ])
  names(short_names) <- c("heart attack", "heart failure", "pneumonia")
  full_outcome_name <- short_names[outcome]
  
  this_state_data <- subset(all_outcome, all_outcome$State == state)
  curr_outcome <- this_state_data[, full_outcome_name]
  curr_min <- min(curr_outcome, na.rm = TRUE)
  
  res_no_na <- this_state_data$Hospital.Name[(curr_outcome == curr_min) & (!is.na(curr_outcome))]

  handle_ties <- function() {
    ## Handling ties
    if(length(res_no_na) > 1) {
      return(sort(res_no_na)[1])
    }
    else res_no_na
  }
  handle_ties()
}

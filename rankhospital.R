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
  
  handle_ties <- function() {
    ## Handling ties
    if(length(res_no_na) > 1) {
      return(sort(res_no_na)[1])
    }
    else res_no_na
  }
  
  ## RUN ##
  all_outcome <- read_outcome_data()
  check_vars()
  full_outcome_name <- simplify_names()
  
  this_state_data <- subset(all_outcome, all_outcome$State == state)
  curr_outcome <- this_state_data[, full_outcome_name]
  
  ## Return hospital name in that state with the given rank 30-day death rate
  # res_no_na <- this_state_data$Hospital.Name[(curr_outcome == curr_min) & (!is.na(curr_outcome))]
  ranked_hsp <- this_state_data[order(curr_outcome), "Hospital.Name"]
  
  handle_ties()
}

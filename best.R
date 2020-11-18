# Write a function called best that take two arguments: the 2-character abbreviated name of a state [7] and an outcome name. The function reads the outcome-of-care-measures.csv file and returns a character vector with the name of the hospital [2] that has the best (i.e. lowest) 30-day mortality for the specified outcome in that state. The hospital name is the name provided in the Hospital.Name variable. The outcomes can be one of “heart attack” [11], “heart failure” [17], or “pneumonia” [23]. Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals when deciding the rankings.
# Handling ties. If there is a tie for the best hospital for a given outcome, then the hospital names should be sorted in alphabetical order and the first hospital in that set should be chosen (i.e. if hospitals “b”, “c”, and “f” are tied for best, then hospital “b” should be returned).

best <- function(state, outcome) {
  ## Read outcome data
  all_outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  all_outcome[, 11] <- as.numeric(all_outcome[, 11])
  all_outcome[, 17] <- as.numeric(all_outcome[, 17])
  all_outcome[, 23] <- as.numeric(all_outcome[, 23])
  
  ## Check that state and outcome are valid
  states <- unique(all_outcome[, 7])
  state.valid <- state %in% states
  
  correct_outcomes <- c("heart attack", "heart failure", "pneumonia")
  outcome.valid <- outcome %in% correct_outcomes
  
  ## Return hospital name in that state with lowest 30-day death rate
  mha <- min(all_outcome[, 11], na.rm = TRUE)
  this_state_data <- subset(all_outcome, all_outcome$State == state)

  with(all_outcome, Hospital.Name[State = "TX"])
  colnames_idx <- data.frame(colnames(all_outcome))
  all_outcome[, colnames_idx[2,]] == outcome & all_outcome$State == "TX"
  seach_vector <- all_outcome$State == "TX" & all_outcome[, colnames_idx[11, ]] == mha
         
}
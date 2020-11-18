# Write a function called best that take two arguments: the 2-character abbreviated name of a state [7] and an outcome name. The function reads the outcome-of-care-measures.csv file and returns a character vector with the name of the hospital [2] that has the best (i.e. lowest) 30-day mortality for the specified outcome in that state. The hospital name is the name provided in the Hospital.Name variable. The outcomes can be one of “heart attack” [11], “heart failure” [17], or “pneumonia” [23]. Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals when deciding the rankings.
# Handling ties. If there is a tie for the best hospital for a given outcome, then the hospital names should be sorted in alphabetical order and the first hospital in that set should be chosen (i.e. if hospitals “b”, “c”, and “f” are tied for best, then hospital “b” should be returned).

best <- function(state, outcome) {
  ## Read outcome data
  all_outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  ## Check that state and outcome are valid
  states <- unique(all_outcome[, 7])
  state.valid <- state %in% states
  
  correct_outcomes <- c("heart attack", "heart failure", "pneumonia")
  outcome.valid <- outcome %in% correct_outcomes
  
  ## Return hospital name in that state with lowest 30-day death rate
  
}
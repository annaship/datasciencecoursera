#  Write a function named 'pollutantmean' that calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors. The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' particulate matter data from the directory specified in the 'directory' argument and returns the mean of the pollutant across all of the monitors, ignoring any missing values coded as NA. A prototype of the function is as follows

pollutantmean <- function(directory, pollutant, id = 1:332) {
  files_full <- list.files(path = directory, pattern = "*.csv", full.names = T)
  tmp <- lapply(files_full[id], read.csv)
  dat <- do.call(rbind, tmp)
  mean(dat[, pollutant], na.rm = TRUE)
}

#  Write a function named 'pollutantmean' that calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors. The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' particulate matter data from the directory specified in the 'directory' argument and returns the mean of the pollutant across all of the monitors, ignoring any missing values coded as NA. A prototype of the function is as follows

pollutantmean0 <- function(directory, pollutant, id = 1:332) {
  files <- list.files(path = directory, pattern = "*.csv", full.names = T)
  all_means <- vector("numeric", length = length(id))
  for (i in id) {
      df <- read.csv(files[i])
      mean.df <- mean(df[, pollutant], na.rm = TRUE)
      all_means[i] <- mean.df
  }
  mean(all_means, na.rm = TRUE)
}

pollutantmean <- function(directory, pollutant, id = 1:332) {
  files_full <- list.files(path = directory, pattern = "*.csv", full.names = T)
  tmp <- lapply(files_full[id], read.csv)
  dat <- do.call(rbind, tmp)
  mean(dat[, pollutant], na.rm = TRUE)
}

weightmedian <- function(directory, day)  {
  files_list <- list.files(directory, full.names=TRUE)   #creates a list of files
  dat <- data.frame()                             #creates an empty data frame
  for (i in 1:5) {                                
    #loops through the files, rbinding them together 
    dat <- rbind(dat, read.csv(files_list[i]))
  }
  dat_subset <- dat[which(dat[, "Day"] == day),]  #subsets the rows that match the 'day' argument
  median(dat_subset[, "Weight"], na.rm=TRUE)      #identifies the median weight 
  #while stripping out the NAs
}


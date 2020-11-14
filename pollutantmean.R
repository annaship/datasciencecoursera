#  Write a function named 'pollutantmean' that calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors. The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' particulate matter data from the directory specified in the 'directory' argument and returns the mean of the pollutant across all of the monitors, ignoring any missing values coded as NA. A prototype of the function is as follows

# directory <- "/Users/ashipunova/work/data_science_coursera/intro_r/specdata"
# library(magrittr)
# library(readr)

# filenames <- list.files(directory, pattern="*.csv", full.names=TRUE)
# ldf <- lapply(filenames, read.csv)
# res <- lapply(ldf, summary)
# head(ldf[[1]]["ID"])

# useNA == "no"

# > otm6 <- subset(mydata , mydata$Month == 6)
# > mean(otm6$Temp)

# x[!is.na(x) & x > 0]


pollutantmean <- function(directory, pollutant, id = 1:332) {
  files <- list.files(path = directory, pattern = "*.csv", full.names = T)
  print(files[1:3])
  tbl <- sapply(files[1:10], read_csv, simplify=FALSE) %>% bind_rows(.id = "ID")
  
  poll <- tbl[]
  print(tbl[1:3])
}

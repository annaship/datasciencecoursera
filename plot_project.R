file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./data")){ dir.create("./data") }
temp <- tempfile()
download.file(file_url, temp)

file_destination <- "./data/"
file_name <- paste(file_destination, "household_power_consumption.txt", sep = "")

unzip(temp, exdir = file_destination)
unlink(temp)

data_file <- file(file_name, "r")
good_dates <- c("2007-02-01", "2007-02-02")

lines <- c()
while(TRUE) {
  line = readLines(data_file, 1)
  if(length(line) == 0) break
  else if(grepl("^2007-02-01;", line) | grepl("^2007-02-02;", line)) {
    lines <- c(lines, line)
    }
}

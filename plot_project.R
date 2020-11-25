library(stringr)
library(dplyr)
library(lubridate)

# file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# if(!file.exists("./data")){ dir.create("./data") }
# temp <- tempfile()
# download.file(file_url, temp)
#
file_destination <- "./data/"
file_name <- paste(file_destination, "household_power_consumption.txt", sep = "")
#
# unzip(temp, exdir = file_destination)
# unlink(temp)
#
data_file <- file(file_name, "r")
used_dates <- c("2007-02-01", "2007-02-02") %>% 
  ymd() %>%
  format("%e/%m/%Y")

single_digit_used_dates <- gsub("/0", "/", used_dates)

grep_expr_list <- lapply(single_digit_used_dates, function(d) {
  paste("^", trimws(d[1]), ";", sep = "")
})

grep_expr <- str_c(grep_expr_list, sep = "", collapse = "|")

# grep -e "^1/2/2007;\|^2/2/2007;" household_power_consumption.txt | tail

lines <- c()
while(TRUE) {
  line = readLines(data_file, 1)
  # browser()
  if (length(line) == 0) break
  else if(grepl(grep_expr, line)) {
    lines <- c(lines, line)
    }
}

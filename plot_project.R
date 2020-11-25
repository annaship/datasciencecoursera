library(stringr)
library(dplyr)
library(lubridate)
library(stringi)
library(data.table)

# working_dir <- getwd()
file_destination <- "./data/"
file_name <- paste(file_destination, "household_power_consumption.txt", sep = "")

download_data = function() {
  file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  if(!file.exists("./data")){ dir.create("./data") }
  temp <- tempfile()
  download.file(file_url, temp)

  unzip(temp, exdir = file_destination)
  unlink(temp)
}

make_grep_expression = function() {
  used_dates <- c("2007-02-01", "2007-02-02") %>% 
    ymd() %>%
    format("%e/%m/%Y")
  single_digit_used_dates <- gsub("/0", "/", used_dates)
  
  grep_expr_list <- lapply(single_digit_used_dates, function(d) {
    paste("^", trimws(d[1]), ";", sep = "")
  })
  grep_expr <- str_c(grep_expr_list, sep = "", collapse = "|")
  
  # grep -e "^1/2/2007;\|^2/2/2007;" household_power_consumption.txt | tail
  # no NAs
  # ~/work/data_science_coursera/coursera_course/data % grep -e "^1/2/2007;\|^2/2/2007;" household_power_consumption.txt | grep "?" | head                    
  grep_expr
}

read_data = function() {
  data_file <- file(file_name, "r")
  on.exit(close(data_file))
  
  grep_expr <- make_grep_expression()
  lines <- list()
  i <- 1
  
  # Headers
  lines[[i]] <- readLines(data_file, 1)
  i <- i + 1
  
  while(TRUE) {
    line = readLines(data_file, 1)
    # browser()
    if (length(line) == 0) break
    else if(grepl(grep_expr, line)) {
      lines[[i]] <- line
      i <- i + 1
    }
  }
  
  lines
}

clean_data <- function(lines) {
fread(text = paste(lines, collapse='\n')) %>%
  mutate(date_time = mdy_hms(paste(Date, Time)), .keep = "unused") %>% 
  relocate(date_time) %>%
  # str()
  {.} -> my_dataset
  
  my_dataset
}

first_png = function() {
  png(file="plot1.png")
  hist(my_dataset$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
  dev.off()
  # /Users/ashipunova/work/data_science_coursera/coursera_course/plot1.png
}

second_png = function() {
  png(file="plot1.png")
  hist(my_dataset$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
  dev.off()
  # /Users/ashipunova/work/data_science_coursera/coursera_course/plot1.png
}

# __main__

#lines <- read_data()
#my_dataset <- clean_data(lines)
str(my_dataset)
first_png()
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
  mutate(date_time = dmy_hms(paste(Date, Time)), .keep = "unused") %>% 
  relocate(date_time) %>%
  # str()
  {.} -> my_dataset
  
  my_dataset
}

png1 = function() {
  hist(my_dataset$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
  # /Users/ashipunova/work/data_science_coursera/coursera_course/plot1.png
}

png3 = function() {
  with(my_dataset, 
       plot(date_time, Sub_metering_1, 
            type = 'n', 
            ylab = "Energy sub metering",
            xlab = "")
  )
  
  legend("topright", 
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
         col = c("black", "red", "blue"),
         lty = 1
         #,
#         bty = "n"
  )
  
  with(my_dataset,
       lines(date_time, Sub_metering_1, pch = 20))
  
  with(my_dataset,
       lines(date_time, Sub_metering_2, pch = 20, col = "red"))
  
  with(my_dataset,
       lines(date_time, Sub_metering_3, pch = 20, col = "blue"))
}

date_time_graph_w_lines = function(y, xlab = "", ylab = "") {
  plot(my_dataset$date_time, y, 
       type = 'n', 
       xlab = xlab,
       ylab = ylab
  )
  
  lines(my_dataset$date_time, y, pch = 20)
}

png4 = function() {
  par(mfcol = c(2, 2))
  date_time_graph_w_lines(my_dataset$Global_active_power, 
                          ylab = "Global Active Power")
  png3()
  date_time_graph_w_lines(my_dataset$Voltage, 
                          xlab = "datetime", ylab = "Voltage")
  date_time_graph_w_lines(my_dataset$Global_reactive_power, 
                          xlab = "datetime", 
                          ylab = "Global_reactive_power")
}

# __main__

download_data()
lines <- read_data()
my_dataset <- clean_data(lines)
# str(my_dataset)
png(file="plot1.png")
png1()
dev.off()

png(file="plot2.png")
date_time_graph_w_lines(my_dataset$Global_active_power, 
              ylab = "Global Active Power (kilowatts)")
dev.off()

png(file="plot3.png")
png3()
dev.off()

png(file="plot4.png")
png4()
dev.off()


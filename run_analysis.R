file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data")){ dir.create("./data") }
temp <- tempfile()
download.file(file_url, temp)

# str(temp)
#  chr "/var/folders/j4/90zh63717l98153d_0cyw9140000gn/T//RtmpjTkDQv/file739d5cf0f9e1"s

destination <- "./data/Dataset.zip"
arch_info <- unzip(temp, list = FALSE)

d_data <- read.table(unz(temp, "in_data.dat"))
unlink(temp)

download.file(file_url)
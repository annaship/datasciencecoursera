file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data")){ dir.create("./data") }
temp <- tempfile()
download.file(file_url, temp)

# str(temp)
#  chr "/var/folders/j4/90zh63717l98153d_0cyw9140000gn/T//RtmpjTkDQv/file739d5cf0f9e1"

file_destination <- "./data/cleaning_project_data/"

# arch_info <- unzip(temp, list = FALSE)
unzip(temp, exdir = file_destination)
unlink(temp)

# awk '{print NF}' X_train.txt | sort -u
# 561
# 'data.frame':	7352 obs. of  561 variables:

X_train <- read.table(paste(file_destination, "UCI HAR Dataset/train/", "X_train.txt", sep = ""))

X_test <- read.table(paste(file_destination, "UCI HAR Dataset/test/", "X_test.txt", sep = ""))

features <- read.table(paste(file_destination, "UCI HAR Dataset/", "features.txt", sep = ""))

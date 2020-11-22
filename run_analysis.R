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
# list.files(paste(file_destination, "UCI HAR Dataset", sep = ""), recursive = T)

x_train <- read.table(paste(file_destination, "UCI HAR Dataset/train/", "X_train.txt", sep = ""))

y_train <- read.table(paste(file_destination, "UCI HAR Dataset/train/", "y_train.txt", sep = ""))

subject_train <- read.table(paste(file_destination, "UCI HAR Dataset/train/", "subject_train.txt", sep = ""))

x_test <- read.table(paste(file_destination, "UCI HAR Dataset/test/", "X_test.txt", sep = ""))

y_test <- read.table(paste(file_destination, "UCI HAR Dataset/test/", "y_test.txt", sep = ""))

subject_test <- read.table(paste(file_destination, "UCI HAR Dataset/test/", "subject_test.txt", sep = ""))

features <- read.table(paste(file_destination, "UCI HAR Dataset/", "features.txt", sep = ""))

activity_labels <- read.table(paste(file_destination, "UCI HAR Dataset/", "activity_labels.txt", sep = ""))

# rename columns in x sets
## simplify feature names
features$V2 %>% 
  tolower() %>%
  str_replace_all("[^a-z ]+", "_") %>%
  {.} -> feature_names_ok

names(x_test) <- feature_names_ok
names(x_train) <- feature_names_ok

# rename subjects and activities
names(subject_train) <- "subject"
names(subject_test) <- "subject"
names(y_test) <- "activity"
names(y_train) <- "activity"

# TODO: DRY

# combine train set
subject_activity_x_train <- cbind(subject_train, y_train, x_train)

# combine test set
subject_activity_x_test <- cbind(subject_test, y_test, x_test)

## Merge the training and the test sets to create one data set.

full_set <- rbind(subject_activity_x_train, subject_activity_x_test)

# Extract only the measurements on the mean and standard deviation for each measurement.

full_set %>%
  select(matches("_mean_|_std_")) -> mean_std_set




cbind(y_test, subj_activ_x_test) %>%
  setnames(old = "V1", new = "activity") %>%
  {.} -> subj_activ_x_test




# Use descriptive activity names to name the activities in the data set
# Appropriately label the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



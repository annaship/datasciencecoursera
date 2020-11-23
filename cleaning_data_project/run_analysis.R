# download data

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data")){ dir.create("./data") }
temp <- tempfile()
download.file(file_url, temp)

file_destination <- "./data/cleaning_project_data/"

unzip(temp, exdir = file_destination)
unlink(temp)

# load data into R

x_train <- read.table(paste(file_destination, "UCI HAR Dataset/train/", "X_train.txt", sep = ""))

y_train <- read.table(paste(file_destination, "UCI HAR Dataset/train/", "y_train.txt", sep = ""))

subject_train <- read.table(paste(file_destination, "UCI HAR Dataset/train/", "subject_train.txt", sep = ""))

x_test <- read.table(paste(file_destination, "UCI HAR Dataset/test/", "X_test.txt", sep = ""))

y_test <- read.table(paste(file_destination, "UCI HAR Dataset/test/", "y_test.txt", sep = ""))

subject_test <- read.table(paste(file_destination, "UCI HAR Dataset/test/", "subject_test.txt", sep = ""))

features <- read.table(paste(file_destination, "UCI HAR Dataset/", "features.txt", sep = ""))

activity_labels <- read.table(paste(file_destination, "UCI HAR Dataset/", "activity_labels.txt", sep = ""))

# Appropriately label the data set with descriptive variable names.

## rename columns in x sets
### simplify feature names
features$V2 %>% 
  tolower() %>%
  str_replace_all("[^a-z ]+", "_") %>%
  {.} -> feature_names_ok

names(x_test) <- feature_names_ok
names(x_train) <- feature_names_ok

## rename subjects and activities
names(subject_train) <- "subject"
names(subject_test) <- "subject"
names(y_test) <- "activity"
names(y_train) <- "activity"

# Merge the training and the test sets to create one data set.

## Merge train set
subject_activity_x_train <- cbind(subject_train, y_train, x_train)

## Merge test set
subject_activity_x_test <- cbind(subject_test, y_test, x_test)

full_set <- rbind(subject_activity_x_train, subject_activity_x_test)

# Extract only the measurements on the mean and standard deviation for each measurement.

full_set %>%
     select(subject, activity) %>%
     cbind(select(full_set, matches("_mean_|_std_"))) %>%
 {.} -> mean_std_set

# Use descriptive activity names to name the activities in the data set

left_join(mean_std_set, activity_labels, by = c("activity" = "V1")) %>%
  mutate(activity = V2, .after = subject, .keep = "unused") %T>%
  str() %>%
  {.} -> activity_mean_std_set

# From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

activity_mean_std_set %>% 
  group_by(subject, activity) %>%
  summarise(across(everything(), list(mean))) -> all_means

# Write the result into a text file
out_file_name <- paste(file_destination, "/tidy_all_means.txt", sep = "")
write.table(all_means, file = out_file_name, row.name=FALSE)


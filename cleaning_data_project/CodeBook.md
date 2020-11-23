---
title: "CodeBook for Getting and Cleaning Data Course Project"
author: "Anna Shipunova"
date: "11/22/2020"
output:
  html_document: default
  pdf_document: default
---

```{r setup, include=FALSE}
  knitr::opts_chunk$set(tidy = FALSE, eval=FALSE, echo = TRUE)
```

## Data origin

As it is said in the instructions, input data are collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at [the site where the data was obtained](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Work description

Run run_analysis.R script. It will:

    1. Download input dataset

        * To better understand what is in the zip archive we can look inside (this is not in the script):
  
```{r dir1}
    list.files(temp)
```

    2. Unzip files

        * To look at the files run (this is not in the script):

```{r dir2}
  list.files(paste(file_destination, "UCI HAR Dataset", sep = ""), recursive = T)
```

    3. Load each file into separate variables.
        Only the following files were used in this project:
    
```{r files}
#├── ./activity_labels.txt
#├── ./features.txt
#├── ./test
#│   ├── ./test/X_test.txt
#│   ├── ./test/subject_test.txt
#│   └── ./test/y_test.txt
#└── ./train
#    ├── ./train/X_train.txt
#    ├── ./train/subject_train.txt
#    └── ./train/y_train.txts
```

    4. Appropriately label the data set with descriptive variable names.
        1. rename columns in x sets
            1. simplify feature names
        2. rename subjects and activities
      
    5. Merge the training and the test sets to create one data set.
        1. merge the train set
        2. merge the test set
        3. merge both train + test

    6. Extract only the measurements on the mean and standard deviation for each measurement.
    
    7. Use descriptive activity names to name the activities in the data set.
    
    8. From the data set in the previous step, create a second, independent tidy data set with the average of each variable for each activity and each subject.

    





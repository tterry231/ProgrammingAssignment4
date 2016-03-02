##
## Assignment - Getting and Cleaning Data Course Project
##
## Packages required for execution are "dplyr" and "tidyr"
##

library(dplyr)
library(tidyr)

##
## Download and unpackage the dataset
## "UCI HAR Dataset" extracted from downloaded .zip to working directory
##

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("UCI HAR Dataset")) {
    if (!file.exists("UCIHARdata")) {
        dir.create("UCIHARdata")
    }
    download.file(fileUrl, destfile="UCIHARdata/UCIHARData.zip")
    unzip("UCIHARdata/UCIHARData.zip")
}

##
## Section 1 - Merge training and test sets to create one data set
##

##
## Read training data and create merged training data set
##

training_x <- read.table("UCI HAR Dataset//train/X_train.txt", nrows=7352, comment.char="")
training_sub <- read.table("UCI HAR Dataset//train/subject_train.txt", col.names=c("subject"))
training_y <- read.table("UCI HAR Dataset/train//y_train.txt", col.names=c("activity"))

training_data <- cbind(training_x, training_sub, training_y)

##
## Read testing data and create merged testing data set
##

testing_x <- read.table("UCI HAR Dataset//test/X_test.txt", nrows=2947, comment.char="")
testing_sub <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))
testing_y <- read.table("UCI HAR Dataset/test//y_test.txt", col.names=c("activity"))
testing_data <- cbind(testing_x, testing_sub, testing_y)

##
## Merge training and testing data sets
##

merge_data <- rbind(training_data, testing_data)


##
## Section 2 - Extract only the measurements of the mean and standard deviation for each measurement
##

##
## Read features and filter for those with mean or std in name
##

features_list <- read.table("UCI HAR Dataset//features.txt", col.names = c("id", "name"))

features <- c(as.vector(features_list[, "name"]), "subject", "activity")

filtered_features_ids <- grepl("mean|std|subject|activity", features) & !grepl("meanFreq", features)

filtered_data = merge_data[, filtered_features_ids]


##
## Section 3 - Use descriptive activity names in the data set
##

activity_labels <- read.table("UCI HAR Dataset//activity_labels.txt", col.names=c("id", "name"))

for (i in 1:nrow(activity_labels)) {
    filtered_data$activity[filtered_data$activity == activity_labels[i, "id"]] <- as.character(activity_labels[i, "name"])
}


##
## Section 4 - Appropriately label the data set with descriptive variable names
##

filtered_feature_vars <- features[filtered_features_ids]

filtered_feature_vars <- gsub("\\(\\)", "", filtered_feature_vars)
filtered_feature_vars <- gsub("Acc", "-acceleration", filtered_feature_vars)
filtered_feature_vars <- gsub("Mag", "-Magnitude", filtered_feature_vars)
filtered_feature_vars <- gsub("^t(.*)$", "\\1-time", filtered_feature_vars)
filtered_feature_vars <- gsub("^f(.*)$", "\\1-frequency", filtered_feature_vars)
filtered_feature_vars <- gsub("(Jerk|Gyro)", "-\\1", filtered_feature_vars)
filtered_feature_vars <- gsub("BodyBody", "Body", filtered_feature_vars)

filtered_feature_vars <- tolower(filtered_feature_vars)

names(filtered_data) <- filtered_feature_vars


##
## Section 5 - Create independent data set with avg of each variable for each activity and each subject
##

new_tidy_data <- tbl_df(filtered_data) %>%
    group_by(activity, subject) %>%
    summarize_each(funs(mean), -activity, -subject) %>%
    gather(measurement, mean, -activity, -subject)

##
## Save the new tidy table to a text file
##

write.table(new_tidy_data, file="new_tidy_data.txt", row.name=FALSE)



























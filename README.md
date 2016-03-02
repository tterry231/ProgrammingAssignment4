## TAT - UCI Human Activity Recognition Using Smartphones

This project is an exercise in cleaning data from the UCI HAR Datasets.

## Code Summary

# Step 1

* Load the required libraries - dplyr, tidyr
* Download and unzip the compressed dataset if not already present

# Step 2

* Read the training data and create a merged training data set
* Read the testing data and create a merged testing data set
* Merge the training and testing data sets

# Step 3

* Extract the mean and standard deviations for each measurement in the merged data set
* Load the filtered data into a new table

# Step 4

* Replace Activity Labels in data set with descriptive activity names

# Step 5

* Replace Variable Names with descriptive variable names

# Step 6

* Create a new clean data set that summarizes the mean of each variable for each activity and subject
* Save the new data set to a new .txt file for further analysis


## Testing

The script to perform the data cleaning can be run as follows:

source("run_analysis.R")


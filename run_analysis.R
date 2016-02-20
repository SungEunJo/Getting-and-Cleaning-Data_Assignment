## COURSE PROEJECT
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. 
# You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

# A full description is available at the site where the data was obtained: 
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# Here are the data for the project: 
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# 0. Download and upzip the data file

# 1. Merges the training and the test sets to create one data set.
# Read data 
activity_labels <-  read.table("./UCI HAR Dataset/activity_labels.txt")
features <-  read.table("./UCI HAR Dataset/features.txt")    
subject_train <-  read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <-  read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x_test <-  read.table("./UCI HAR Dataset/test/X_test.txt")
y_train <-  read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <-  read.table("./UCI HAR Dataset/test/y_test.txt")

# Merge
subject_all <- rbind(subject_test, subject_train)
x_all <- rbind(x_test, x_train)
y_all <- rbind(y_test, y_train)

# 4. Appropriately labels the data set with descriptive variable names. 
names(subject_all) <- c("subject")
names(x_all) <- features$V2
names(y_all) <- c("activity")

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
x_all  <- x_all[,grepl("mean|std", names(x_all))]
# dim(x_all) # 561 columns to 79 cols

# 3. Uses descriptive activity names to name the activities in the data set
data_all <- cbind(subject_all, y_all, x_all)
data_all$activity <- factor(data_all$activity,activity_labels[[1]],activity_labels[[2]])

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
tidy_data <- aggregate(data_all, by=list(data_all$subject, data_all$activity), FUN=mean)
tidy_data <- subset(tidy_data, select = -c(3,4) ) # drop cols "subject" and "activity"
colnames(tidy_data)[1] <- "subject" # rename col 1
colnames(tidy_data)[2] <- "activity" # rename col 2
tidy_data <- arrange(tidy_data, subject, activity)
write.table(tidy_data, file="tidy_data_all.txt", row.names=FALSE)
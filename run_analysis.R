##__________________________________________________________________________##
## The R script below does the following:

## 1. Merges the training and the test sets to create one data set by
## 2. extracting only the measurements on the mean and standard deviation
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
##__________________________________________________________________________##

## Install required packages to run the current script
install.packages("data.table")
install.packages("reshape2")
require("data.table")
require("reshape2")
##Downlaod datasets in the current working directory
myCurrentWD <- getwd()
dataseturl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataseturl, file.path(myCurrentWD, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

## Read dataset (labels and features)
unzipFolder = "UCI HAR Dataset"
listOfFeatures <- fread(file.path(myCurrentWD, paste0(unzipFolder, "/features.txt")), col.names = c("featureID", "featureName"))

##Prepare the list of measurement needed (Means and Standard deviations only)
#list of features' rows numbers
filteredMeanStdFeatures <- grep("(mean|std)\\(\\)", listOfFeatures[, featureName])
#Select only measurement needed by removing consecutive opening and closing brackets
measurementsNeeded <- listOfFeatures[filteredMeanStdFeatures, featureName]
measurementsNeeded <- gsub('[()]', '', measurementsNeeded)

##-------Prepare train data by selecting only needed variables -----------##
#Load measurement datasets
trainData <- fread(file.path(myCurrentWD, paste0(unzipFolder, "/train/X_train.txt")))[, filteredMeanStdFeatures, with = FALSE]
#Set columns (variables) names
data.table::setnames(trainData, colnames(trainData), measurementsNeeded)
#read train activities
activities_train <- fread(file.path(myCurrentWD, paste0(unzipFolder, "/train/Y_train.txt")), col.names = c("activityID"))
# read train subjects
subjects_train <- fread(file.path(myCurrentWD, paste0(unzipFolder, "/train/subject_train.txt")), col.names = c("subjectID"))
# Merge sujects, activities and measurements data
trainDataset <- cbind(subjects_train, activities_train, trainData)

##-------Prepare test data by selecting only needed variables -----------##
#Load measurement datasets
testData <- fread(file.path(myCurrentWD, paste0(unzipFolder, "/test/X_test.txt")))[, filteredMeanStdFeatures, with = FALSE]
#Set columns (variables) names
data.table::setnames(testData, colnames(testData), measurementsNeeded)
#read test activities
activities_test <- fread(file.path(myCurrentWD, paste0(unzipFolder, "/test/Y_test.txt")), col.names = c("activityID"))
# read test subjects
subjects_test <- fread(file.path(myCurrentWD, paste0(unzipFolder, "/test/subject_test.txt")), col.names = c("subjectID"))
# Merge sujects, activities and measurements data
testDataset <- cbind(subjects_test, activities_test, testData)

## 1. Merges the training and the test datasets.
MergedDataset <- rbind(trainDataset, testDataset)

## 2. Uses descriptive activity names to name the activities in the data set
listOfActivities <- fread(file.path(myCurrentWD, paste0(unzipFolder, "/activity_labels.txt")), col.names = c("activityID", "activityName"))
MergedDataset[["activityID"]] <- factor(MergedDataset[, activityID], levels = listOfActivities[["activityID"]], labels = listOfActivities[["activityName"]])

# Rename activityID column name to Activity
colnames(MergedDataset)[colnames(MergedDataset)=="activityID"] <- "activity"

## 4. Appropriately labels the data set with descriptive variable names.
names(MergedDataset)<-gsub("tBodyAcc-","Body.Acceleration.Time",names(MergedDataset))
names(MergedDataset)<-gsub("tBodyAccMag-","Body.Acceleration.Time.FourierTransform",names(MergedDataset))
names(MergedDataset)<-gsub("tBodyAccJerk-","Body.Acceleration.Jerk.Time",names(MergedDataset))
names(MergedDataset)<-gsub("tBodyAccJerkMag-","Body.Acceleration.Jerk.FourrierTransform",names(MergedDataset))
names(MergedDataset)<-gsub("tGravityAcc-","Gravity.Acceleration.Time",names(MergedDataset))
names(MergedDataset)<-gsub("tGravityAccMag-","Gravity.Acceleration.Time.FourierTransform",names(MergedDataset))
names(MergedDataset)<-gsub("tBodyGyro-","Body.Acceleration.Time.Gyroscope",names(MergedDataset))
names(MergedDataset)<-gsub("tBodyGyroMag-","Body.Acceleration.Time.FourrierTransform.Gyroscope",names(MergedDataset))
names(MergedDataset)<-gsub("tBodyGyroJerk-","Body.Acceleration.Jerk.Time.Gyroscope)",names(MergedDataset))
names(MergedDataset)<-gsub("tBodyGyroJerkMag-","Body.Acceleration.Jerk.Time.FourrierTransform.Gyroscope",names(MergedDataset))
names(MergedDataset)<-gsub("fBodyAcc-","Body.Acceleration.Frequence",names(MergedDataset))
names(MergedDataset)<-gsub("fBodyAccMag-","Body.Acceleration.Frequence.FourierTransform",names(MergedDataset))
names(MergedDataset)<-gsub("fBodyAccJerk-","Body.Acceleration.Jerk.Frequence",names(MergedDataset))
names(MergedDataset)<-gsub("fBodyGyro-","Body.Acceleration.Frequence.Gyroscope",names(MergedDataset))
names(MergedDataset)<-gsub("fBodyAccJerkMag-","Body.Acceleration.Jerk.Frequence.FourrierTransform",names(MergedDataset))
names(MergedDataset)<-gsub("fBodyGyroMag-","Body.Acceleration.Frequence.FourierTransform.Gyroscope",names(MergedDataset))

names(MergedDataset)<-gsub("fBodyBodyAccJerkMag-","Estimated.Body.Jerk.Acceleration.Frequence.FourrierTransform",names(MergedDataset))
names(MergedDataset)<-gsub("fBodyBodyGyroJerkMag-","Estimated.Body.Jerk.Acceleration.Frequence.Gyroscope.FourrierTransform",names(MergedDataset))
names(MergedDataset)<-gsub("fBodyBodyGyroMag-","Estimated.Body.Acceleration.Frequence.Gyroscope.FourierTransform",names(MergedDataset))

names(MergedDataset)<-gsub("mean", "-Mean", names(MergedDataset))
names(MergedDataset)<-gsub("std", "-Standard.Deviation", names(MergedDataset))


## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
MergedDataset[["subjectID"]] <- as.factor(MergedDataset[, subjectID])
MergedDataset_GroupedBy <- reshape2::melt(data = MergedDataset, id = c("subjectID", "activity"))
MergedDataset_Averages <- reshape2::dcast(data = MergedDataset_GroupedBy, subjectID + activity ~ variable, fun.aggregate = mean)
#Add the suffix 'Average-' before each variable name except 2 first (Subject, Activity)
names(MergedDataset_Averages)[3:68]<-paste0("Average-", names(MergedDataset_Averages)[3:68])

## Write tidy data set to a file on disk
data.table::fwrite(x = MergedDataset_Averages, file = "independentTidyDataset.csv", quote = FALSE)
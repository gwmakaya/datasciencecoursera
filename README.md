Getting and cleaning data: Description of script in run_analysis.R file"
====

The R script you will find in the file run_analysis.R does the following:

## Install required packages to run the current script
## Downlaod datasets in the current working directory
## Read dataset (labels and features)
## Prepare the list of measurement needed (Means and Standard deviations only)
## Select only measurement needed by removing consecutive opening and closing brackets
## Prepare train data by selecting only needed variables

```
Load train measurement datasets
Read train activities
Read train subjects
Merge train sujects, activities and measurements data
```

## Prepare test data by selecting only needed variables
```
Load test measurement datasets
Read test activities
Read test subjects
Merge test sujects, activities and measurements data
```

## Address project's requested activities
```
1. Merges the training and the test datasets.
2. Extract only the measurements on the mean and standard deviation
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
6. Write tidy data set to a file named independentTidyDataset.csv on disk in the current working directory.
```

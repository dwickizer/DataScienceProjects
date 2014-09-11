## Function run_analysis()
##
## A function which processes Samsung Galaxy S accelerometer and gyro data from the following 
## Source:
##
## Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.,
## Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support 
## Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). 
## Vitoria-Gasteiz, Spain. Dec 2012

## It accomplishes the following steps:

## Step 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average 
##    of each variable for each activity and each subject.

## Dale Wickizer 09/06/2014

run_analysis <- function () {
    
    ## Merge the training and the test sets to create one data set.
    
    ##  Start with Subject Data:
    
    ##  Transform and concatentate
    
    subjTestDat <- read.table("./UCI HAR Dataset/test/subject_test.txt") ## Read in test subjects
    subjTestDat <- as.character(subjTestDat[,1])   ## Transform dataframe to character vector
    
    subjTrainDat <- read.table("./UCI HAR Dataset//train//subject_train.txt") ## Read train subjects
    subjTrainDat <- as.character(subjTrainDat[,1])   ## Transform dataframe to character vector
    
    Subject <- c(subjTestDat, subjTrainDat)       ## Concatenate Subject data, test then train
 
    Subject <- as.character(Subject) ## Change to a unit vector
    Subject <- data.frame(Subject)   ## Create a single column data frame, with "Subject" as factor
    
    
    ##  Next get combine the Activity data:
    
    ##  Transform and concatentate
    
    actTestDat <- read.table("./UCI HAR Dataset//test/y_test.txt")     ## Read in test activity 
    actTestDat <- as.character(actTestDat[,1])   ## Transform dataframe to character vector
    
    actTrainDat <- read.table("./UCI HAR Dataset//train//y_train.txt") ## Read in train activity
    actTrainDat <- as.character(actTrainDat[,1]) ## Transform dataframe to character vector
    
    Activity <- c(actTestDat, actTrainDat)       ## Concatenate Activity data, test then train
    
    ## Relabel the activity data using user friendly names:
    
    Activity <- lapply(Activity, function(x) {switch(x, "1" = x <- "WALK", 
                                                        "2" = x <- "UPSTAIRS", 
                                                        "3" = x <- "DOWNSTAIRS", 
                                                        "4" = x <- "SIT", 
                                                        "5" = x <- "STAND", 
                                                        "6" = x <- "LAY" ) })
    
    Activity <- as.character(Activity) ## Change to a unit vector
    Activity <- data.frame(Activity)   ## Create a single column data frame, with "Activity" as factor
    
    return (data.frame(Subject, Activity))
    
    ## Next combine test and training measurements (561 columns)
    
    
    
    ## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    ## 3. Uses descriptive activity names to name the activities in the data set
    ## 4. Appropriately labels the data set with descriptive variable names. 
    ## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
    
}




# Function run_analysis(lean, tidyOut)
#
# A function which processes Samsung Galaxy S accelerometer and gyro data from the following 
# Source:
#
# Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.,
# Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support 
# Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). 
# Vitoria-Gasteiz, Spain. Dec 2012

# The parameter "lean" (the default) cleans up memory as the program executes. Make FALSE for debug.
# When it is FALSE it will also dump the interim allData data table.
#
# The parameter "tidyOut, if TRUE (default), outputs the tidy dataset to a file. Otherwise it 
# returns the tidyData data table.

# It accomplishes the following steps:

# Step  1. Uses descriptive activity names to name the activities in the data set
#       2. Merges the training and the test sets to create one data set.
#       3. Extracts only the measurements on the mean and standard deviation for each measurement. 
#       4. Appropriately labels the data set with descriptive variable names. 
#       5. From the data set in step 4, creates a second, independent tidy data set with the average 
#          of each variable for each activity and each subject.

# Dale Wickizer 09/12/2014

run_analysis <- function (lean = TRUE, tidyOut = TRUE) {
    
    library (utils)
    library (dplyr)
    
    # Steps 1. and 2a
    
    # Start with Subject Data:
    
    # Transform and concatentate
    
    # Read in test subjects
    subjTestDat <- read.table("./UCI HAR Dataset/test/subject_test.txt", colClasses = "numeric") 
    
    # Read train subjects
    subjTrainDat <- read.table("./UCI HAR Dataset//train//subject_train.txt", colClasses = "numeric") 
    
    Subject <- rbind(subjTestDat, subjTrainDat) # Concatenate Subject data, test then train   
    
    if (lean) rm (subjTestDat, subjTrainDat) # Free up memory
    
    Subject$Subject = Subject [,1] # Add a new column with "Subject" as the column name
    
    #  Next get combine the Activity data:
    
    #  Transform and concatentate
    
    actTestDat <- read.table ("./UCI HAR Dataset/test/y_test.txt")    # Read in test activity 
    
    actTrainDat <- read.table ("./UCI HAR Dataset/train/y_train.txt") # Read in train activity
    
    Activity <- rbind (actTestDat, actTrainDat)       # Concatenate Activity data, test then train
    
    if (lean) rm (actTestDat, actTrainDat) # Free up memory
    
    # Relabel the activity data using user friendly names:
    
    Activity$Activity <- lapply (Activity [,1], function (x) {switch (x, "1" = x <- "WALK", 
                                                                         "2" = x <- "UPSTAIRS", 
                                                                         "3" = x <- "DOWNSTAIRS", 
                                                                         "4" = x <- "SIT", 
                                                                         "5" = x <- "STAND", 
                                                                         "6" = x <- "LAY" ) } )
    
    # Create a single column lists of the Subject and Activity data frames
    Subject <- as.numeric (Subject$Subject)
    Activity <- as.character (Activity$Activity)
    
    # Create a dataframe with "Activity" and "Subject"m as colnames and user friendly activity labels
    dataFrame1 <- data.frame (Activity, Subject) 
    
    if (lean) rm (Activity, Subject) # Free up memory
    
    # Steps 2b and 3
    
    # Next combine test and training measurements (Yikes!!! 561 columns)    
    testData <- read.table ("./UCI HAR Dataset//test/X_test.txt")
    trainData <- read.table ("./UCI HAR Dataset//train/X_train.txt")
    
    # 2. Extract only the measurements on the mean and standard deviation for each measurement.
    
    # Let's figure out the indexes of the columes we want
    
    features <- read.table ("./UCI HAR Dataset/features.txt")
    means <- grep ("mean", features [,2])
    devs <- grep ("std", features [,2])
    
    means_n_devs <- sort (c (means,devs))
    
    features <- features [means_n_devs,] # Only keep the features we want (means n devs)
    
    # Shrink down and concatenate the big datasets
    testData <- testData [, means_n_devs]
    trainData <- trainData [, means_n_devs]
    
    # Concatenate to give us a combined dataframe with non-useful labels
    dataFrame2 <- rbind (testData, trainData)
    
    if (lean) rm (testData, trainData, means, devs, means_n_devs) # Free up memory
    
    
    # 4. Appropriately labels the data set with descriptive variable names. 
    
    # Write out a temporary file to strip row and colunm names
    write.table (dataFrame2, "./tmp.dat", row.names = FALSE, col.names = FALSE)
    
    # Read it back in and supply the feature labels as a col.names vector
    dataFrame2 <- read.table ("./tmp.dat", col.names = features[,2])
    
    if (lean) rm (features) # free up memory
    file.remove ("./tmp.dat") # clean up temp file
    
    # Combine both data frames for the complete, formatted dataset, sorted by Activity and Subject
    allData <- arrange (data.frame(dataFrame1, dataFrame2), Activity, Subject)
    
    if (lean) rm (dataFrame1, dataFrame2) # free up memory
    
    if (!lean) {  # For debug purposes only, spit out a file of allData
        write.table (allData, "./Tidy_Raw_Samsung_Data.txt", row.names = FALSE)
    }
    
    # 5. From the data set in step 4, create a second, independent tidy data set with the average
    # of each variable for each activity and each subject.
    
    # First group everything by Activity then by Subject (Thank you Swirl Lessons!)
    
    byActSub <- allData %>% group_by (Activity, Subject)
    
    # Then create the tidy dataset
    
    tidyData <- byActSub %>% summarise_each (funs (mean))
    
    if (tidyOut) {
        write.table (tidyData, "./Tidy_Samsung_Data_Averages_by_Activity_and_Subject.txt", row.names = FALSE)
    } 
    else {
        return(tidyData)
    }
}





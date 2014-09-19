# README.md#

#### Author: Dale Wickizer ###
#### Date: September 12, 2014 ###


### Purpose: ###

This document summarizes the operation of function, called **run\_analysis.R**, which is used to process raw Samsung Galaxy S accelerometer, gyro and descriptive datasets from the following source:

	Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz., Human Activity 
	Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International 
	Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain, Dec 2012.

The resulting output is tidy dataset called **Tidy\_Samsung\_Data\_Averages\_by\_Activity\_and\_Subject.txt**, which contains averages for the Samsung data measurements by Activity and Subject.


### Program Execution ###

The file **run\_analysis.R** contains a single function by that name, **run\_analysis()**. The function accepts two optional Boolean parameters, **lean** and **tidyOut**, whose defaults are both **TRUE**.

To run the function: 

_source ("run\_analysis.R")_  
_run\_analysis (lean = TRUE, tidyOut = TRUE)_ 

or, just _run\_analysis ()_ to accept defaults.

#### Optional Parameters ####

* **lean = TRUE:** The program runs with as lean a memory footprint as possible, freeing up space as it executes.

* **lean = FALSE:** Useful for debug operations. When FALSE, all the variables remain memory resident for inspect. Additionally, a raw tidy version of the original data, called **Tidy\_Raw\_Samsung\_Data.txt** is output into the local directory.

* **tidyOut = TRUE:** A data file is written out containing the final product called **Tidy\_Samsung\_Data\_Averages\_by\_Activity\_and\_Subject.txt**. This file contains averages per activity and per subject ID, for 79 columns of Samsung measurement data.

* **tidyOut = FALSE:** Useful for debugging. Instead of writing the file the program returns the final data table which can be analyzed.

#### Assumptions ####

* The program is assumed to reside in the same directory as the the **UCI HAR Dataset** directory, which contains the original Samsung data.  

* The program makes use of the **dplyr** package and library. If that package is not installed, use _install.packages ("dplyr")_ to install it.


### Program Design ###

#### The program accomplishes the following steps using roughly 45 lines of executable R code: #####

##### 1. Uses descriptive activity names to name the activities in the data set #####

* It does this by reading in and combining the Activity and Subject ID information from the test and training datasets using the *read.table ()* function. The test and train data for each is combined using *rbind ()*:

	    # Read in test subjects
	    subjTestDat <- read.table("./UCI HAR Dataset/test/subject_test.txt", colClasses = "numeric") 
		
	    # Read train subjects
	    subjTrainDat <- read.table("./UCI HAR Dataset//train//subject_train.txt", colClasses = "numeric") 
		
		Subject <- rbind(subjTestDat, subjTrainDat) # Concatenate Subject data, test then train 
		
		...  
		  
		#  Next get combine the Activity data:
		
		actTestDat <- read.table ("./UCI HAR Dataset/test/y_test.txt")    # Read in test activity 
		
		actTrainDat <- read.table ("./UCI HAR Dataset/train/y_train.txt") # Read in train activity
		
		Activity <- rbind (actTestDat, actTrainDat)       # Concatenate Activity data, test then train
		


* Activity IDs are replaced by edited descriptive names using _lapply ()_ and an embedded function using a _switch ()_ statement, which is computationally faster than *for* or *while* loops in R. The resulting character and numeric vectors are combined into a single data frame, called **dataFrame1**, with 2 columns and 10,299 rows. I choose to simplify the labels in the switch statement. 
    

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

##### 2. Merges the training and the test sets to create one data set. #####

* In the same manner, the raw test and training measurements are read in using *read.table ()* and combined into one massive dataframe that is 561 columns by 10,299 observations (rows). This is eventuallay stored in a 2nd data frame (**dataFrame2**) using the *rbind ()* function. But before doing that, this data will be pared down as described in the next step. 
	  
	    testData <- read.table ("./UCI HAR Dataset//test/X_test.txt")
	    trainData <- read.table ("./UCI HAR Dataset//train/X_train.txt")

##### 3. Extracts only the measurements on the mean and standard deviation for each measurement. #####

* We perform two searches through the features.txt file using _grep ()_, looking for column names and their IDs, which contain either means or standard deviations (std). 

		features <- read.table ("./UCI HAR Dataset/features.txt")
	    means <- grep ("mean", features [,2])
	    devs <- grep ("std", features [,2])
		
	

* We use the resulting combined list called **means\_n\_devs** to subset the columns of the test and training data first, as well as a character vector called **features**, containing the column labels we want (to be used in Step 4).

	    means_n_devs <- sort (c (means,devs))
		
	    features <- features [means_n_devs,] # Only keep the features we want (means n devs)
		
	    # Shrink down and concatenate the big datasets
	    testData <- testData [, means_n_devs]
	    trainData <- trainData [, means_n_devs]
		


* The shrunken datasets are now stored in another interim data frame, called **dataFrame2**, using *rbind ()*.
	 
	    dataFrame2 <- rbind (testData, trainData)


##### 4. Appropriately labels the data set with descriptive variable names. #####

* We write out **dataFrame2** to a temporary file, using _write.table ()_ with **row.names** and **col.names** set to **FALSE** (clearing the row and column names). 

	    write.table (dataFrame2, "./tmp.dat", row.names = FALSE, col.names = FALSE)


* We read in the data frame using _read.table ()_, setting **colClasses** = **features**.  This gives us the proper column labels

	    dataFrame2 <- read.table ("./tmp.dat", col.names = features[,2])


* Lastly, we combine **dataFrame1** (containing the labels and subject IDs) and **dataFrame2** (containing the measurements) into one data table called **allData**, which is then arranged by Activity, then by Subject IDs using the _arrange ()_ command.

	    allData <- arrange (data.frame(dataFrame1, dataFrame2), Activity, Subject)
    

* If **lean** is set to **FALSE** at program execution, then this data table is written out to a file called **Tidy\_Raw\_Samsung\_Data.txt** for debuggging and other purposes.  

	    if (!lean) {  # For debug purposes only, spit out a file of allData
	        write.table (allData, "./Tidy_Raw_Samsung_Data.txt", row.names = FALSE)
	    }


* **NOTE:** I found it helpful to import this tidy, raw data file into an Excel spreadsheet and create a pivot table as model of what I expected to see in the next step. 


##### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. #####

* This is accomplished by first grouping the **allData** data table, first by Activity and then by Subject ID, using the **%>%** chaining operator.


		byActSub <- allData %>% group_by (Activity, Subject)


* The result of that operation, then serves and the input chain to _summarise_each()_ command, using the **_funs (means)_** as the function argument. This performs an amazing bit of magic which takes the mean of every column for each Activity and each Subject ID.  The result is stored in a data table called **tidyData**. 

		tidyData <- byActSub %>% summarise_each (funs (mean))


* The **tidyData** data table is then written out to a file, which serves as the final product: **Tidy\_Samsung\_Data\_Averages\_by\_Activity\_and\_Subject.txt**.

* **NOTE:** If the Boolean parameter, **tidyOut** is set to **FALSE** at runtime execution, then the above file is NOT saved. Instead, the **tidyData** data table is returned for analysis.

	    if (tidyOut) {
	        write.table (tidyData, "./Tidy_Samsung_Data_Averages_by_Activity_and_Subject.txt", row.names = FALSE)
	    } 
	    else {
	        return(tidyData)
	    }


### Data Input / Output Information ###

* Information about the data inputs and outputs, as well as information about other files in the project repository, can be found in the original **./UCI HAR Dataset/features_info.txt** code book and in the **CodeBook.md** file for this project.



# CookBook.md#

#### Author: Dale Wickizer ###
#### Date: September 12, 2014 ###



### About the Raw Data Inputs ###

The raw Samsung datasets are in a subdirectory called **UCI HAR Dataset**, which can be found in this directory that contains this file.

That directory contains the following data files:

**./UCI HAR Database/**

* **./activity\_labels.txt:** A file containing a table of descriptive activity labels and their integer IDs. _The program does NOT use this file._ (See details in next section.)

* **./features\_info.txt:** A file serving as the Code Book for the original data. It describes at a high level how the measurements were taken and values calculated from those measurements.

* **./features.txt:** A file a table of descriptive activity labels and their integer IDs for 561 columns of data. _The program uses this file._

* **./README.txt:** The README file for the original data set, explaining the background of the experiment and providing licensing information for use of the dataset.

**./UCI HAR Database/test/** A directory of test data (30% of the total dataset)

* **./Inertial Signals:** A subdirectory containing the original accelerometer and gyro test data. _This data is NOT used._

* **./subject\_test.txt:** A file containing a numeric vector of the subject IDs, one for each of the 2,947 test observations. _The program uses this file._

* **./X\_test.txt:** A file containing a numeric table of 561 columns with 2,947 test observations (rows). These are the original accelerometer and gyro measures in 3-dimensions, along with numerous derived values (such as mean, standard deviation, energy, frequency, etc.). _The program uses this file._ Each row of the data file contains the observations for these column variables. The values are bounded between -1. and +1.

* **./y\_test.txt:** A file containing a numeric vector of the activity IDs, one for each of the 2,947 test observations. _The program uses this file._

**./UCI HAR Database/train/** A directory of training data (70% of the total dataset)

* **./Inertial Signals:** A subdirectory containing the original accelerometer and gyro training data. _This data is NOT used._

* **./subject\_train.txt:** A file containing a numeric vector of the subject IDs, one for each of the 7,352 training observations. _The program uses this file._

* **./X\_train.txt:** A file containing a numeric table of 561 columns with 7,352 training observations (rows). These are the original accelerometer and gyro measures in 3-dimensions, along with numerous derived values (such as mean, standard deviation, energy, frequency, etc.). _The program uses this file._  As mentioned above, each row of the data file contains the observations for these column variables. The values are bounded between -1. and +1.

* **./y\_train.txt:** A file containing a numeric vector of the activity IDs, one for each of the 7,352 training observations. _The program uses this file._



### The Cooked Data ###

#### The Activity Labels ####

Since there were only 6 values, rather than reading in the **activity\_labels.txt** file and figuring out how to apply what was read in, it was simpler to add them in a _switch ()_ statement that gets applied to the data using _lapply ()_. The labels were edited slightly. The actual indexes and labels used within the program were:

		"1" = x <- "WALK", 
		"2" = x <- "UPSTAIRS", 
		"3" = x <- "DOWNSTAIRS",
		"4" = x <- "SIT", 
		"5" = x <- "STAND", 
		"6" = x <- "LAY"


#### The Feature Labels ####

All 561 feature labels and their indexes were read from the **feature.txt** file. Out of the 561 feature labels, we selected only those for the mean and standard deviation per the instructions. It was decided to use measured and derived data, including the Mean Frequency data, for completeness. (It is always simpler to go back and further pare down the data.) The program uses the _grep ()_ function to search and select the appropriate labels with either "mean" or "std" in the name.  The following indexes and labels are the ones which were selected:


	  Index            Label					                            Description
	
	    1        "tBodyAcc-mean()-X"			Time domain mean body acceleration along the x-axis
	    2        "tBodyAcc-mean()-Y"			Time domain mean body acceleration along the y-axis
	    3        "tBodyAcc-mean()-Z"			Time domain mean body acceleration along the z-axis
	    4        "tBodyAcc-std()-X"	    		Time domain standard deviation of body acceleration along the x-axis
	    5        "tBodyAcc-std()-Y"				Time domain standard deviation of body acceleration along the y-axis
	    6        "tBodyAcc-std()-Z"				Time domain standard deviation of body acceleration along the z-axis
	   41        "tGravityAcc-mean()-X"			Time domain mean acceleration due to gravity along the x-axis
	   42        "tGravityAcc-mean()-Y"			Time domain mean acceleration due to gravity along the y-axis
	   43        "tGravityAcc-mean()-Z"			Time domain mean acceleration due to gravity along the z-axis
	   44        "tGravityAcc-std()-X"			Time domain standard devition of acceleration due to gravity along the x-axis
	   45        "tGravityAcc-std()-Y"			Time domain standard devition of acceleration due to gravity along the y-axis
	   46        "tGravityAcc-std()-Z"			Time domain standard devition of acceleration due to gravity along the z-axis
	   81        "tBodyAccJerk-mean()-X"		Time domain mean jerk (derivative of acceleration) along the x-axis
	   82        "tBodyAccJerk-mean()-Y"		Time domain mean jerk (derivative of acceleration) along the y-axis
	   83        "tBodyAccJerk-mean()-Z"		Time domain mean jerk (derivative of acceleration) along the y-axis
	   84        "tBodyAccJerk-std()-X"			Time domain standard deviation of jerk (derivative of acceleration) along the x-axis
	   85        "tBodyAccJerk-std()-Y"			Time domain standard deviation of jerk (derivative of acceleration) along the y-axis
	   86        "tBodyAccJerk-std()-Z"			Time domain standard deviation of jerk (derivative of acceleration) along the z-axis
	  121        "tBodyGyro-mean()-X"
	  122        "tBodyGyro-mean()-Y"
	  123        "tBodyGyro-mean()-Z"
	  124        "tBodyGyro-std()-X"
	  125        "tBodyGyro-std()-Y"
	  126        "tBodyGyro-std()-Z"
	  161        "tBodyGyroJerk-mean()-X"
	  162        "tBodyGyroJerk-mean()-Y"
	  163        "tBodyGyroJerk-mean()-Z"
	  164        "tBodyGyroJerk-std()-X"
	  165        "tBodyGyroJerk-std()-Y"
	  166        "tBodyGyroJerk-std()-Z"
	  201        "tBodyAccMag-mean()"
	  202        "tBodyAccMag-std()"
	  214        "tGravityAccMag-mean()"
	  215        "tGravityAccMag-std()"
	  227        "tBodyAccJerkMag-mean()"
	  228        "tBodyAccJerkMag-std()"
	  240        "tBodyGyroMag-mean()"
	  241        "tBodyGyroMag-std()"
	  253        "tBodyGyroJerkMag-mean()"
	  254        "tBodyGyroJerkMag-std()"
	  266        "fBodyAcc-mean()-X"
	  267        "fBodyAcc-mean()-Y"
	  268        "fBodyAcc-mean()-Z"
	  269        "fBodyAcc-std()-X"
	  270        "fBodyAcc-std()-Y"
	  271        "fBodyAcc-std()-Z"
	  294        "fBodyAcc-meanFreq()-X"
	  295        "fBodyAcc-meanFreq()-Y"
	  296        "fBodyAcc-meanFreq()-Z"
	  345        "fBodyAccJerk-mean()-X"
	  346        "fBodyAccJerk-mean()-Y"
	  347        "fBodyAccJerk-mean()-Z"
	  348        "fBodyAccJerk-std()-X"
	  349        "fBodyAccJerk-std()-Y"
	  350        "fBodyAccJerk-std()-Z"
	  373        "fBodyAccJerk-meanFreq()-X"
	  374        "fBodyAccJerk-meanFreq()-Y"
	  375        "fBodyAccJerk-meanFreq()-Z"
	  424        "fBodyGyro-mean()-X"
	  425        "fBodyGyro-mean()-Y"
	  426        "fBodyGyro-mean()-Z"
	  427        "fBodyGyro-std()-X"
	  428        "fBodyGyro-std()-Y"
	  429        "fBodyGyro-std()-Z"
	  452        "fBodyGyro-meanFreq()-X"
	  453        "fBodyGyro-meanFreq()-Y"
	  454        "fBodyGyro-meanFreq()-Z"
	  503        "fBodyAccMag-mean()"
	  504        "fBodyAccMag-std()"
	  513        "fBodyAccMag-meanFreq()"
	  516        "fBodyBodyAccJerkMag-mean()"
	  517        "fBodyBodyAccJerkMag-std()"
	  526        "fBodyBodyAccJerkMag-meanFreq()"
	  529        "fBodyBodyGyroMag-mean()"
	  530        "fBodyBodyGyroMag-std()"
	  539        "fBodyBodyGyroMag-meanFreq()"
	  542        "fBodyBodyGyroJerkMag-mean()"
	  543        "fBodyBodyGyroJerkMag-std()"
	  552        "fBodyBodyGyroJerkMag-meanFreq()"


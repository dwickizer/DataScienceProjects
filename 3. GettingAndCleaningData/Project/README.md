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

_source _("run\_analysis.R")_  
_run\_analysis _(lean = TRUE, tidyOut = TRUE)_ 

or, just _run\_analysis _()_ to accept defaults.

#### Optional Parameters ####

* **lean = TRUE:** The program runs with as lean a memory footprint as possible, freeing up space as it executes.

* **lean = FALSE:** Useful for debug operations. When FALSE, all the variables remain memory resident for inspect. Additionally, a raw tidy version of the original data, called **Tidy\_Raw\_Samsung\_Data.txt** is output into the local directory.

* **tidyOut = TRUE:** A data file is written out containing the final product called **Tidy\_Samsung\_Data\_Averages\_by\_Activity\_and\_Subject.txt**. This file contains averages per activity and per subject ID, for 79 columns of Samsung measurement data.

* **tidyOut = FALSE:** Useful for debugging. Instead of writing the file the program returns the final data table which can be analyzed.

#### Assumptions ####

* The program is assumed to reside in the same directory as the the **UCI HAR Dataset** directory, which contains the original Samsung data.  

* The program makes use of the **dplyr** package and library. If that package is not installed, use _install.packages ("dplyr")_ to install it.


### Program Design ###

#### The program accomplishes the following steps: #####

##### 1. Uses descriptive activity names to name the activities in the data set #####

* It does this by reading in and combining the Activity and Subject ID information from the test and training datasets (described below and in the Code Book). Activity IDs are replaced by edited descriptive names. The resulting character and numeric vectors are combined into a single data frame, called **dataFrame1**, with 2 columns and 10,299 rows.

##### 2. Merges the training and the test sets to create one data set. #####

* In the same manner, the raw test and training measurements are combined into one massive dataframe that is 561 columns by 10,299 observations (rows). We store this in a 2nd data frame (**dataFrame2**). This data will be pared down as described in the next step. 

##### 3. Extracts only the measurements on the mean and standard deviation for each measurement. #####

* We perform two searches through the features.txt file using _grep ()_, looking for column names and their IDs, which contain either means or standard deviations (std). We use the resulting combinedcombined list called **means\_n\_devs** to pare down the columns of **dataFrame2** as well as a character vector called **features**, containing the column labels we want.

##### 4. Appropriately labels the data set with descriptive variable names. #####

* We write out **dataFrame2** to a temporary file, using _write.table ()_ with **row.names** and **col.names** set to **FALSE** (clearing the row and column names). 

* We read in the data frame using _read.table ()_, setting **colClasses** = **features**.  This gives us the proper column labels

* Lastly, we combine **dataFrame1** (containing the labels and subject IDs) and **dataFrame2** (containing the measurements) into one data table called **allData**, which is then arranged by Activity, then by Subject IDs using the _arrange ()_ command.

* If **lean** is set to **FALSE** at program execution, then this data table is written out to a file called **Tidy\_Raw\_Samsung_Data.txt**.  **NOTE:** I found it helpful to import this tidy, raw data file into an Excel spreadsheet and create a pivot table as model of what I expected to see in the next step. 

##### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. #####

* This is accomplished by first grouping the **allData** data table, first by Activity and then by Subject ID, using the **%>%** chaining operator.

* The result of that operation, then serves and the input chain to _summarise_each()_ command, using the **_funs (means)_** as the function argument. This performs an amazing bit of magic which takes the mean of every column for each Activity and each Subject ID.  The result is stored in a data table called **tidyData**. 

* The **tidyData** data table is then written out to a file, which serves as the final product: **Tidy\_Samsung\_Data\_Averages\_by\_Activity\_and\_Subject.txt**.

* **NOTE:** If the Boolean parameter, **tidyOut** is set to **FALSE** at runtime execution, then the above file is NOT saved. Instead, the **tidyData** data table is returned for analysis.





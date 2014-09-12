# CookBook.md#

#### Author: Dale Wickizer ###
#### Date: September 12, 2014 ###



### About the Raw Input Data ###

The raw Samsung datasets are in a subdirectory called **UCI HAR Dataset**, which can be found in this directory that contains this README.md file.

That directory contains the following data files:

**./UCI HAR Database/**

* **./activity\_labels.txt:** A file containing a table of descriptive activity labels and their integer IDs. _The program uses this file._

* **./features\_info.txt:** A file serving as the Code Book for the original data. It describes at a high level how the measurements were taken and values calculated from those measurements.

* **./features.txt:** A file a table of descriptive activity labels and their integer IDs for 561 columns of data. _The program uses this file._

* **./README.txt:** The README file for the original data set, explaining the background of the experiment and providing licensing information for use of the dataset.

**./UCI HAR Database/test/** A directory of test data (30% of the total dataset)

* **./Inertial Signals:** A subdirectory containing the original accelerometer and gyro test data. _This data is not used._

* **./subject\_test.txt:** A file containing a numeric vector of the subject IDs, one for each of the 2,947 test observations. _The program uses this file._

* **./X\_test.txt:** A file containing a numeric table of 561 columns with 2,947 test observations (rows). These are the original accelerometer and gyro measures in 3-dimensions, along with numerous derived values (such as mean, standard deviation, energy, frequency, etc.). _The program uses this file._

* **./y\_test.txt:** A file containing a numeric vector of the activity IDs, one for each of the 2,947 test observations. _The program uses this file._

**./UCI HAR Database/train/** A directory of training data (70% of the total dataset)

* **./Inertial Signals:** A subdirectory containing the original accelerometer and gyro training data. _This data is not used._

* **./subject\_train.txt:** A file containing a numeric vector of the subject IDs, one for each of the 7,352 training observations. _The program uses this file._

* **./X\_train.txt:** A file containing a numeric table of 561 columns with 7,352 training observations (rows). These are the original accelerometer and gyro measures in 3-dimensions, along with numerous derived values (such as mean, standard deviation, energy, frequency, etc.). _The program uses this file._

* **./y\_train.txt:** A file containing a numeric vector of the activity IDs, one for each of the 7,352 training observations. _The program uses this file._





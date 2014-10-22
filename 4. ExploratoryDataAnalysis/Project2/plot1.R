
# function plot1()
#
# This function creates a stacked bar chart of NEI data for the years 1999 - 2008,
# summarizing the total PM25 emissions across the nation for each year. 
#
# The function uses the barplot function from the base graphics package
#
# It assumes the presence of a data frame with NEI data in the parent environment.
# 
# If that is not there, it calls getAndCleanData() to read it in.
#
# Dale Wickizer
# 10/19/2014

plot1 <- function() {
    
    library(dplyr)
    
    # If source data is not already in parent environment, read in the data
    if (!exists ("NEI")) {
        
        getAndCleanData()
        
    }
     
    # For this plot we only need year, type and Emissions from NEI
    NEI2 <- tbl_df(subset(NEI, select = c(year, type, Emissions)))
    
    # Change year into a factor for grouping and plotting
    NEI2 <- transform(NEI2, year = factor(year))
    
    # Group by type, then year
    NEI2 <- NEI2 %>% group_by(type, year)
       
    # Summarise by type, then year
    NEI2 <- summarise(NEI2, sum(Emissions))
    
    # Relabel columns
    colnames(NEI2) <- c("Source", "Year", "totPM25")
    
    # Create a height matrix for stacked barcharts 
    a <- rbind(NEI2[1:4,3], NEI2[5:8,3], NEI2[9:12,3], NEI2[13:16,3])
    
    # Order the matrix rows from low to high (first row plotted first)
    row <- order(a[,1])
    a <- a[row,]
    
    # Pull out the date factors
    b <- unique(NEI2$Year)
       
    # Open image file
    png (filename = "./plot1.png")
    
    # Plot the PM2.5 Totals
    barplot(height = a/1.e6, names.arg = b, col = c("blue", "green", "yellow", "red"), 
            density = 100, angle = 45, ylim = c(0,8), xlab = "Year", 
            ylab = "PM2.5 (Millions of Tons)", 
            main = "Total Annual PM2.5 in U.S. (All Sources)", beside = FALSE,
            legend.text = c("ROAD", "NON-ROAD", "POINT", "NON-POINT"))
            
    # Close file
    dev.off()
}

# function getAndCleanData ()
#
# This function checks for the presence of NEI data in the working directory.
# If it does not exist, it downloads and unzips the source .zip file.
# It then reads the source RDS data into NEI and SCC data frames and stores 
# That data in the parent environment for used by other functions.
#
# Dale Wickizer
# 10/19/2014
#
getAndCleanData <- function () {
    
    # If the project source data does not exist, then
    if (!file.exists("./summarySCC_PM25.rds")) {
        
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        destFile <- "exdata-data-NEI_data.zip"
        
        # Download File
        download.file(url, destfile = destFile, method = "curl")
        
        # Unzip File
        unzip(destFile)
        
        # Remove Zip File
        file.remove(destFile)
        
    }
    
    # Read In Data and save data frames to the parent environment
    NEI <<- readRDS("summarySCC_PM25.rds")
    SCC <<- readRDS("Source_Classification_Code.rds")
    
}

plot1 ()



# function plot3()
#
# This function creates bar charts for the various sources of NEI data for the years 
# 1999 - 2008, summarizing the total PM25 emissions for Baltimore City, MD for each year. 
#
# The function uses the qplot function from the ggplot2 package
#
# It assumes the presence of a data frame with NEI data in the parent environment.
# 
# If that is not there, it calls getAndCleanData() to read it in.
#
# Dale Wickizer
# 10/19/2014

plot3 <- function() {
    
    library(dplyr)
    library(ggplot2)
    
    # If source data is not already in parent environment, read in the data
    if (!exists ("NEI")) {
        
        getAndCleanData()
        
    }
    
    # For this plot we only need year, type and Emissions from NEI for Baltimore City, MD
    # fips == 24510
    NEI2 <- tbl_df(subset(NEI, fips == "24510", select = c(year, type, Emissions)))
    
    # Change year into a factor for grouping and plotting
    NEI2 <- transform(NEI2, year = factor(year))
    
    # Group by year then type
    NEI2 <- NEI2 %>% group_by(year, type)
    
    # Summarise by year and type
    NEI2 <- summarise(NEI2, sum(Emissions))
    
    # Relabel columns
    colnames(NEI2) <- c("Year", "Source", "totPM25")
    
    # Open image file
    png (filename = "./plot3.png")
    
    
    # Plot the Total Annual PM2.5 data by Source and Year for Baltimore City, MD
    bar <- qplot(x = Year, y = totPM25, data = NEI2, fill = Source, facets = Source ~ ., 
          ylab = "Total PM2.5 (Tons)", main = "Total Annual PM2.5 Per Source in Baltimore, MD", 
          stat = "identity", geom = c("bar"))
    
    print(bar)
    
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


plot3 ()



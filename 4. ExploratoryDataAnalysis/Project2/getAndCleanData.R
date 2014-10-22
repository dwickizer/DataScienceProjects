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


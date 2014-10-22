
# function plot6()
#
# This function compares the motor vehicle sources of PM2.5 in Baltimore City, MD from
# 1999 - 2008 to those of Los Angeles County, CA. It summarizes the results of that 
# comparison in a table and graph.
# 
# The graph is created using the base graphics package.
#   
# It assumes the presence of a data frame with NEI data in the parent environment.
# 
# If that is not there, it calls getAndCleanData() to read it in.
#
# Dale Wickizer
# 10/19/2014

plot6 <- function() {
    
    library(dplyr)
    
    # If source data is not already in parent environment, read in the data
    if (!exists ("NEI")) {
        
        getAndCleanData()
        
    }
    
    # Create a subset of NEI data for Baltimore CIty, MD using NEI data from parent env
    NEI.BC <- inner_join(SCC, NEI, by = "SCC")   
    NEI.BC <- subset(NEI.BC, fips == "24510", select = c(year, Short.Name, Emissions))  
    colnames(NEI.BC) <- c("Year", "Short.Name", "Emissions")
    NEI.BC <- transform(NEI.BC, Year = factor(Year))
    
    # Which rows are motor vehicle?
    row <- grep ("Highway Veh", NEI.BC$Short.Name, ignore.case = TRUE)       
    NEI.BC <- NEI.BC[row,]      
    
    # Calculate Total PM2.5 Motor Vehicle Emissions for Baltimore CIty by year
    totBC <- subset(NEI.BC, select = c(Year, Emissions))
    totBC <- totBC %>% group_by(Year)
    totBC <- summarize(totBC, sum(Emissions))
    colnames(totBC) <- c("Year", "from.BC")
    
    # Create a subset of NEI data for Los Angeles County, CA using NEI data from parent env
    NEI.LA <- inner_join(SCC, NEI, by = "SCC")   
    NEI.LA <- subset(NEI.LA, fips == "06037", select = c(year, Short.Name, Emissions))  
    colnames(NEI.LA) <- c("Year", "Short.Name", "Emissions")
    NEI.LA <- transform(NEI.LA, Year = factor(Year))
    
    # Which rows are motor vehicle?
    row <- grep ("Highway Veh", NEI.LA$Short.Name, ignore.case = TRUE)       
    NEI.LA <- NEI.LA[row,]      
    
    # Calculate Total PM2.5 Motor Vehicle Emissions for Los Angeles County by year
    totLA <- subset(NEI.LA, select = c(Year, Emissions))
    totLA <- totLA %>% group_by(Year)
    totLA <- summarize(totLA, sum(Emissions))
    colnames(totLA) <- c("Year", "from.LA")
    
    # Compare and summarize sources
    totSum <- inner_join(totBC, totLA, by = "Year")
    totSum <- transform(totSum, from.BC = round(from.BC,0), from.LA = round(from.LA,0))
    
    print(totSum, row.names = FALSE)
    
    # Create matrix for plot heights
    a <- matrix(c(totSum$from.BC, totSum$from.LA), nrow = 4, ncol = 2)
    a <- t(a)
    
    bc.ty <- totSum$from.BC
    bc.labels <- as.character(totSum$from.BC)
    
    la.ty <- totSum$from.LA
    la.labels <- as.character(totSum$from.LA)
        
    # Open image file
    png (filename = "./plot6.png")    
    
    # Plot
    bp <- barplot(height = a, names.arg = totSum$Year, col = c("green","red"), density = 100, 
            angle = 45, xlab = "Year", ylab = "PM2.5 (Tons)", ylim = c(0,5000),
            main = "Annual PM2.5 from Motor Vehicles\n(Baltimore City vs. Los Angeles)", 
            beside = TRUE, legend.text = c("Baltimore", "Los Angeles"), 
            args.legend = list(bty = "n")) 
    
    text(bp[1,], y = bc.ty, labels = bc.labels, pos = 3)
    text(bp[2,], y = la.ty, labels = la.labels, pos = 3)
                
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

plot6 ()



# function plot5()
#
# This function compares the motor vehicle sources of PM2.5 to all sources from
# 1999 - 2008 in Baltimore City, MD. It summarizes the results of that comparison in 
# a table and graph.
# 
# The graph is created using the base graphics package.
#   
# It assumes the presence of a data frame with NEI data in the parent environment.
# 
# If that is not there, it calls getAndCleanData() to read it in.
#
# Dale Wickizer
# 10/19/2014

plot5 <- function() {
    
    library(dplyr)
    
    # If source data is not already in parent environment, read in the data
    if (!exists ("NEI")) {
        
        getAndCleanData()
        
    }
    
    # Create a subset of NEI data for Baltimore CIty, MD using NEI data from parent env
    NEI.BC <- inner_join(SCC, NEI, by = "SCC")   
    NEI.BC <- subset(NEI.BC, fips == "24510", select = c(year, Short.Name, Emissions))  
    colnames(NEI.BC) <- c("Year", "Short.Name", "Emissions")
    
    # Which rows are motor vehicle? (Assumption: Motor Vehicle = Highway Vehicle)
    row <- grep ("Highway Veh", NEI.BC$Short.Name, ignore.case = TRUE)       
    NEI.BC.mv <- NEI.BC[row,]      
    
    # Calculate Total PM2.5 Emissions Baltimore City by year
    totBC <- subset(NEI.BC, select = c(Year, Emissions))
    totBC <- totBC %>% group_by(Year)
    totBC <- summarize(totBC, sum(Emissions))
    colnames(totBC) <- c("Year", "BC.PM2.5")
    
    # Calculate Total PM2.5 Motor Vehicle Emissions for Baltimore CIty by year
    totMV <- subset(NEI.BC.mv, select = c(Year, Emissions))
    totMV <- totMV %>% group_by(Year)
    totMV <- summarize(totMV, sum(Emissions))
    colnames(totMV) <- c("Year", "from.MV")
    
    # Compare and summarize Sources
    totSum <- inner_join(totBC, totMV, by = "Year")
    totSum$Percent <- with(totSum, from.MV/BC.PM2.5*100)    
    totSum <- transform(totSum, BC.PM2.5 = round(BC.PM2.5,), from.MV = round(from.MV,1), 
                        Percent = round(Percent,2))
    
    print(totSum, row.names = FALSE)
    
    # Calculate y-offsets for text labels and generate labels
    tot.ty <- totSum$BC.PM2.5
    tot.labels <- as.character(totSum$BC.PM2.5) 
   
    mv.ty <- totSum$from.MV
    mv.labels <- as.character(totSum$from.MV)
    
    per.ty <- (tot.ty - mv.ty)/2
    per.labels <- as.character(totSum$Percent)
    per.labels <- paste(per.labels,"%")
    
    # Open image file
    png (filename = "./plot5.png")
    
    # Plot total emissions in Baltimore City
    bp1 <- barplot(height = totSum$BC.PM2.5, names.arg = totSum$Year, col = "green", 
            density = 100, angle = 45, ylim = c(0,4000), xlab = "Year", ylab = "PM2.5 (Tons)", 
            main = "Total Annual PM2.5 in Baltimore City, MD\n (Motor Vehicles vs. All Sources)" )
    
    # Plot motor vehicle emissions in Baltimore City
    bp2 <- barplot(height = totSum$from.MV, names.arg = totSum$Year, col = "blue", 
            density = 100, angle = -45, ylim = c(0,4000), beside = TRUE, add = TRUE ) 
    
    legend("topright", legend = c("All Sources", "Motor Vehicles"), 
           fill = c("green", "blue"))   
    
    text(bp1, tot.ty, labels = tot.labels, col = "black", pos = 3)
    text(bp2, mv.ty, labels = mv.labels, col = "black", pos = 3)
    text(bp1, per.ty, labels = per.labels, col = "black", pos = 3)
        
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

plot5 ()

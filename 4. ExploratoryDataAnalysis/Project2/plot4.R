
# function plot4()
#
# This function compares the coal combustion sources of PM2.5 to the US totals from
# 1999 - 2008. It summarizes the results of that comparison in a table and graph.
# 
# The graph is created using the base graphics package.
#   
# It assumes the presence of a data frame with NEI data in the parent environment.
# 
# If that is not there, it calls getAndCleanData() to read it in.
#
# Dale Wickizer
# 10/19/2014

plot4 <- function() {
    
    library(dplyr)
    
    # If source data is not already in parent environment, read in the data
    if (!exists ("NEI")) {
        
        getAndCleanData()
        
    }
    
    # Calculate Total PM2.5 Emissions for US by year using the NEI data from parent env
    NEIsm <- subset(NEI, select = c(Emissions, year))
    NEIsm <- NEIsm %>% group_by(year)
    totUS <- summarize(NEIsm, sum(Emissions))
    colnames(totUS) <- c("Year", "US.PM2.5")
    
    # Create a subset of NEI data from Coal Combustion Sources
    NEI2 <- inner_join(SCC, NEI, by = "SCC")   
    NEI2 <- subset(NEI2, select = c(fips, Short.Name, Emissions, year))   

    # Find the Combustion Rows
    row <- grep ("Ext Comb", NEI2$Short.Name, ignore.case = TRUE)    
    NEI2 <- NEI2[row,]   

    # Find the Combustion Rows that are from Coal
    row <- grep ("Ext Comb", NEI2$Short.Name, ignore.case = TRUE)    
    NEI2 <- NEI2[row,]   
    
    colnames(NEI2) <- c("fips", "Short.Name", "Emissions", "Year")
    
    # Calculate Total PM2.5 Emissions for US by Coal by year
    NEI2sm <- subset(NEI2, select = c(Emissions, Year))
    NEI2sm <- NEI2sm %>% group_by(Year)
    totCoal <- summarize(NEI2sm, sum(Emissions))
    colnames(totCoal) <- c("Year", "from.Coal")
    
    # Compare and summarize Sources
    totSum <- inner_join(totUS, totCoal, by = "Year")
    
    # Scale to Megatons
    totSum$US.Megatons <- totSum$US.PM2.5/1.e6
    totSum$Coal.Megatons <- totSum$from.Coal/1.e6
    
    # Find percentage of Coal vs. US total
    totSum$Percent <- with(totSum, from.Coal/US.PM2.5*100)    
    
    # Reformat result
    totSum <- subset(totSum, select = c(Year, US.Megatons, Coal.Megatons, Percent))
    totSum <- transform(totSum, US.Megatons = round(US.Megatons,1), 
                        Coal.Megatons = round(Coal.Megatons,2), 
                        Percent = round(Percent,1))
    
    print(totSum, row.names = FALSE)   
    
    # Calculate y-offsets for text labels and generate labels
    us.ty <- totSum$US.Megatons
    us.labels <- as.character(totSum$US.Megatons)
    
    coal.ty <- totSum$Coal.Megatons
    coal.labels <- as.character(totSum$Coal.Megatons)
    
    per.ty <- (us.ty - coal.ty)/2
    per.labels <- as.character(totSum$Percent)
    per.labels <- paste(per.labels, "%")
    
    # Open image file
    png (filename = "./plot4.png")
    
    
    # Plot the total US data first
    bp1 <- barplot(height = totSum$US.Megatons, names.arg = totSum$Year, col = "green", 
                density = 100, angle = 45, ylim = c(0,8), xlab = "Year", ylab = "PM2.5 (Megatons)", 
                main = "Total Annual PM2.5 in U.S. (Coal vs. All Sources)" )
        
    # Plot the Coal data next; It will overlay Total US, The part left
    # represents the Non-Coal sources
    bp2 <- barplot(height = totSum$Coal.Megatons, names.arg = totSum$Year, col = "blue", 
                density = 100, angle = -45, ylim = c(0,8), beside = TRUE, add = TRUE ) 
        
    legend("topright", legend = c("All Sources", "Coal"), fill = c("green", "blue"))
    
    text(bp1, us.ty, labels = us.labels, col = "black", pos = 3)
    text(bp2, coal.ty, labels = coal.labels, col = "black", pos = 3)
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

plot4 ()

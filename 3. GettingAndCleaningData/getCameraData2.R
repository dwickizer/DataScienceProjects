## getCameraData()
##
## Pulls Maryland traffic camera data.
## Returns a dataframe called cameraData

getCameraData <- function(format = "csv") {
   
    ## Input checking. Expecting a character string of "csv", "json", "xlsx" or "xml"
    if (!(format == "csv" | format == "json" | format == "xlsx" | format == "xml")) {
        stop("Expecting \"csv\", \"json\", \"xlsx\" or \"xml\" for format input")
    }
    
    ## We'll use ./cam_data for our data directory. Create it if it doesn't exist
    if (!file.exists("cam_data")) {
        dir.create("cam_data")
        
    }
    
    ## URL for data, depending on desired format. The default is "csv"
    
    switch(format,
        csv = fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD",
        json = fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.json?accessType=DOWNLOAD",
        xlsx = fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD",
        xml = fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xml?accessType=DOWNLOAD"
    )
    
    ## Create an output filename based upon the type of format
    outputFileName <- c("./cam_data/cameras", format)
    outputFileName <- paste(outputFileName, collapse = ".")
    
    ## Pull the appropriate file down from the web
    download.file(fileUrl, destfile = outputFileName, method = "curl")
    
    list.files("./cam_data/")
    
    
    ## Load any required library
    if (format == "xlsx") { ## for Excel spreadsheets
        library (xlsx)
    }
    else if (format == "json") { ## for JSON files
        library(jsonlite)
    }
    else if (format == "xml") { ## for XML files
        library (XML)
    }
    
    
    ## cameraData <- read.csv("./cam_data/cameras.csv", header = TRUE, sep = ",")
    switch(format,
           csv = cameraData <- read.csv(outputFileName, header = TRUE, sep = ","),
           json = cameraData <- fromJSON(fileUrl) ,
           xlsx = cameraData <- read.xlsx(outputFileName,sheetIndex=1,header=TRUE)
    ##       xml = fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xml?accessType=DOWNLOAD"
    )
    
    dateDownloaded <- date()
    
    dateDownloaded
    
    return (cameraData)
    
    
}


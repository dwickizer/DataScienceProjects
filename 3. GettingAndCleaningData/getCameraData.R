## getCameraData()
##
## Pulls Maryland traffic camera data.
## Returns a dataframe called cameraData

getCameraData <- function() {
    if (!file.exists("cam_data")) {
        dir.create("cam_data")
        
    }
    
    ## URL for data (CSV format)
    
    fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
    
    download.file(fileUrl, destfile = "./cam_data/cameras.csv", method = "curl")
    
    list.files("./cam_data/")
    
    dateDownloaded <- date()
    
    dateDownloaded
    
    cameraData <- read.csv("./cam_data/cameras.csv", header = TRUE, sep = ",")
    
    return (cameraData)
    
    
}


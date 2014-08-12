complete <- function(directory, fileid = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'fileid' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return a data frame of the form:
    ## id nobs
    ## 1  117
    ## 2  1041
    ## ...
    ## where 'id' is the monitor ID number and 'nobs' is the
    ## number of complete cases
    ##
    ## Appraoch
    ##
    ## 1. Read in directory name and index range
    ## 2. Iterate over every file index
    ## 3. Convert each index to a "ccc.csv" filename with the proper <directory/path>
    ## 4. Determine how many non-NA (complete) observations there are in the file
    ## 5. Store the file id and the length of the observation vector in row in the matrix
    ## 6. When done, return the matrix
    
    
    if (fileid[1] < 1 || length(fileid) > 332) { ## Error check for proper index bounds
        print ("Error: Function complete: ID out of bounds.")
        break
    }
    else {
          
        nobs <- vector(mode = "numeric")    ## Create a vector to for non-NA nitrate observations
        id <- vector(mode = "numeric") ## Create a vector for the file ID     
        
        for (i in fileid){
            filename <- sprintf ("%s/%03d.csv", directory, i) ## Convert id to filename
            
            f <- read.csv(filename, header = TRUE, sep =",")  ## Read csv file
            
            obs <- subset(f, sulfate != "NA" & nitrate != "NA") ## pluck out non-NA observations
            nobs <- c(nobs,length(obs[,"sulfate"])) ## record the number of non-NA obs for this file
            id <- c(id, as.numeric(i))     ## record the fileid for this file            
        } 
        
        results <- data.frame(id, nobs)
        
        results
    }  
}





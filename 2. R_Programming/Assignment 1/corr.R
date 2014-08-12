corr <- function(directory, threshold = 0) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'threshold' is a numeric vector of length 1 indicating the
    ## number of completely observed observations (on all
    ## variables) required to compute the correlation between
    ## nitrate and sulfate; the default is 0
    
    ## Return a numeric vector of correlations
    
    ## Approach:
    ##
    ## We're going to need the help of the complete.R program to tell us which
    ## FileID's are > threshold. W
    ## 1. Read in all the observation summaries using complete
    ## 2. Save only the IDs which are above the threshold
    ## 3. Loop over those IDs and accumulate vectors for sulfates and nitrates, by file and date
    ## 4. Calculate the correlation between sulfates and nitrates for each relevant file
    ## 5. Return the results in a vector
    
    source("complete.R")
    
    allObs <- complete(directory)  ## Read in all observation summaries
    
    relevantObs <- allObs[allObs$nobs > threshold,] ## Save the relevant IDs and #Obs in dataframe
    
    corrObs <- vector(mode = "numeric") ## Create a vector for the resultant correlations
    
    fileID <- relevantObs[,"id"]  ## Create a vector of the fileIDs
    
    for (i in fileID){  ## For each relevant file ID:
        filename <- sprintf ("%s/%03d.csv", directory, i) ## Convert id to filename
        
        f <- read.csv(filename, header = TRUE, sep =",")  ## Read csv file
        obs <- subset(f, sulfate != "NA" & nitrate != "NA") ## pluck out non-NA observations
        
        sobs <- obs[,"sulfate"] ## Suck in the sulfates (but don't inhale)
        nobs <- obs[,"nitrate"] ## Suck in hte nitrates (try not to explode)
        
        corrObs <- c(corrObs, cor(sobs,nobs))
    }
    
    corrObs ## Return it
}


pollutantmean <- function(directory, pollutant, id = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'pollutant' is a character vector of length 1 indicating
    ## the name of the pollutant for which we will calculate the
    ## mean; either "sulfate" or "nitrate".
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Approach:
    ##
    ## 1. Given a range of monitors, each corresponding to a file, 
    ##    Will need to read in csv file (using a for loop)
    ##    That will necessitate changing the id to a "ccc.csv" format
    ## 2. Collect appropriate column, based on pollutant entered.
    ## 3. Strip out all NAs
    ## 4. Concatenate the readings into a numeric vector
    ## 5. After reading them all, calculate and return the mean on
    ##    the numeric vector
    
    if (id[1] < 1 || length(id) > 332) {
        print ("Error: Function pollutantmean: ID out of bounds.")
        break
    }
    else {
        p <- vector(mode = "numeric") ## Create a vector to accumulate non-NA observations
        
        for (i in id){
            filename <- sprintf ("%s/%03d.csv", directory, i) ## Convert id to filename
            
            f <- read.csv(filename, header = TRUE, sep =",")  ## Read csv file
            
            pt <- f[, pollutant] ## grab the pollutant (includes NA's)
            
            p <- c(p, pt[!is.na(pt)]) ## add the non-NA observations to the vector
            
        }
        
        ## Return the mean of the pollutant across all monitors list
        ## in the 'id' vector (ignoring NA values)
        
        pmean <- mean(p)
        
        round(pmean, 3)
    
    }
    
}




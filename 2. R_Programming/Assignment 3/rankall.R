## Function rankall (outcome, num)

## Given a desired outcome, which may be "heart attack", 
## "heart failure" or "pneumonia", and a rank, return the Hospitals in every state with that rank
## for that outcome.
##
## written by Dale Wickizer

rankall <- function(outcome, rank = "best") {    
    
    ## Global declarations
    validOutcomes <- c("heart attack", "heart failure", "pneumonia")
    file <- "ProgAssignment3-data/outcome-of-care-measures.csv"
    
    ## Read outcome data
    outcomeData <- read.csv(file, header = TRUE, colClasses = "character")
    
    ## Create Valid State and Territory List
    validStates <- sort(unique(outcomeData[,"State"]))
    
    ## Check for valid outcome
    if(is.na(charmatch(outcome, validOutcomes))) {
        stop ("invalid outcome")
    }
    
    ## outcomeData is a very large data frame. We are interested in a relatively small
    ## chunk. In all cases we want the hospital name and state
        
    ## Col  2 - Hospital.Name
    ## Col  7 - State Abbreviation
        
    ## The other columns we'll pick based on desired outcome:
    ## Col 11 - 30-day Mortality Rate for Heart Attack
    ## Col 17 - 30 day Mortality Rate for Heart Failure
    ## Col 23 - 30 day Mortality Rate for Pneumonia
        
    switch(outcome,
        "heart attack" = workingSet <- outcomeData[,c(2,7,11)],
        "heart failure" = workingSet <- outcomeData[,c(2,7,17)],
        "pneumonia" = workingSet <- outcomeData[,c(2,7,23)])
     
    ## Convert the rates to numeric
    workingSet[,3] <- suppressWarnings(as.numeric(workingSet[,3]))
    
    ## Remove NA lines
    workingSet <- subset(workingSet, workingSet[3] == workingSet[3], na.rm = TRUE)
    
    ## Calculate ordering, first on state, then rate, then on hospital name
    o <- order(workingSet[2], workingSet[3], workingSet[1])
    
    ## Build new data.frame based on the ordering
    Names <- workingSet[,1]
    States <- workingSet[,2]
    Rates <- workingSet[,3]
    
    result <- data.frame(Names[o],States[o],Rates[o])
    
    ## Fix the column names
    colnames(result) <- c("Hospital.Name", "State","Rate")
    
    ## Assuming the data is in the right form, what's the appraoch?
    ## We're going to need to determine the bounds of each set from each state
    ## We're going to need to sort each state for that outcome, then do
    ## rank checking and assignment on the rank each state
    
    ## Let's create a list of data frames, where each data frame contains the sorted information
    ## by state
    
    y <- split(result, result[,2])
    
    ## Create a list of the bounds for each state
    bounds <- lapply(y, function(elt) length(elt[,1]))
    
    ## bounds should be a list of length 54 (a length of outcomes for every state/territory)
    ## We'll use that for our control loop; y should also be of length 54. Both should have the 
    ## same labels
    
    tag <- labels(bounds)
    
    Name <- replicate(54,"")
    State <- replicate(54,"")
    
    for (i in 1:length(bounds)) {
        
        ## We'll need an index related to the rank input; check to see if it's "best", "worst"
        ## or out of bounds
        if (rank == "best") {
            idx <- 1
        }
        else if (rank == "worst") {
            idx <- as.numeric(bounds[i])
        }
        else if (rank > bounds[i]) {
            Name[i] <- NA
            State[i] <- tag [i]
        }
        else {
            idx <- as.numeric(rank)
        }
        
        ## Peel off each dataframe
        df <- data.frame(y[i])
        
        ## If not out-of-bounds, then load hospital and state into data frame
        if(!is.na(Name[i])) {
            Name[i] <- as.character(df[idx,1])
            State[i] <- as.character(df[idx,2])
        }
    }
    
    ## When done looping, assemble and return the dataframe

    final <- data.frame(Name,State)
    colnames (final) <- c("hospital","state")
    return (final)

}

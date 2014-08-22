### Function rankhospital (state, outcome)

## Given a 2 letter state abbreviation and a desired outcome, which may be "heart attack", 
## "heart failure" or "pneumonia", Return the hospital name in that state with the loweest
## 30-day death rate
##
## written by Dale Wickizer

rankhospital <- function(state, outcome, rank = "best") {    
    
    ## Global declarations
    validOutcomes <- c("heart attack", "heart failure", "pneumonia")
    file <- "ProgAssignment3-data/outcome-of-care-measures.csv"
    
    ## Read outcome data
    outcomeData <- read.csv(file, header = TRUE, colClasses = "character")
    
    ## Create Valid State and Territory List
    validStates <- sort(unique(outcomeData[,"State"]))
    
    ## Check for valid state
    if (is.na(charmatch(state, validStates))) {
        stop ("invalid state")        
    }
    
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
        "heart attack" = chunk <- outcomeData[,c(2,7,11)],
        "heart failure" = chunk <- outcomeData[,c(2,7,17)],
        "pneumonia" = chunk <- outcomeData[,c(2,7,23)])
        
    ## Narrow down the working set to the desired state
    workingSet <- subset(chunk, State == state)
    
    ## We really only need hospital name and rate
    workingSet <- workingSet[,c(1,3)]
    
    ## Convert the rates to numeric
    workingSet[,2] <- suppressWarnings(as.numeric(workingSet[,2]))
    
    ## Remove NA lines
    workingSet <- subset(workingSet, workingSet[2] == workingSet[2], na.rm = TRUE)
    
    ## Calculate ordering, first on rate, then on hospital name
    o <- order(workingSet[2],workingSet[1])
    
    ## Build new data.frame based on the ordering
    Names <- workingSet[,1]
    Rates <- workingSet[,2]
    
    result <- data.frame(Names[o],Rates[o])
    
    ## Fix the column names
    colnames(result) <- c("Hospital.Name", "Rate")
    
    ## Rank checking and assignment on the rank input
    if (rank == "best") {
        idx <- 1
    }
    else if (rank == "worst") {
        idx <- length(result[,1])
    }
    else if (rank > length(result[,1])) {
        final <- NA
        return(final)
    }
    else {
        idx <- as.numeric(rank)
    }
    
    Names <- as.character(result[,1])
    
    final <- Names[idx]
    
    return(final)

}

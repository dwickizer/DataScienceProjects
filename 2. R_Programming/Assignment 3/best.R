### Function best(state, outcome)

## Given a 2 letter state abbreviation and a desired outcome, which may be "heart attack", 
## "heart failure" or "pneumonia", Return the hospital name in that state with the loweest
## 30-day death rate
##
## written by Dale Wickizer

best <- function(state, outcome) {    
    
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
        
    ## Find the lowest rate
    bestRate <- suppressWarnings(min(as.numeric(workingSet[,3]), na.rm = TRUE))
    
    ## Convert back to string with decimal (as.numeric() removes decimal on whole numbers)
    bestRate <- sprintf("%.1f", bestRate)
        
    ## Find the hospital(s) associated with that lowest rate
    bestHospitals <- subset(workingSet,workingSet[,3] == bestRate)
        
    ## Exttract the best hospital name by sorting alphabetically and picking the first name
    bestHospitalNames <- sort(bestHospitals[,1])
        
    ## Return hospital name in that state with lowest 30-day death rate
    bestHospitalNames[1]
    
}

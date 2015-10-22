options(stringsAsFactors=FALSE)
GetState <- function(exhibit){
    state <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=state&s[][org_type]=DC&sha=promoted"))
    state$org_name <- "DC"
    state[c(1:2,ncol(state),3:(ncol(state)-1))]
  }
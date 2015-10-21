options(stringsAsFactors=FALSE)
GetState <- function(exhibit){
    read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=state&s[][org_type]=DC&sha=promoted"))
  }
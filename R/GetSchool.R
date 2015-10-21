#' Access the data for DC's Public and Public Charter schools from LearnDC's API.
#'
#' This function allows you to access data from LearnDC's API from the School Profiles section of the site.
#' @return An R dataframe of the data from the API feeding LearnDC's School Profiles.
#' import jsonlite
#' @export
#' @examples
#' school_grad <- GetSchool("graduation")
#' print(head(school_grad))

options(stringsAsFactors=FALSE)
if(!require(jsonlite)){
  install.packages("jsonlite")
  library(jsonlite)
}

leadgr <- function(x, y){
  if(!is.na(x)){
    while(nchar(x)<y){
      x <- paste("0",x,sep="")
    }
  }
  return(x)
}

`%notin%` <- function(x,y) !(x %in% y)

GetSchool <- function(exhibit){
    school <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=school&sha=promoted"))
    school$org_code <- sapply(school$org_code,leadgr,4)
    
    school_overview <- data.frame()
    for(a in unique(subset(school,org_code %notin% '0480')$org_code)){
      new_row <- as.data.frame(fromJSON(paste0("https://raw.githubusercontent.com/DC-OSSE/LearnDC_v2/master/Export/JSON/school/",a,"/overview.json"))[3:4])
      school_overview <- rbind(school_overview,new_row)
    }
    school <- merge(school,school_overview,by=c('org_code'),all.x=TRUE)
}
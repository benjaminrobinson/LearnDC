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

lea_exhibit_names <- c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment")

GetLEA <- function(exhibit){
  exhibit <- toString(exhibit)
  if(exhibit %notin% lea_exhibit_names){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetLEAExhibits() to get the correct names of LearnDC's LEA Exhibits.")
  }
  else {
 lea <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&sha=promoted"))
 lea$org_code <- sapply(lea$org_code,leadgr,4)
 lea <- subset(lea,org_code %notin% c('0000','0001','6000'))
  
 lea_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/leas?sha=promoted")[2:3],org_code %in% lea$org_code)
 lea <- merge(lea,lea_overview,by=c('org_code'),all.x=TRUE)
 lea[c(1:2,ncol(lea),3:(ncol(lea)-1))]
  }
}
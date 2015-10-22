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

GetLEA <- function(exhibit){
 lea <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&sha=promoted"))
 lea$org_code <- sapply(lea$org_code,leadgr,4)
  
 lea_overview <- data.frame()
  for(a in unique(subset(lea,org_code %notin% '4002')$org_code)){
  new_row <- as.data.frame(fromJSON(paste0("https://raw.githubusercontent.com/DC-OSSE/LearnDC_v2/master/Export/JSON/lea/",a,"/overview.json"))[3:4])
    lea_overview <- rbind(lea_overview,new_row)
    }
  lea <- merge(lea,lea_overview,by=c('org_code'),all.x=TRUE)
  lea[c(1:2,ncol(lea),3:(ncol(lea)-1))]
}
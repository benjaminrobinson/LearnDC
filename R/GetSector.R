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

sector_exhibit_names <- c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment")

GetSector <- function(exhibit){
  exhibit <- toString(exhibit)
  if(exhibit %notin% sector_exhibit_names){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetSectorExhibits() to get the correct names of LearnDC's Sector Exhibits.")
  }
  else {
 sector <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&s[][org_code]=0001&s[][org_code]=0000&s[][org_code]=6000&sha=promoted"))
 sector$org_code <- sapply(sector$org_code,leadgr,4)
  
 sector_overview <- data.frame()
  for(a in unique(sector$org_code)){
  new_row <- as.data.frame(fromJSON(paste0("https://raw.githubusercontent.com/DC-OSSE/LearnDC_v2/master/Export/JSON/lea/",a,"/overview.json"))[3:4])
    sector_overview <- rbind(sector_overview,new_row)
    }
  sector <- merge(sector,sector_overview,by=c('org_code'),all.x=TRUE)
  sector$org_type <- "sector"
  sector[c(1:2,ncol(sector),3:(ncol(sector)-1))]
  }
}
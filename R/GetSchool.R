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

school_exhibit_names <- c("graduation","dccas","attendance","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","accountability_classification","pcsb_pmf")

GetSchool <- function(exhibit){
  exhibit <- toString(exhibit)
  if(exhibit %notin% school_exhibit_names){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetSchoolExhibits() to get the correct names of LearnDC's School Exhibits.")
  }
  else {
    school <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=school&sha=promoted"))
    school$org_code <- sapply(school$org_code,leadgr,4)
    
    school_overview <- data.frame()
    for(a in unique(subset(school,org_code %notin% '0480')$org_code)){
      new_row <- as.data.frame(jsonlite::fromJSON(paste0("https://learndc-api.herokuapp.com//api/schools/",a,".json?sha=promoted"))[2:3])
      school_overview <- rbind(school_overview,new_row)
    }
    school <- merge(school,school_overview,by=c('org_code'),all.x=TRUE)
    school[c(1:2,ncol(school),3:(ncol(school)-1))]
  }
}
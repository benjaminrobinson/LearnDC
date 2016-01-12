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

GetSector <- function(exhibit){
  exhibit <- tolower(exhibit)
  if(exhibit %notin% c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment")){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetExhibits('sector') to get the correct names of LearnDC's Sector Exhibits.")
  } else {
 sector <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&s[][org_code]=0001&s[][org_code]=0000&&s[][org_code]=6000&sha=promoted"))
 sector$org_code <- sapply(sector$org_code,leadgr,4)
  
 sector_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/leas?sha=promoted")[2:3],org_code %in% sector$org_code)
 sector <- merge(sector,sector_overview,by=c('org_code'),all.x=TRUE)
 sector$org_type <- "sector"
 sector <- sector[c(1:2,ncol(sector),3:(ncol(sector)-1))]

 if(exhibit %in% c('graduation','dccas','special_ed','enrollment')){
    sector$subgroup <- tolower(sector$subgroup)
            subgroup_map <- c("bl7"="Black/African American",
                            "wh7"="White",
                            "hi7"="Hispanic",
                            "as7"="Asian",
                            "mu7"="Multiracial",
                            "pi7"="Pacific Islander",
                            "am7"="American Indian",
                            "direct cert"="TANF/SNAP eligible",
                            "economy"="Economically Disadvantaged",
                            "lep"="English Learner",
                            "sped"="Special Education",
                            "sped level 1"="Special Education Level 1",
                            "sped level 2"="Special Education Level 2",
                            "sped level 3"="Special Education Level 3",
                            "sped level 4"="Special Education Level 4",
                            "all sped students"="Special Education",
                            "alt test takers"="Alternative Testing",
                            "with accommodations"="Testing Accommodations",
                            "all"="All",
                            "female"="Female",
                            "male"="Male",
                            "asian"="Asian",
                            "economically disadvantaged"="Economically Disadvantaged",
                            "african american"="Black/African American",
                            "english learner"="English Learner",
                            "hispanic"="Hispanic",
                            "multiracial"="Multiracial",
                            "pacific islander"="Pacific Islander",
                            "special education"="Special Education",
                            "white"="White")
      
      sector$subgroup <- subgroup_map[sector$subgroup]
        }

    if(exhibit %in% c('enrollment')){
        sector$year <- paste0(sector$year,"-",sector$year+1)
    } else {
        sector$year <- paste0(sector$year-1,"-",sector$year)
    }
  }
  sector$population <- NULL
  return(sector)
}

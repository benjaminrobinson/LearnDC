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
  exhibit <- tolower(exhibit)
  if(exhibit %notin% c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment")){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetExhibits('lea') to get the correct names of LearnDC's LEA Exhibits.")
  }
  else {
 lea <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&sha=promoted"))
 lea$org_code <- sapply(lea$org_code,leadgr,4)
 lea <- subset(lea,org_code %notin% c('0000','0001','6000'))
  
 lea_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/leas?sha=promoted")[2:3],org_code %in% lea$org_code)
 lea <- merge(lea,lea_overview,by=c('org_code'),all.x=TRUE)
 lea <- lea[c(1:2,ncol(lea),3:(ncol(lea)-1))]

if(exhibit %in% c('graduation','dccas','special_ed','enrollment')){
        lea$subgroup <- tolower(lea$subgroup)
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

        lea$subgroup <- subgroup_map[lea$subgroup]
        }

    if(exhibit %in% c('enrollment')){
        lea$year <- paste0(lea$year,"-",lea$year+1)
    } else {
        lea$year <- paste0(lea$year-1,"-",lea$year)
    }
  }
  lea$population <- NULL
  return(lea)
}  

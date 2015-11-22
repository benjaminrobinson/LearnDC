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
  exhibit <- toString(exhibit)
  if(exhibit %notin% c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment")){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetSectorExhibits() to get the correct names of LearnDC's Sector Exhibits.")
  } else {
 sector <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&s[][org_code]=0001&s[][org_code]=0000&&s[][org_code]=6000&sha=promoted"))
 sector$org_code <- sapply(sector$org_code,leadgr,4)
  
 sector_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/leas?sha=promoted")[2:3],org_code %in% sector$org_code)
 sector <- merge(sector,sector_overview,by=c('org_code'),all.x=TRUE)
 sector$org_type <- "sector"
 sector <- sector[c(1:2,ncol(sector),3:(ncol(sector)-1))]

 if(exhibit %in% c('graduation','dccas','special_ed','enrollment')){
    subgroup_map <- c("bl7"="african american","wh7"="white","hi7"="hispanic","as7"="asian","mu7"="multiracial","pi7"="pacific islander","am7"="american indian","direct cert"="tanf/snap eligible","economy"="economically disadvantaged","lep"="english learner","sped"="special education","sped level 1"="special education level 1","sped level 2"="special education level 2","sped level 3"="special education level 3","sped level 4"="special education level 4","all sped students"="special education","alt test takers"="alternative testing","with accommodations"="testing accommodations","all"="all","female"="female","male"="male","asian"="asian","economically disadvantaged"="economically disadvantaged","african american"="african american","english learner"="english learner","hispanic"="hispanic","multiracial"="multiracial","pacific islander"="pacific islander","special education"="special education","white"="white","African American"="african american","All"="all","Asian"="asian","Economically Disadvantaged"="economically disadvantaged","English Learner"="english learner","Female"="female","Male"="male","Hispanic"="hispanic","Multiracial"="multiracial","Special Education"="special education","White"="white")
      
      sector$subgroup <- subgroup_map[sector$subgroup]
        }

    if(exhibit %in% c('enrollment')){
        sector$year <- paste0(sector$year,"-",sector$year+1)
    } else {
        sector$year <- paste0(sector$year-1,"-",sector$year)
    }
  }
  return(sector)
}
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
  exhibit <- tolower(exhibit)
  if(exhibit %notin% c("graduation","dccas","attendance","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","accountability_classification","pcsb_pmf","mid_year_entry_and_withdrawal")){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetExhibits('school') to get the correct names of LearnDC's School Exhibits.")
  }
  else {
    school <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=school&sha=promoted"))
    school$org_code <- sapply(school$org_code,leadgr,4)
    
    school_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/schools?sha=promoted")[2:3],org_code %in% school$org_code)
    school <- merge(school,school_overview,by=c('org_code'),all.x=TRUE)
    school <- school[c(1:2,ncol(school),3:(ncol(school)-1))]

    if(exhibit %in% c('graduation','dccas','attendance','special_ed','enrollment','mgp_scores','suspensions','enrollment_equity','amo_targets','accountability')){
      school$subgroup <- tolower(school$subgroup)
        subgroup_map <- subgroup_map <- c("bl7"="african american",
                            "wh7"="white",
                            "hi7"="hispanic",
                            "as7"="asian",
                            "mu7"="multiracial",
                            "pi7"="pacific islander",
                            "am7"="american indian",
                            "direct cert"="tanf/snap eligible",
                            "economy"="economically disadvantaged",
                            "lep"="english learner",
                            "sped"="special education",
                            "sped level 1"="special education level 1",
                            "sped level 2"="special education level 2",
                            "sped level 3"="special education level 3",
                            "sped level 4"="special education level 4",
                            "all sped students"="special education",
                            "alt test takers"="alternative testing",
                            "with accommodations"="testing accommodations",
                            "all"="all",
                            "female"="female",
                            "male"="male",
                            "asian"="asian",
                            "economically disadvantaged"="economically disadvantaged",
                            "african american"="african american",
                            "english learner"="english learner",
                            "hispanic"="hispanic",
                            "multiracial"="multiracial",
                            "pacific islander"="pacific islander",
                            "special education"="special education",
                            "white"="white")
        
        school$subgroup <- subgroup_map[school$subgroup]
        }

    if(exhibit %in% c('enrollment','enrollment_equity')){
        school$year <- paste0(school$year,"-",school$year+1)
        } else {
        school$year <- paste0(school$year-1,"-",school$year)
    }
  }
  school$population <- NULL
  return(school)
}

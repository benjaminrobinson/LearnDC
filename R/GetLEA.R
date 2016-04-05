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
  if(exhibit %notin% c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","parcc")){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetExhibits('lea') to get the correct names of LearnDC's LEA Exhibits.")
  }
  else {
 if(exhibit %in% "parcc"){
 lea <- subset(read.csv("https://github.com/benjaminrobinson/LearnDC/raw/master/PARCC/lea_parcc.csv"),subject %in% c("Math","Reading"),-c(school_name))
 names(lea)[1:3] <- c('org_code','org_name','org_type')
 lea$org_type <- "LEA"
 names(lea)[17] <- "percent_proficient_3+"
 return(lea[c(3,1,2,4:ncol(lea))])
 }else{ 
 lea <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&sha=promoted"))
 lea$org_code <- sapply(lea$org_code,leadgr,4)
 lea$org_type <- toupper(lea$org_type)
 lea <- subset(lea,org_code %notin% c('0000','0001','6000'))
  
 lea_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/leas?sha=promoted")[2:3],org_code %in% lea$org_code)
 lea <- merge(lea,lea_overview,by=c('org_code'),all.x=TRUE)

    if(any(names(lea) %in% 'subgroup')){
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

    if(any(names(lea) %in% 'subject')){
        lea$subject <- gsub("(^|[[:space:]])([[:alpha:]])","\\1\\U\\2",lea$subject,perl=TRUE)
    }

    if(any(names(lea) %in% 'grade')){
        grade_map <- c('all'='All',
                      'grade 12'='12th Grade',
                      'grade 11'='11th Grade',
                      'grade 10'='10th Grade',
                      'grade 9'='9th Grade',
                      'grade 8'='8th Grade',
                      'grade 7'='7th Grade',
                      'grade 6'='6th Grade',
                      'grade 5'='5th Grade',
                      'grade 4'='4th Grade',
                      'grade 3'='3rd Grade',
                      'grade 2'='2nd Grade',
                      'grade 1'='1st Grade',
                      'grade ao'='Adult',
                      'un'='Ungraded',
                      'kg'='Kindergarten',
                      'pk3'='Pre-Kindergarten for 3 Year Olds',
                      'pk4'='Pre-Kindergarten for 4 Year Olds')
        lea$grade <- grade_map[lea$grade]
    }

    if(exhibit %in% c('hqt_classes','staff_degree')){
        cat_map <- c("SEC"="Secondary Schools",
                            "ELEM"="Elementary Schools",
                            "MIDDLE"="Middle Poverty Quartiles Schools",
                            "HIGH"="High Poverty Quartile Schools",
                            "LOW"="Low Poverty Quartile Schools",
                            "All"="All Schools")
        lea[[4]] <- cat_map[lea[[4]]]
    }

    if(exhibit %in% c('enrollment')){
        lea$year <- paste0(lea$year,"-",lea$year+1)
    } else {
        lea$year <- paste0(lea$year-1,"-",lea$year)
      }
    }
  lea$population <- NULL
  return(lea[c(2,1,ncol(lea),3:(ncol(lea)-1))])
  }
}
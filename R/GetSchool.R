#' A Function to Return DC School Level Data
#'
#' @description This function retrieves the data from the exhibits on 
#' LearnDC.org's School Profiles, Report Cards, and Equity Reports.
#' @param exhibit character, exhibit name.  one of 
#' c("graduation","dccas","attendance","hqt_classes","staff_degree",
#' "mgp_scores","special_ed","enrollment","suspensions","expulsions",
#' "enrollment_equity","accountability","accountability_classification")
#' @usage GetSchool("exhibit")
#'
#' @references \url{http://learndc.org/schoolprofiles/search}
#' @author Benjamin Robinson, \email{benj.robinson2@gmail.com}
#' 
#' @return data frame
#' @export
#' @import RCurl bitops jsonlite
#' 
#' @examples
#' school_grad <- GetSchool("graduation")

GetSchool <- function(exhibit){
  exhibit <- tolower(exhibit)
  if(exhibit %notin% c("graduation","dccas","attendance","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","accountability_classification","pcsb_pmf","mid_year_entry_and_withdrawal","parcc")){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetExhibits('school') to get the correct names of LearnDC's School Exhibits.")
  }
  else {
    if(exhibit %in% "parcc"){
    school <- subset(school_parcc,
    grade %notin% c('Algebra I','English I','English II','Geometry') &
    assessment=='All' &
    !is.na(percent_level_1) & !is.na(percent_level_2) & !is.na(percent_level_3) &
    !is.na(percent_level_4) & !is.na(percent_level_5),-c(lea_code,assessment,cohort))
    names(school)[1:3] <- c('org_type','org_code','org_name')
    names(school)[15] <- "percent_proficient_3+"
    school$org_type <- 'School'
    return(unique(school))
    }else{
    school <- read.csv(text = RCurl::getURL(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=school&sha=promoted")),stringsAsFactors=F)
    school$org_code <- sapply(school$org_code,leadgr,4)
    school$org_type <- gsub("(^|[[:space:]])([[:alpha:]])","\\1\\U\\2",school$org_type,perl=TRUE)
    school_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/schools?sha=promoted")[2:3],org_code %in% school$org_code)
    school <- merge(school,school_overview,by=c('org_code'),all.x=TRUE)
    
    if(any(names(school) %in% 'subgroup')){
    school$subgroup <- tolower(school$subgroup)
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
    school$subgroup <- subgroup_map[school$subgroup]
    }

    if(any(names(school) %in% 'subject')){
        school$subject <- gsub("(^|[[:space:]])([[:alpha:]])","\\1\\U\\2",school$subject,perl=TRUE)
    }

    if(any(names(school) %in% 'grade')){
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
        school$grade <- grade_map[school$grade]
    }
        
    if(exhibit %in% c('hqt_classes','staff_degree')){
        cat_map <- c("SEC"="Secondary Schools",
                            "ELEM"="Elementary Schools",
                            "MIDDLE"="Middle Poverty Quartiles Schools",
                            "HIGH"="High Poverty Quartile Schools",
                            "LOW"="Low Poverty Quartile Schools",
                            "All"="All Schools")
        school[[4]] <- cat_map[school[[4]]]
    }

    if(exhibit %in% c('enrollment','enrollment_equity','accountability_classification','accountability')){
        school$year <- paste0(school$year,"-",school$year+1)
        } else {
        school$year <- paste0(school$year-1,"-",school$year)
      }
    }
  school$population <- NULL
  return(school[c(2,1,ncol(school),3:(ncol(school)-1))])
  }
}
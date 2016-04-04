options(stringsAsFactors=FALSE)
`%notin%` <- function(x,y) !(x %in% y)

GetState <- function(exhibit){
  exhibit <- tolower(exhibit)
	if(exhibit %notin% c("graduation","dccas","attendance","naep_results","hqt_classes","staff_degree","mgp_scores","ell","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","amo_targets","expulsions","mid_year_entry_and_withdrawal","apr","parcc")){
    stop("The requested exhibit does not exist.\r
    Please check the spelling of your exhibit using GetExhibits('state') to get the correct names of LearnDC's State Exhibits.")
	}
	else {
    if(exhibit %in% "parcc"){
    state <- read.csv("https://github.com/benjaminrobinson/PARCC_Munge/raw/master/state_parcc.csv")
    return(state)
    }else{
    state <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=state&s[][org_type]=DC&sha=promoted"))
    state$org_name <- "DC"
    state$org_type <- gsub("(^|[[:space:]])([[:alpha:]])","\\1\\U\\2",state$org_type,perl=TRUE)

    if(any(names(state) %in% 'subgroup')){
    state$subgroup <- tolower(state$subgroup)
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
    state$subgroup <- subgroup_map[state$subgroup]
    }
    

    if(any(names(state) %in% 'subject')){
        state$subject <- gsub("(^|[[:space:]])([[:alpha:]])","\\1\\U\\2",state$subject,perl=TRUE)
    }

    if(any(names(state) %in% 'grade')){
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
        state$grade <- grade_map[state$grade]
    }

        
    if(exhibit %in% c('hqt_classes','staff_degree')){
        cat_map <- c("SEC"="Secondary Schools",
                            "ELEM"="Elementary Schools",
                            "MIDDLE"="Middle Poverty Quartiles Schools",
                            "HIGH"="High Poverty Quartile Schools",
                            "LOW"="Low Poverty Quartile Schools",
                            "All"="All Schools")
        state[[4]] <- cat_map[state[[4]]]
    }
        
    if(exhibit %in% c('enrollment','enrollment_equity','ell')){
        state$year <- paste0(state$year,"-",state$year+1)
        }
    else if(exhibit %in% 'naep_results'){
        state$year <- state$year
        }
    else{
        state$year <- paste0(state$year-1,"-",state$year)
        }
        return(state[c(1:2,ncol(state),3:(ncol(state)-1))])
 	      }
}
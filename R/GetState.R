options(stringsAsFactors=FALSE)
`%notin%` <- function(x,y) !(x %in% y)

GetState <- function(exhibit){
    exhibit <- tolower(exhibit)
	if(exhibit %notin% c("graduation","dccas","attendance","naep_results","hqt_classes","staff_degree","mgp_scores","ell","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","amo_targets","expulsions","mid_year_entry_and_withdrawal")){
    stop("The requested exhibit does not exist.\r
    Please check the spelling of your exhibit using GetStateExhibits() to get the correct names of LearnDC's State Exhibits.")
	}
	else {
    state <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=state&s[][org_type]=DC&sha=promoted"))
    state$org_name <- "DC"

    if(exhibit %in% c('graduation','dccas','attendance','special_ed','enrollment','mgp_scores','naep_results','suspensions','enrollment_equity','amo_targets','accountability')){
        state$subgroup <- tolower(state$subgroup)
         subgroup_map <- c("bl7"="african american",
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
        state$subgroup <- subgroup_map[state$subgroup]
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
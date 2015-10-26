options(stringsAsFactors=FALSE)
state_exhibit_names <- c("graduation","dccas","attendance","naep_results","hqt_classes","staff_degree","mgp_scores","ell","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","amo_targets","expulsions")
`%notin%` <- function(x,y) !(x %in% y)

GetState <- function(exhibit){
	if(exhibit %notin% state_exhibit_names){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetStateExhibits() to get the correct names of LearnDC's State Exhibits.")
	}
	else {
    state <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=state&s[][org_type]=DC&sha=promoted"))
    state$org_name <- "DC"
    state[c(1:2,ncol(state),3:(ncol(state)-1))]
 	}
 }
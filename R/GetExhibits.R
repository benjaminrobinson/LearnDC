options(stringsAsFactors=FALSE)
`%notin%` <- function(x,y) !(x %in% y)

GetExhibits <- function(level){
	level <- tolower(level)
	if(level %notin% c("school","lea","sector","state")){
    stop("The requested level does not exist.\r
Please only use these levels as arguments for this function:  school, lea, sector, and state.")
  } else {
  	exhibits <- list(
	'school' = c("graduation","dccas","attendance","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","accountability_classification","pcsb_pmf","mid_year_entry_and_withdrawal"),
	'lea' = c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment"),
	'sector' = c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment"),
	'state' = c("graduation","dccas","attendance","naep_results","hqt_classes","staff_degree","mgp_scores","ell","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","amo_targets","mid_year_entry_and_withdrawal")
)
	return(print(exhibits[[level]]))
	}
}

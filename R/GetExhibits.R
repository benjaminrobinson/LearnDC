#' A Function to Return Exhibit Names from LearnDC's data exhibits.
#'
#' @description This function retrieves the names of the exhibits from 
#' LearnDC.org's various levels of exhibits (school, LEA, sector, and state
#' @usage GetExhibits("level")
#' @param level character, an aggregation level - one of 
#' c("school","lea","sector","state")
#' 
#' @references \url{http://learndc.org/schoolprofiles/search}
#' @author Benjamin Robinson, \email{benj.robinson2@gmail.com}
#' 
#' @return data frame 
#' @export
#'
#' @examples
#' GetExhibits("school")
#' GetExhibits("lea")
#' GetExhibits("sector")
#' GetExhibits("state")

GetExhibits <- function(level){
	level <- tolower(level)
	if(level %notin% c("school","lea","sector","state")){
    stop("The requested level does not exist.\r
Please only use these levels as arguments for this function:  school, lea, sector, and state.")
  } else {
  exhibits <- list(
'school'=c("graduation","dccas","attendance","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","accountability_classification","pcsb_pmf","mid_year_entry_and_withdrawal","parcc","overview"),
'lea'=c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","parcc"),
'sector'=c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","parcc"),
'state'=c("graduation","dccas","attendance","naep_results","hqt_classes","staff_degree","mgp_scores","ell","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","amo_targets","mid_year_entry_and_withdrawal","parcc")
)
	return(print(exhibits[[level]]))
	}
}

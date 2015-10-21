#' Access the exhibit names for the data coming from LearnDC's API for the DC State Report Card.
#'
#' This function allows you to access the exhibit names data from LearnDC's API for the DC State Report Card section of the site.
#' @return An R vector of the exhibit names that feed LearnDC's DC State Report Card.
#' @export
#' @examples
#' GetStateExhibits()

options(stringsAsFactors=FALSE)
GetStateExhibits <- function() {print(c('graduation','dccas','attendance','naep_results','hqt_classes','staff_degree','mgp_scores','ell','special_ed','enrollment','suspensions','expulsions','enrollment_equity','accountability','amo_targets','expulsions'))
}
#' Access the exhibit names for the data coming from LearnDC's API for the School Profiles.
#'
#' This function allows you to access the exhibit names data from LearnDC's API for the School Profiles section of the site.
#' @return An R vector of the exhibit names that feed LearnDC's School Profiles.
#' @export
#' @examples
#' GetSchoolExhibits()

options(stringsAsFactors=FALSE)
GetSchoolExhibits <- function() {print(c('graduation','dccas','attendance','hqt_classes','staff_degree','mgp_scores','special_ed','enrollment','suspensions','expulsions','enrollment_equity','accountability','accountability_classification'))
}
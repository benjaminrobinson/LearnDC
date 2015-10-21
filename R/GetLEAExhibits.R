#' Access the exhibit names for the LEA and Sector Report Cards.
#'
#' This function allows you to access the exhibit names data from LearnDC's API for the LEA and Sector Report Cards section of the site.
#' @return An R vector of the exhibit names that feed LearnDC's LEA and Sector Profiles.
#' @export
#' @examples
#' GetLEAExhibits()

options(stringsAsFactors=FALSE)
GetLEAExhibits <- function() {print(c('graduation','dccas','hqt_classes','staff_degree','mgp_scores','special_ed','enrollment'))
}
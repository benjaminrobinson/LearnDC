#' Access the data for DC as a whole from LearnDC's API.
#'
#' This function allows you to access data from LearnDC's API for the DC State Report Card section of the site.
#' @return An R dataframe of the data from the API feeding LearnDC's DC State Report Card.
#' @export
#' @examples
#' state_grad <- GetState("graduation")
#' print(head(state_grad))

options(stringsAsFactors=FALSE)
GetState <- function(exhibit){
    read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=state&s[][org_type]=DC&sha=promoted"))
  }
.onAttach <- function(...) {
  return(
  packageStartupMessage(
  	"Welcome to the development version of the LearnDC R Package! ",
    "Thank you for using the package. Feel free to explore. ",
    "If you encounter a clear bug, please file a ",
    "minimal reproducible example at https://github.com/benjaminrobinson/LearnDC/issues. ",
    "For questions and other discussion, please email the package creator at ",
    "benj.robinson2@gmail.com. Look for exhibit documentation coming soon!")
  )
}
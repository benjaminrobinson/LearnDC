LearnDC
====

An R package for pulling live data directly from LearnDC.org, a collaborative initiative led by the Office of the State Superintendent of Education (OSSE) in partnership with other agencies and organizations that support young people in DC. The initiative builds on the knowledge of the DC education community to put reliable, trusted information about education at the public's fingertips. LearnDC is a one-stop source for information and resources about education that create opportunities for DC students in college, careers and life. LearnDC empowers students, parents, educators and communities with the knowledge they need – from information about caring for a young child to tools for engaging with our local schools.

## How to Install the Package
Using the `devtools` package (`install.packages(devtools)`) and the function `install_github()`, download the package to your local computer by entering the following code in your instance of R or RStudio.

     devtools::install_github("benjaminrobinson/LearnDC")
     library(LearnDC)
     

##Two Different Types of Functions
LearnDC uses two different types of functions:
	 `Get()` functions and `GetExhibitNames()` functions. `Get()` functions grab the actual live data that is powering LearnDC's data visualizations on the site. `GetExhibitNames()` functions return the exhibit names that you must provide to the `Get()` functions to retrieve the data.

For example, these are the exhibit names for the [DC Report Card](http://learndc.org/schoolprofiles/view?s=dc#reportcard): `graduation`, `dccas`, `attendance`, `naep_results`, `hqt_classes`, `hqt_classes`, `mgp_scores`, `ell`, `special_ed`, `enrollment`, `suspensions`, `expulsions`, `enrollment_equity`, `accountability`, `amo_targets`, and `expulsions`.

So in order to return DC/State level adjusted cohort graduation rates, the function to use to discover the [DC Report Card](http://learndc.org/schoolprofiles/view?s=dc#reportcard) exhibit names using the function `GetStateExhibitNames()` and then use `GetState("graduation")` to retrieve the year-over-year subgroup level graduation rates.

##Error
If you get an error, please try restarting your instance of R or RStudio and run the package using `library(LearnDC)` again. If this does not work, try re-installing the package using `devtools::install_github("benjaminrobinson/LearnDC")` and then running `library(LearnDC)` again. If this error persists, email the creator of this package, [Benjamin Robinson](<mailto:benj.robinson2@gmail.com>,?subject=Issue with LearnDC R Package) or put in an [Issue](https://github.com/benjaminrobinson/LearnDC/issues) on this package's GitHub repository page.
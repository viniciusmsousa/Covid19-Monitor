# Building a Prod-Ready, Robust Shiny Application.
# 
# README: each step of the dev files is optional, and you don't have to 
# fill every dev scripts before getting started. 
# 01_start.R should be filled at start. 
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
# 
# 
########################################
#### CURRENT FILE: ON START SCRIPT #####
########################################

## Fill the DESCRIPTION ----
## Add meta data about your application
golem::fill_desc(
  pkg_name = "covid19", 
  pkg_title = "Covid-19 Tracker", 
  pkg_description = "Track the Spread of Covid-19 in Brazil and the World.",  
  author_first_name = "Vinicius", 
  author_last_name = "M. de Sousa",
  author_email = "vinisousa04@gmail.com",
  repo_url = "https://github.com/viniciusmsousa/covid-19.git"
)     

## Set {golem} options ----
golem::set_golem_options()

## Create Common Files ----
usethis::use_ccby_license(name = "Vinicius M. de Sousa")
usethis::use_readme_rmd(open = FALSE)
usethis::use_lifecycle_badge("Experimental")

## Use git ----
usethis::use_git()


## Use Recommended Packages ----
golem::use_recommended_deps()

## Favicon ----
# If you want to change the favicon (default is golem's one)
golem::use_favicon() # path = "path/to/ico". Can be an online file. 

## Add helper functions ----
golem::use_utils_ui()
golem::use_utils_server()

# You're now set! ----

# go to dev/02_dev.R
rstudioapi::navigateToFile( "dev/02_dev.R" )


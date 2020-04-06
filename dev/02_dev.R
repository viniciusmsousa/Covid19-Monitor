# Building a Prod-Ready, Robust Shiny Application.
# 
# README: each step of the dev files is optional, and you don't have to 
# fill every dev scripts before getting started. 
# 01_start.R should be filled at start. 
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
# 
# 
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Add one line by package you want to add as dependency
usethis::use_package("dplyr")
usethis::use_package("tidyr")
usethis::use_package("shiny")
usethis::use_package("ggplot2")
usethis::use_package("shinythemes")
usethis::use_package("leaflet")
usethis::use_package("geobr")
usethis::use_package("rvest")
usethis::use_package("stringr")
usethis::use_package("shinycssloaders")
usethis::use_package("plotly")
usethis::use_package("utils")
usethis::use_package("xml2")
usethis::use_package("shinydashboard")
usethis::use_package("rmarkdown")
usethis::use_package("sf")
usethis::use_package("zoo")
usethis::use_package("DT")
usethis::use_package("echarts4r")
## Add modules ----
## Create a module infrastructure in R/
golem::add_module(name = "Brazil_Monitor") # Name of the module


## Add helper functions ----
## Creates ftc_* and utils_*
#golem::add_fct( "helpers" ) 
#golem::add_utils( "helpers" )

## External resources
## Creates .js and .css files at inst/app/www
#golem::add_js_file( "script" )
#golem::add_js_handler( "handlers" )
#golem::add_css_file( "custom" )

## Add internal datasets ----
# Shape File do Brasil (Estados)
polygon_br <-  geobr::read_state(year=2018)

# Shape File das Cidades por Estado
covid19::getBrazilCovid19Data(url = "https://data.brasil.io/dataset/covid19/caso.csv.gz") %>% 
  dplyr::as_tibble() %>% 
  dplyr::select(state) %>% 
  dplyr::distinct() %>% 
  unlist() -> lista_estados
shape_file_estados <- vector(mode = "list",length = length(lista_estados))
shape_file_estados <- purrr::map(
  lista_estados,
  .f = function(sigla_estado){geobr::read_municipality(year = 2018,code_muni = sigla_estado)}
)
names(shape_file_estados) <- lista_estados

# Salvando Arquivo
usethis::use_data(polygon_br,shape_file_estados,internal = T,overwrite = T)



## Tests ----
## Add one line by test you want to create
#usethis::use_test( "app" )

# Documentation

## Vignette ----
#usethis::use_vignette("covid19")
#devtools::build_vignettes()

## Code coverage ----
## (You'll need GitHub there)
#usethis::use_github()
#usethis::use_travis()
#usethis::use_appveyor()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")


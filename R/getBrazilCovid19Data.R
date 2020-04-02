#' Get Covid-19 Brasil Data from Brasil.io
#' 
#' This function retrieves the data from the https://www.brasil.io/home page.
#'
#' @param url String with the url 
#'
#' @return
#' @export
#'
#' @import dplyr
#' @import utils
getBrazilCovid19Data <- function(url = "https://data.brasil.io/dataset/covid19/caso.csv.gz"){
  out <- tryCatch({
    # Casos Covid-19
    tmp <- tempfile()
    utils::download.file(url,tmp)
    
    #covid-19 br
    utils::read.csv(
      gzfile(tmp),
      header=TRUE,
      stringsAsFactors=FALSE) %>% 
      as_tibble() -> df_covid19BR
    
    df_covid19BR
  },
  error = function(cond){
    print("Error in function getBrazilData()")
    message(cond)
  })
}
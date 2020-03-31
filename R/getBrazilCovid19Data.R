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
getBrazilCovid19Data <- function(url){
  out <- tryCatch({
    require(dplyr)
    # Casos Covid-19
    tmp <- tempfile()
    download.file(url,tmp)
    
    #covid-19 br
    read.csv(
      gzfile(tmp),
      header=TRUE,
      stringsAsFactors=FALSE) %>% 
      as_tibble() -> df_covid19BR
    
    df_covid19BR
  },
  error = function(cond){
    print("Erro na função getBrazilData()")
    message(cond)
  })
}
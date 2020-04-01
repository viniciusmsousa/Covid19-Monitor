#' Return Last Time Brazil Covid-19 Cases Was Updated
#'
#' @param url "https://brasil.io/dataset/covid19/caso"
#' @param xpath "/html/body/div[1]/div/div[2]/div[2]/div[2]/p"
#'
#' @return String with the data information
#' @export
#' 
#' @import xml2
#' @import rvest
#' @import stringr
getLastDataUpdateTimeBrasilIO <- function(url = "https://brasil.io/dataset/covid19/caso",xpath = "/html/body/div[1]/div/div[2]/div[2]/div[2]/p"){
  out <- tryCatch(
    {
      url %>%
        xml2::read_html() %>%
        html_nodes(xpath = xpath) %>% 
        as.character() %>% 
        str_remove_all("\n") %>% 
        str_remove_all("<p>") %>% 
        str_remove_all("</p>") %>% 
        str_squish() -> last_update_time
    },
    error = function(cond){
      message("Error in function getLastDataUpdateTimeBrasilIO()")
      message(cond)
    }
  )
  return(out)
}
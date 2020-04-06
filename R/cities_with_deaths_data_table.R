#' Datatable with Cities where Deaths were registered
#'
#' @param df Data Frame. Output from function getBrazilCovid19Data()
#' @param selected_state String. Selected state (input$selected_state)
#'
#' @return DT::datatable()
#' @export
#'
#' @import dplyr
#' @import DT
cities_with_deaths_data_table <- function(df, selected_state){
  out <- tryCatch({
    df %>% 
      filter(
        place_type=="city",
        state==selected_state,
        is_last=="True",
        deaths>0
      ) %>% 
      select(city,deaths) %>%
      rename(
        Cidade = city,
        Mortes = deaths
      ) %>% 
      arrange(desc(Mortes)) -> df_deaths 
    
    DT::datatable(df_deaths,
                  rownames = F,
                  options = list(dom = 'tip'),
                  caption = htmltools::tags$caption(
                    style = 'caption-side: top; text-align: left;',
                    htmltools::strong('Cidades com Mortes Registradas')
                  ))
  },
  error = function(cond){
    print("Error in function cities_with_deaths()")
    message(cond)
  })
  return(out)
}







#' Plot Multiples States new cases over time
#' 
#' The objective of this function is to make it possible to 
#' check the new cases trend of the states
#'
#' @param df Data Frame. Output from getBrazilCovid19Data() function.
#' @param i_ini Integer. index of unique(df$state) to start.
#' @param i_final Integer. Index of unique(df$state) to end
#'
#' @return
#' @export
#'
#' @import dplyr
#' @import ggplot2
#' @import zoo
#'
plot_multiple_states_mavg_new_cases <- function(df,i_ini,i_final){
  out <- tryCatch({
    estados <- unique(df$state)
    if(is.null(i_final)){
      i_final <- length(estados)
    }

    df %>% 
      filter(
        state%in%estados[i_ini:i_final],
      ) %>% 
      mutate(date=as.Date(date)) %>%
      filter(place_type=="state") %>% 
      group_by(state,date) %>% 
      summarise(
        confirmed = sum(confirmed,na.rm = T),
        deaths = sum(deaths,na.rm = T)
      ) %>% 
      mutate(
        new_cases = confirmed - lag(confirmed, default = 0),
        new_deaths = deaths - lag(deaths, default = 0)
      ) %>% 
      ungroup() %>%
      mutate(
        new_cases_ma_7d = zoo::rollmean(x = new_cases,7,align="right",fill=NA),
        new_deaths_ma_7d = zoo::rollmean(x = new_deaths,7,align="right",fill=NA)
      ) %>% 
      ggplot(aes(x=date,y=new_cases_ma_7d,fill=state,color=state))+
      geom_line()+
      geom_point()+
      facet_grid(
        rows = vars(state),
        scales = "free_y"
      )+theme_light()
  },
  error = function(cond){
    print("Error in function plot_multiple_states_mavg_new_cases()")
    message(cond)
  })
  return(out)
}
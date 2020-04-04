#' Plot New Cases and New Deaths Moving Average
#'
#'
#' This function returns the plot of the 7 day moving average of new cases and new deaths.
#'
#'
#' @param df Data Frame returned from getBrazilCovid19Data() function. 
#' @param state String. State name in 2 letter. If NULL 9default) then return the plot for the
#' country aggragated data.
#' @param state_view Logical. Indicating whether is to compute per state or aggregated for the whole country.
#'
#' @return ggplot object
#' @export
#' 
#' @import ggplot2
#' @import dplyr
#' @import tidyr
#' @import zoo
plot_moving_avg <- function(df,state_selected,state_view){
  
  out <- tryCatch({
    # Aggragating Data Frame --------------------------------------------------
    if(state_view==T){
      print("plot_moving_avg: state_view==T")
      df %>% 
        mutate(date=as.Date(date)) %>%
        filter(state==state_selected,
               place_type=="state") %>%
        group_by(date) %>% 
        summarise(
          confirmed = sum(confirmed,na.rm = T),
          deaths = sum(deaths,na.rm = T)
        ) %>% 
        mutate(
          new_cases = confirmed - lag(confirmed, default = 0),
          new_deaths = deaths - lag(deaths, default = 0)
        ) %>% 
        ungroup() %>%
        arrange(date) %>% 
        mutate(
          `Novos Casos` = zoo::rollmean(x = new_cases,7,align="right",fill=NA),
          `Novas Mortes` = zoo::rollmean(x = new_deaths,7,align="right",fill=NA)
        ) %>% 
        gather(
          "Variavel",
          "moving_average",
          c(`Novos Casos`,`Novas Mortes`)
        ) -> df_plot
    
    }
    else{
      print("plot_moving_avg: state_view==F")
      df %>% 
        mutate(date=as.Date(date)) %>%
        filter(place_type=="state") %>% 
        group_by(date) %>% 
        summarise(
          confirmed = sum(confirmed,na.rm = T),
          deaths = sum(deaths,na.rm = T)
        ) %>% 
        mutate(
          new_cases = confirmed - lag(confirmed, default = 0),
          new_deaths = deaths - lag(deaths, default = 0)
        ) %>% 
        ungroup() %>%
        arrange(date) %>% 
        mutate(
          `Novos Casos` = zoo::rollmean(x = new_cases,7,align="right",fill=NA),
          `Novas Mortes` = zoo::rollmean(x = new_deaths,7,align="right",fill=NA)
        ) %>% 
        gather(
          "Variavel",
          "moving_average",
          c(`Novos Casos`,`Novas Mortes`)
        ) -> df_plot
    }
    
    
    # Creating plot -----------------------------------------------------------
    df_plot %>% 
      ggplot(aes(x=date,y=moving_average,color=Variavel))+
      geom_line()+
      geom_point()+
      xlab("")+
      ylab("Media Movel 7 dias")+
      ggtitle(
        "Tendencia de Novos Casos Confirmados e Mortes do Covid-19"
      )+
      load_custom_theme() -> plot
    plot
  },
  error = function(cond){
    #print("Error in function plot_moving_avg()")
    print(cond)
  })
  return(out)
}
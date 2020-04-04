#' Plot Death Rate per State Over Time
#'
#' @param df_covid19 Data Frame Returned from getBrazilCovid19Data()  
#'
#' @return
#' @export
#'
#' @import dplyr
#' @import ggplot2
plot_death_confirmed_over_time_states <- function(df_covid19){
  tryCatch({
    df_covid19 %>% 
      filter(place_type=="state",
             deaths>=1) %>% 
      mutate(date = as.Date(date)) %>% 
      group_by(state) %>% 
      arrange(date) %>% 
      mutate(n_day = row_number()) %>% 
      ungroup() %>% 
      select(date,state,confirmed,deaths,death_rate,n_day,estimated_population_2019) %>%
      mutate(date = as.Date(date),
             population_million = estimated_population_2019/1e06,
             death_rate = death_rate*100,
             confirmed_per_million = round(confirmed/population_million,2)) %>% 
      select(date,state,n_day,confirmed_per_million,death_rate) -> df_plot_connected
    max_days <- max(df_plot_connected$n_day)
    
    
    df_plot_connected %>%
      ggplot(aes(x=.data$n_day,y=.data$death_rate,color=.data$state))+
      geom_line(size=0.8)+
      geom_point(size=2)+
      # Plot titles and Labels
      ggtitle(label = "Taxa de Mortalidade nos Estados")+
      xlab("Dias desde a Primeira Morte")+
      scale_x_continuous(breaks = seq(1,max_days,1))+
      ylab("Taxa de Mortalidade")+
      load_custom_theme() -> plot
    plot
  },
  error=function(cond){
    print("Error in function plot_death_confirmed_over_time_states()")
    message(cond)
  })
}
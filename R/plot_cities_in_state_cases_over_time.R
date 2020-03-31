#' Plot the Evolution Within Cities of a Selected State
#'
#' @param df_covid19 Data Frame Returned from getBrazilCovid19Data()  
#' @param State String with selected state (input$selected_state)
#'
#' @return
#' @export
#'
#' @import ggplot2
#' @import dplyr
plot_cities_in_state_cases_over_time <- function(df_covid19,State){
  out <- tryCatch({
    df_covid19 %>% 
      filter(state==State,
             place_type=="city") %>% 
      select(date,city,confirmed,confirmed_per_100k_inhabitants,deaths) %>%
      mutate(date= as.Date(date)) %>% 
      arrange(city,date) %>% 
      filter(confirmed>=1) %>% 
      group_by(city) %>% 
      mutate(n_day = row_number()) -> df_por_cidades
    
    max_days <- max(df_por_cidades$n_day)
    df_por_cidades %>% 
      ggplot(aes(x=.data$n_day,y=.data$confirmed_per_100k_inhabitants,color=.data$city))+
      geom_line(size=0.8)+
      geom_point(size=2)+
      # Plot titles and Labels
      # ggtitle(label = "Covid-19 Spread in Brazilian States",
      #         subtitle = "Normalized by Million of Habitants.")+
      xlab("Number of Days Since First Confirmed Case")+
      scale_x_continuous(breaks = seq(1,max_days,1))+
      ylab("Number of Confirmed Cases per 100k Habitants")+
      theme_minimal()+
      theme(
        axis.title.x = element_text(face = "bold",
                                    size = 12),
        axis.title.y = element_text(face = "bold",
                                    size = 12),
        title = element_text(face = "bold"),
        axis.text.x = element_text(face = "bold"),
        axis.text.y = element_text(face = "bold"),
        legend.title = element_blank()
      ) -> p
    p
  },
  error=function(cond){
    print("Error in Function plot_cities_in_state_case()")
    message(cond)
  })
  return(out)
}
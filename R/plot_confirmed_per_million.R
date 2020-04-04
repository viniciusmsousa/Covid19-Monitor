#' Plot Evolution over Time per State Nornalizazed by Million of Habitants
#'
#' @param df Data Frame Returned from getBrazilCovid19Data()  
#' @param ln_confirmed Logical
#'
#' @return
#' @export
#'
#' @import dplyr
#' @import ggplot2
#' @import plotly
plot_confirmed_per_million <- function(df,ln_confirmed=F){
  out <- tryCatch({
    
    requireNamespace("dplyr")
    print("Start data transformation")
    df %>%
      filter(place_type=="state") %>% 
      mutate(
        population_per_million = estimated_population_2019/1e06,
        confirmed_per_million = confirmed/population_per_million,
        date = as.Date(date)
      ) %>% 
      filter(confirmed_per_million>=1) -> df
    
    
    if(ln_confirmed==T){
      df <- df %>% 
        mutate(
          confirmed_per_million = log(confirmed_per_million)
        )
    }
    df %>% 
      group_by(state) %>% 
      arrange(date) %>% 
      mutate(n_day=row_number()) %>%
      ungroup() -> df
    print("Data Transformation done")
    
    print("Getting max number of days")
    max_days <- df %>%
      filter(.data$n_day==max(.data$n_day)) %>%
      select(.data$n_day) %>%
      distinct() %>%
      unlist()
    
    
    max_confirmed_normalized <- max(df$confirmed_per_million)*1.1
    
    tibble(
      n_day = seq(1,max_days),
      doubles_2days = .data$n_day/2
    ) %>%
      filter(.data$doubles_2days <= max_confirmed_normalized) -> doubles_2days_df
    
    tibble(
      n_day = seq(1,max_days),
      doubles_5days = .data$n_day/5
    ) %>%
      filter(.data$doubles_5days <= max_confirmed_normalized) -> doubles_5days_df
    
    tibble(
      n_day = seq(1,max_days),
      doubles_10days = .data$n_day/10
    ) %>%
      filter(.data$doubles_10days <= max_confirmed_normalized) -> doubles_10days_df
    
    adjust_double_space <- -1
    df %>%
      ggplot(aes(x=.data$n_day,y=.data$confirmed_per_million,color=.data$state))+
      geom_line(size=0.8)+
      geom_point(size=2)+
      #Plot titles and Labels
      ggtitle(label = "Covid-19 por Estados nos Brasil",
              subtitle = "Normalizado por Milhoes de Hab.")+
      xlab("Dias desde o Primeiro Caso por Milhao de Hab.")+
      scale_x_continuous(breaks = seq(1,max_days,1))+
      ylab(ifelse(test = ln_confirmed==T,yes = "Ln de Casos Confirmados por Milhao de Hab.",no = "Casos Confirmados por Milhao de Hab."))+
      load_custom_theme() -> plot
    
    if(ln_confirmed==T){
      plot+
        # Doubles every 2 days
        geom_line(data = doubles_2days_df,aes(x=.data$n_day,y=.data$doubles_2days),color="black",linetype = "dashed",show.legend = F)+
        annotate(geom = "text",x = max(doubles_2days_df$n_day)+adjust_double_space,y = max(doubles_2days_df$doubles_2days),label="Dobra a cada 2 Dias") +
        # Doubles every 5 days
        geom_line(data = doubles_5days_df,aes(x=.data$n_day,y=.data$doubles_5days),color="black",linetype = "dashed",show.legend = F)+
        annotate(geom = "text",x = max(doubles_5days_df$n_day)+adjust_double_space,y = max(doubles_5days_df$doubles_5days),label="Dobra a cada 5 Dias") +
        # Doubles every 10 days
        geom_line(data = doubles_10days_df,aes(x=.data$n_day,y=.data$doubles_10days),color="black",linetype = "dashed",show.legend = F)+
        annotate(geom = "text",x = max(doubles_10days_df$n_day)+adjust_double_space,y = max(doubles_10days_df$doubles_10days),label="Dobra a cada 10 Dias") -> plot
    }
    plotly::ggplotly(plot)
  },
  error=function(cond){
    print("Error in function plot_confirmed_per_million()")
    message(cond)
  })
  
  return(out)
}
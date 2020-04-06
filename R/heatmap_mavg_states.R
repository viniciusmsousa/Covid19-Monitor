#' Plot Heatmap of Moving Average Cases
#'
#' @param df Data Frame. Output from function getBrazilCovid19Data()
#'
#' @return echarts4r plot
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import echarts4r
heatmap_mavg_states <- function(df){
  out <- tryCatch({
    df %>% 
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
      arrange(date) %>% 
      mutate(
        new_cases_mavg = round(zoo::rollmean(x = new_cases,7,align="right",fill=NA),2),
        new_deaths_mavg = zoo::rollmean(x = new_deaths,7,align="right",fill=NA)
      ) %>%
      select(state,date,new_cases_mavg,new_deaths_mavg) %>% 
      tidyr::drop_na(new_cases_mavg) %>% 
      echarts4r::e_charts(date) %>% 
      echarts4r::e_heatmap(state, new_cases_mavg) %>% 
      echarts4r::e_visual_map(new_cases_mavg) %>% 
      echarts4r::e_title("Media Movel de Novos Casos (MMNC) dos Ultimos 7 dias por Estados") %>% 
      echarts4r::e_tooltip(formatter = htmlwidgets::JS("
              function(params){
                return('<strong>' + params.value[1] + 
                       '</strong><br />Data: ' + params.value[0] + 
                       '<br />MMNC: ' + params.value[2]) 
                        }
                  "))
  },
  error=function(conf){
    print("Error in function heatmap_mavg_states()")
    message(cond)
  })
  return(out)
}
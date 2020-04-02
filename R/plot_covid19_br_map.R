#' Plots Covid-19 Per State in Brazil Map
#'
#' @param covid19_df Data Frame resulted from function get_covid19_br_data()
#' @param polygon_df Shape files resultado geobr::state(year==2018)
#'
#' @return leaflet plot
#' @export
#'
#' @import dplyr
#' @import leaflet
#' @import sf
plot_covid19_br_map <- function(covid19_df,polygon_df){

  out <- tryCatch({
    message("plot_covid19_br_map(): Start")
    
    print("plot_covid19_br_map(): Computing df_aux")
      covid19_df %>% 
        filter(place_type=="state",
               is_last=="True") %>%
        select(date,state,confirmed,deaths,death_rate,estimated_population_2019) %>% 
        mutate(
          death_rate = death_rate*100,
          cases_per_million = confirmed/(estimated_population_2019/1e6)
        ) %>% 
        select(-c(estimated_population_2019)) -> df_aux
      print("plot_covid19_br_map(): df_aux computed")
      
      print("plot_covid19_br_map(): Computing df_br_covid19_geo_state")
      polygon_df %>% 
        left_join(as.data.frame(df_aux),
                  by = c("abbrev_state"="state")) -> df_br_covid19_geo_state
      print("plot_covid19_br_map(): df_br_covid19_geo_state Computed")
      
      print("plot_covid19_br_map(): Setting Color pallet and labels")
      pal <- leaflet::colorNumeric(
        palette = "YlOrRd",
        domain = df_br_covid19_geo_state$cases_per_million
      )
      
      labels <- sprintf(
        "<strong>%s</strong><br/>%.2f por Milhao de Hab.<br/>%d Casos Confirmados<br/>%d Mortes",
        df_br_covid19_geo_state$abbrev_state,
        df_br_covid19_geo_state$cases_per_million,
        df_br_covid19_geo_state$confirmed,
        df_br_covid19_geo_state$deaths
      ) %>% lapply(htmltools::HTML)
      print("plot_covid19_br_map(): Color pallet and labels setted")
      
      print("plot_covid19_br_map(): Creating Map")
      leaflet::leaflet(df_br_covid19_geo_state) %>% 
        leaflet::addProviderTiles("CartoDB.Positron") %>% 
        leaflet::addPolygons(
          fillColor = ~pal(cases_per_million),
          weight = 2,
          opacity = 1,
          color = "white",
          dashArray = "3",
          fillOpacity = 0.7,
          highlight = leaflet::highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
          label = labels,
          labelOptions = leaflet::labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto")
        ) %>% 
        leaflet::addLegend(pal = pal, values = ~cases_per_million, opacity = 0.7, title = "Numero de Casos<br/>por Milhao de Hab.",
                  position = "bottomleft") -> map
      print("plot_covid19_br_map(): Map Created")
      
      print("plot_covid19_br_map(): Returing leaflet object")
      map
   
  },
  error=function(cond){
    print("Error in function plot_covid19_br_map()")
    message(cond)
  })
  return(out)
}
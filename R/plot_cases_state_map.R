#' Plots the Cases for Each City Given a Selected State
#'
#' @param df_covid19 Data Frame Returned from getBrazilCovid19Data()  
#' @param State String with selected state (input$selected_state)
#' @param state_shape_files Shape files of the states
#' @return
#' @export
#' 
#' @import dplyr
#' @import leaflet
plot_cases_state_map <- function(df_covid19,State,state_shape_files){
  out <- tryCatch({
    muni <- shape_file_estados[[State]]
    df_covid19 %>% 
      filter(state==State,
             place_type=="city") -> estado_selecionado
    
    estado_selecionado %>% 
      filter(is_last=="True") %>% 
      select(city,confirmed,deaths,death_rate,city_ibge_code) -> estado_selecionado_plot_mapa
    
    
    muni %>% 
      left_join(
        estado_selecionado_plot_mapa,
        by = c("code_muni"="city_ibge_code")
      ) -> df_plot_estado
    
    
    pal <- leaflet::colorNumeric(
      palette = "YlOrRd",
      domain = df_plot_estado$confirmed
    ) 
    
    labels <- sprintf(
      "<strong>%s</strong><br/>%.d Casos Confirmados<br/>%d Mortes",
      df_plot_estado$name_muni,
      df_plot_estado$confirmed,
      df_plot_estado$deaths
    ) %>% lapply(htmltools::HTML)
    
    leaflet::leaflet(df_plot_estado, options = leaflet::leafletOptions(zoomControl = FALSE)) %>% 
      leaflet::addProviderTiles("CartoDB.Positron") %>% 
      leaflet::addPolygons(
        fillColor = ~pal(confirmed),
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
      leaflet::addLegend(pal = pal, values = ~confirmed, opacity = 0.7, title = "Numero de Casos<br/>Confirmados",
                position = "topright",na.label = "No Cases") -> plot
    plot
  },
  error=function(cond){
    print("Error in function plot_cases_state_map()")
    message(cond)
  })
  return(out)
}
#' Brazil_Monitor UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import shinycssloaders
#' @import leaflet 
#' @import dplyr
#' @import geobr

mod_Brazil_Monitor_ui <- function(id){
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        h3("Confirmed Covid-19 Cases:"),h4(textOutput(ns("confirmed_br"))),
        br(),
        h3("Deaths Cases:"),h4(textOutput(ns("deaths_br")))
      ),
      mainPanel(
        tabsetPanel(
          tabPanel(title = "General View (Map)",
                   leaflet::leafletOutput(outputId = ns("br_covid19_map"),height = "750") %>%
                     shinycssloaders::withSpinner()
          ),
          tabPanel(
            title = "Cases Over Time Per State",
            uiOutput(outputId = ns("ln_confirmed")),
            plotly::plotlyOutput(outputId = ns("cases_over_time_per_state"),height = "650")
          )
        )
      )
    )
  )

}
    
#' Brazil_Monitor Server Function
#'
#' @noRd 
mod_Brazil_Monitor_server <- function(input, output, session){
  ns <- session$ns
  # Defining parameters -----------------------------------------------------
  br_covid19_url <- "https://data.brasil.io/dataset/covid19/caso.csv.gz"
  
  
  
  # getting online data -----------------------------------------------------
  covid19_br_data <- getBrazilCovid19Data(url = br_covid19_url)
  polygon_br <-  geobr::read_state(year=2018)
  

  # computing info box ------------------------------------------------------
  info <- covid19_br_data %>% filter(place_type=="state",is_last=="True") %>% select(confirmed,deaths) %>% summarise(confirmed=sum(confirmed,na.rm = T),deaths=sum(deaths,na.rm = T))
  

# Defining Module Outputs -------------------------------------------------
  output$confirmed_br <- renderText({
    info$confirmed
  })
  output$deaths_br <- renderText({
    info$deaths
  })

  output$br_covid19_map <- leaflet::renderLeaflet({
    plot_covid19_br_map(
      covid19_df = covid19_br_data,
      polygon_df = polygon_br
    ) 
  })
  
  output$ln_confirmed <- renderUI({
    selectInput(
      inputId = session$ns("ln_confirmed"),
      label = h5("Natural Log Transformtion"),
      choices = list("Yes" = T, "No" = F),
      selected = T
    )
  })
  output$cases_over_time_per_state <- plotly::renderPlotly({
    #ln_confirmed_input <- reactive()
    plot_confirmed_per_million(
      df = covid19_br_data,
      ln_confirmed = input$ln_confirmed
    )
  })
}
    
## To be copied in the UI
# mod_Brazil_Monitor_ui("Brazil_Monitor_ui_1")
    
## To be copied in the server
# callModule(mod_Brazil_Monitor_server, "Brazil_Monitor_ui_1")
 

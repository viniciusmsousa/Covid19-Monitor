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
#' @import plotly

mod_Brazil_Monitor_ui <- function(id){
  ns <- NS(id)
  tagList(
    sidebarLayout(
      # Brazil Monitor Sidebar --------------------------------------------------
      sidebarPanel(
        width = 3,
        h3("Confirmed Covid-19 Cases:"),h4(textOutput(ns("confirmed_br"))),
        br(),
        h3("Deaths Cases:"),h4(textOutput(ns("deaths_br")))
      ),
      # Brazil Monitor Main Pane Tabs -------------------------------------------
      mainPanel(
        width = 9,
        tabsetPanel(
          # General View (Map) ------------------------------------------------------
          tabPanel(title = "General View (Map)",
                   leaflet::leafletOutput(outputId = ns("br_covid19_map"),height = "750") %>%
                     shinycssloaders::withSpinner()
          ),
          # Cases within State ------------------------------------------------------
          tabPanel(
            title = "Cases within State",
            uiOutput(outputId = ns("selected_state")),
            leaflet::leafletOutput(outputId = ns("confirmed_cases_within_states_map"),height = "650") %>%
              shinycssloaders::withSpinner(),
            br(),
            plotly::plotlyOutput(outputId = ns("confirmed_cases_within_states")) %>%
              shinycssloaders::withSpinner(),
            br()
          ),
          # State Comparison Over Time ----------------------------------------------
          tabPanel(
            title = "State Comparison Over Time",
            uiOutput(outputId = ns("ln_confirmed")),
            plotly::plotlyOutput(outputId = ns("cases_over_time_per_state"),height = "500") %>%
              shinycssloaders::withSpinner(),
            br(),
            plotly::plotlyOutput(outputId = ns("death_rate_over_time_states"),height = "500")
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
  
  # Confirmed Cases and Deaths in Brazil ------------------------------------
  output$confirmed_br <- renderText({
    info$confirmed
  })
  output$deaths_br <- renderText({
    info$deaths
  })


  # States Choropleth Cases Per Million Hab ---------------------------------
  output$br_covid19_map <- leaflet::renderLeaflet({
    plot_covid19_br_map(
      covid19_df = covid19_br_data,
      polygon_df = polygon_br
    ) 
  })
  

  # Confirmed Cases Per State Over Time -------------------------------------
  output$ln_confirmed <- renderUI({
    selectInput(
      inputId = session$ns("ln_confirmed"),
      label = h5("Natural Log Transformtion"),
      choices = list("Yes" = T, "No" = F),
      selected = T
    )
  })
  output$cases_over_time_per_state <- plotly::renderPlotly({
    plot_confirmed_per_million(
      df = covid19_br_data,
      ln_confirmed = input$ln_confirmed
    )
  })
  output$death_rate_over_time_states <- plotly::renderPlotly({
    plot_death_confirmed_over_time_states(
      df_covid19 = covid19_br_data
    )
  })
  
  # Within State ------------------------------------------------------------
  output$selected_state <- renderUI({
    selectInput(
      session$ns("selected_state"), 
      label = h4("State:"),
      choices = unique(covid19_br_data$state),
      multiple = F,
      selected = "SC",
      width = "100%"
    )
  })
  output$confirmed_cases_within_states_map <- leaflet::renderLeaflet({
    plot_cases_state_map(
      df_covid19 = covid19_br_data,
      State = input$selected_state
    )
  })
  output$confirmed_cases_within_states <- plotly::renderPlotly({
    plot_cities_in_state_cases_over_time(
      df_covid19 = covid19_br_data,
      State = input$selected_state
    )
    
  })
}
    
## To be copied in the UI
# mod_Brazil_Monitor_ui("Brazil_Monitor_ui_1")
    
## To be copied in the server
# callModule(mod_Brazil_Monitor_server, "Brazil_Monitor_ui_1")
 

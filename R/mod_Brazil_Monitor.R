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
#' @import shinydashboard
#' @import leaflet 
#' @import dplyr
#' @import geobr
#' @import plotly

mod_Brazil_Monitor_ui <- function(id){
  ns <- NS(id)
  tagList(
    sidebarLayout(
      # Brazil Monitor Sidebar --------------------------------------------------
      sidebarPanel = NULL,
      # sidebarPanel(
      #   width = 3,
      # ),
      # Brazil Monitor Main Pane Tabs -------------------------------------------
      mainPanel(
        width = 12,
        tabsetPanel(
          # General View (Map) ------------------------------------------------------
          tabPanel(title = "General View (Map)",
                   fluidRow(
                     shinydashboard::valueBoxOutput(outputId = ns("confirmed_cases_br"),width = 3),
                     shinydashboard::valueBoxOutput(outputId = ns("deaths_br"),width = 3),
                     shinydashboard::valueBoxOutput(outputId = ns("death_rate_br"),width = 3)
                   ),
                   leaflet::leafletOutput(outputId = ns("br_covid19_map"),height = "750") %>%
                     shinycssloaders::withSpinner()
          ),
          # Cases within State ------------------------------------------------------
          tabPanel(
            title = "Cases within State",
            uiOutput(outputId = ns("selected_state")),
            fluidRow(
              shinydashboard::valueBoxOutput(outputId = ns("confirmed_cases_state"),width = 3),
              shinydashboard::valueBoxOutput(outputId = ns("deaths_state"),width = 3),
              shinydashboard::valueBoxOutput(outputId = ns("death_rate_state"),width = 3),
              textOutput(ns("cities_with_deaths"))
            ),
            leaflet::leafletOutput(outputId = ns("confirmed_cases_within_states_map"),height = "650") %>%
              shinycssloaders::withSpinner(),
            br(),
            plotly::plotlyOutput(outputId = ns("confirmed_cases_within_states"),height = "500") %>%
              shinycssloaders::withSpinner(),
            br()
          ),
          # State Comparison Over Time ----------------------------------------------
          tabPanel(
            title = "State Comparison Over Time",
            uiOutput(outputId = ns("ln_confirmed")),
            plotly::plotlyOutput(outputId = ns("cases_over_time_per_state"),height = "650") %>%
              shinycssloaders::withSpinner(),
            br(),
            plotly::plotlyOutput(outputId = ns("death_rate_over_time_states"),height = "650")
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
  

  # States Choropleth Cases Per Million Hab ---------------------------------
  info <- covid19_br_data %>% filter(place_type=="state",is_last=="True") %>% select(confirmed,deaths) %>% summarise(confirmed=sum(confirmed,na.rm = T),deaths=sum(deaths,na.rm = T))
  
  output$confirmed_cases_br <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      value = info$confirmed,
      subtitle = "Confirmed Covid-19 Cases"
    )
  })
  output$deaths_br <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      value = info$deaths,
      subtitle = "Death Cases"
    )
  })
  output$death_rate_br <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      value = round((info$deaths/info$confirmed)*100,2),
      subtitle = "Death Rate (%)"
    )
  })
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
  
  output$confirmed_cases_state <- shinydashboard::renderValueBox({
    
    value <- covid19_br_data %>%
      filter(
        place_type=="state",
        state==input$selected_state,
        is_last=="True"
      ) %>% 
      select(confirmed) %>% 
      unlist()
    
    shinydashboard::valueBox(
      value = value,
      subtitle = paste0("Confirmed Covid-19 Cases in ",
                        input$selected_state)
    )
  })
  output$deaths_state <- shinydashboard::renderValueBox({
    
    value <- covid19_br_data %>%
      filter(
        place_type=="state",
        state==input$selected_state,
        is_last=="True"
      ) %>% 
      select(deaths) %>% 
      unlist()
    
    shinydashboard::valueBox(
      value = value,
      subtitle = paste0("Death Cases in ",
                        input$selected_state)
    )
  })
  output$death_rate_state <- shinydashboard::renderValueBox({
    
    value <- covid19_br_data %>%
      filter(
        place_type=="state",
        state==input$selected_state,
        is_last=="True"
      ) %>% 
      select(death_rate) %>% 
      unlist()
    
    shinydashboard::valueBox(
      value = round(value*100,digits = 2),
      subtitle = paste0("Death Rate ",
                        input$selected_state,
                        "%")
    )
  })
  output$cities_with_deaths <- renderText({
    
    value <- covid19_br_data %>%
      filter(
        place_type=="city",
        state==input$selected_state,
        is_last=="True",
        deaths >0
      ) %>% 
      select(city) %>% 
      unlist() %>% 
      paste0(collapse = ", ")
    
    paste0("Cidades com Mortos: ",value)

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
 

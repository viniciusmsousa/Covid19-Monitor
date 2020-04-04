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
#' @import plotly

mod_Brazil_Monitor_ui <- function(id){
  ns <- NS(id)

  # UI Parameter ------------------------------------------------------------
  loader_color <- "#3A3F44"

  
  tagList(
    sidebarLayout(
      # Brazil Monitor Sidebar --------------------------------------------------
      sidebarPanel = sidebarPanel(
        width = 3,
        tags$div(
          tags$h3("Sobre"),
          "Esta aplicacao, de codigo aberto, objetiva disponibilizar analises sobre os dados do Covid-19 no Brasil, Estados e Cidades, para ajudar no monitoramento dos dados sobre os casos de ocorrencia e combater a pandemia.
           A aplicacao foi desenvolvida por", tags$a(href="https://www.linkedin.com/in/viniciusmsousa/","Vinicius M. de Sousa"), ", graduado em Ciencias Economicas pela ESAG/UDESC, com a colaboracao do prof. Antonio Heronaldo de Sousa do CCT/UDESC.
           A Reitoria da ", tags$a(href="udesc.br","UDESC "),"disponibilizou toda a infraestrutura de hospedagem da aplicação para a difusao das informacoes de monitoramento na Internet.",
          tags$br()
        ),
        tags$h3("Fonte de Dados"),
        tags$b("Casos e Mortes por Covid-19: "), tags$a(href="https://brasil.io/dataset/covid19/caso", "brasil.io")," que faz a coleta e tratamento dos dados dos boletins das Secretarias Estaduais de Saude.
        E a aplicacao busca os dados mais recentes.", "Ultima atualizacao: ",getLastDataUpdateTimeBrasilIO(),
        tags$br(),
        tags$br(),
        tags$h5("Apoio:"),
        div(
          id = "img-id",
          img(src = "www/logo.png",height="50%", width="50%",align="center")
        )
      ),

      # Brazil Monitor Main Pane Tabs -------------------------------------------
      mainPanel(
        width = 9,
        tabsetPanel(
          # General View (Map) ------------------------------------------------------
          tabPanel(title = "Mapa de Casos no Brasil por Estados",
                   fluidRow(
                     shinydashboard::valueBoxOutput(outputId = ns("confirmed_cases_br"),width = 3),
                     shinydashboard::valueBoxOutput(outputId = ns("deaths_br"),width = 3),
                     shinydashboard::valueBoxOutput(outputId = ns("death_rate_br"),width = 3)
                   ),
                   leaflet::leafletOutput(outputId = ns("br_covid19_map"),height = "710") %>%
                     shinycssloaders::withSpinner(color = loader_color),
                   plotly::plotlyOutput(outputId = ns("br_new_cases_and_deaths_moving_avg"),height = "650") %>% 
                     shinycssloaders::withSpinner(color = loader_color)
          ),
          # Cases within State ------------------------------------------------------
          tabPanel(
            title = "Casos nos Estados",
            uiOutput(outputId = ns("selected_state")),
            fluidRow(
              shinydashboard::valueBoxOutput(outputId = ns("confirmed_cases_state"),width = 3),
              shinydashboard::valueBoxOutput(outputId = ns("deaths_state"),width = 3),
              shinydashboard::valueBoxOutput(outputId = ns("death_rate_state"),width = 3),
              textOutput(ns("cities_with_deaths"))
            ),
            leaflet::leafletOutput(outputId = ns("confirmed_cases_within_states_map"),height = "650") %>%
              shinycssloaders::withSpinner(color = loader_color),
            br(),
            plotly::plotlyOutput(outputId = ns("state_new_cases_and_deaths_moving_avg"),height = "500") %>% 
              shinycssloaders::withSpinner(color = loader_color),
            br(),
            "Dica: Clique duas vezes na legenda da cidade para selecionar apenas a cidade e depois clique uma vez nas outras cidades para adiciona-las.",
            br(),
            plotly::plotlyOutput(outputId = ns("confirmed_cases_within_states"),height = "500") %>%
              shinycssloaders::withSpinner(color = loader_color),
            br()
          ),
          # State Comparison Over Time ----------------------------------------------
          tabPanel(
            title = "Comparacao entre os Estados",
            br(),
            "Dica: Clique duas vezes na legenda do estado para selecionar apenas o estado e depois clique uma vez nos outros estados para adiciona-los.",
            br(),
            uiOutput(outputId = ns("ln_confirmed")),
            plotly::plotlyOutput(outputId = ns("cases_over_time_per_state"),height = "650") %>%
              shinycssloaders::withSpinner(color = loader_color),
            br(),
            plotly::plotlyOutput(outputId = ns("death_rate_over_time_states"),height = "650") %>%
              shinycssloaders::withSpinner(color = loader_color)
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

  
  # Loading data ------------------------------------------------------------
  covid19_br_data <- getBrazilCovid19Data(url = br_covid19_url)
  load("R/sysdata.rda") #polygon_br,shape_file_estados
  
  

  # States Choropleth Cases Per Million Hab ---------------------------------
  info <- covid19_br_data %>% filter(place_type=="state",is_last=="True") %>% select(confirmed,deaths) %>% summarise(confirmed=sum(confirmed,na.rm = T),deaths=sum(deaths,na.rm = T))
  
  output$confirmed_cases_br <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      value = info$confirmed,
      subtitle = "Casos Confirmados"
    )
  })
  output$deaths_br <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      value = info$deaths,
      subtitle = "Mortes"
    )
  })
  output$death_rate_br <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      value = round((info$deaths/info$confirmed)*100,2),
      subtitle = "Tx. de Mortalidade (%)"
    )
  })
  output$br_covid19_map <- leaflet::renderLeaflet({
    plot_covid19_br_map(
      covid19_df = covid19_br_data,
      polygon_df = polygon_br
    ) 
  })
  output$br_new_cases_and_deaths_moving_avg <- plotly::renderPlotly({
    plotly::ggplotly(plot_moving_avg(df = covid19_br_data,state_view=F,state_selected=NULL))
  })
  

  # Confirmed Cases Per State Over Time -------------------------------------
  output$ln_confirmed <- renderUI({
    selectInput(
      inputId = session$ns("ln_confirmed"),
      label = h5("Transformacao Log Natural:"),
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
      subtitle = paste0("Casos Confirmades em ",
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
      subtitle = paste0("Mortes em ",
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
      subtitle = paste0("Tx. de Mortalidade em",
                        input$selected_state,
                        "(%)")
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
    
    paste0("\n\nCidades com Mortes\nRegistradas: ",value)

  })
  
  output$confirmed_cases_within_states_map <- leaflet::renderLeaflet({
    plot_cases_state_map(
      df_covid19 = covid19_br_data,
      State = input$selected_state,
      state_shape_files = shape_file_estados
    )
  })
  output$state_new_cases_and_deaths_moving_avg <- plotly::renderPlotly({
    plotly::ggplotly(
      plot_moving_avg(
        df = covid19_br_data, 
        state_selected = input$selected_state,
        state_view = T
      )
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
 

#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
#    golem_add_external_resources(),
    # List the first level UI elements here 
    navbarPage(
      theme = shinythemes::shinytheme("spacelab"),
      title = tags$a(href="https://www.linkedin.com/in/viniciusmsousa/","Covid-19 Monitor by Vinicius M. de Sousa"),id = "covid19",
      # Brazil Monitor Tab ------------------------------------------------------
      tabPanel(
        title = "Brazil Monitor",
        mod_Brazil_Monitor_ui("Brazil_Monitor_ui_1")
        
      ),
      # About Tab ---------------------------------------------------------------
      tabPanel("About",
               tags$div(
                 tags$h4("Disclaimer"),
                 "The development of this tool was motivated by the poor news coverage of general midea and intendends to provida a way to properly compare the Covid-19 Spread (in Brazil at this moment).",
                 tags$br(),tags$h4("Data Sources and Updates"),
                 tags$b("Brazil Covid-19: "), tags$a(href="https://brasil.io/dataset/covid19/caso", "brasil.io")," that make availiable the data published by Governmental Health agencies.",tags$br(),
                 tags$br(),tags$h4("Authors"),
                 tags$a(href="https://www.linkedin.com/in/viniciusmsousa/","Vinicius M. de Sousa"),tags$br(),
                 tags$a(href="https://www.linkedin.com/in/luanadasilva/","Luana da Silva"),tags$br(),
                 tags$br(),tags$h4("Contact"),
                 "vinisousa04@gmail.com",tags$br()
               )
      )
  )
  )
} 

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  # add_resource_path(
  #   'www', app_sys('app/www')
  # )
  # 
  # tags$head(
  #   favicon(),
  #   bundle_resources(
  #     path = app_sys('app/www'),
  #     app_title = 'covid19'
  #   )
  #   # Add here other external resources
  #   # for example, you can add shinyalert::useShinyalert() 
  # )
}


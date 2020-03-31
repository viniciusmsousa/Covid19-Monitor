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
      title = "Covid-19 by Vinicius M. Sousa",id = "covid19",
      # Brazil Monitor Tab ------------------------------------------------------
      tabPanel(
        title = "Brazil Monitor",
        mod_Brazil_Monitor_ui("Brazil_Monitor_ui_1")
        
      ),
      # About Tab ---------------------------------------------------------------
      tabPanel("About",
               tags$div(
                 tags$h4("Last update"), 
                 "This site is updated once daily. At this time of rapid escalation of the COVID-19 pandemic, the following resources offer the latest numbers of known cases:",tags$br(),
                 tags$a(href="https://experience.arcgis.com/experience/685d0ace521648f8a5beeeee1b9125cd", "WHO COVID-19 dashboard"),tags$br(),
                 tags$a(href="https://gisanddata.maps.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6", "Johns Hopkins University COVID-19 dashboard"),tags$br(),
                 "The aim of this site is to complement the above resources by providing several interactive features not currently available elsewhere, including the timeline function, 
                            the ability to overlay past outbreaks, and an emphasis on normalised counts (per 100,000 individuals).",tags$br(),
                 tags$br(),tags$h4("Background"), 
                 "In December 2019, cases of severe respiratory illness began to be reported across the city of Wuhan in China. 
                            These were caused by a new type of coronavirus, and the disease is now commonly referred to as COVID-19.
                            The number of COVID-19 cases started to escalate more quickly in mid-January and the virus soon spread beyond China's borders. 
                            This story has been rapidly evolving ever since, and each day we are faced by worrying headlines regarding the current state of the outbreak.",
                 tags$br(),tags$br(),
                 "In isolation, these headlines can be hard to interpret. 
                            How fast is the virus spreading? Are efforts to control the disease working? How does the situation compare with previous epidemics?
                            This site is updated daily based on data published by Johns Hopkins University. 
                            By looking beyond the headlines, we hope it is possible to get a deeper understanding of this unfolding pandemic.",
                 tags$br(),tags$br(),
                 "An article discussing this site was published in ",tags$a(href="https://theconversation.com/coronavirus-outbreak-a-new-mapping-tool-that-lets-you-scroll-through-timeline-131422", "The Conversation. "),
                 "The map was also featured on the BBC World Service program",tags$a(href="https://www.bbc.co.uk/programmes/w3csym33", "Science in Action."),
                 tags$br(),tags$br(),tags$h4("Code"),
                 "Code and input data used to generate this Shiny mapping tool are available on ",tags$a(href="https://github.com/eparker12/nCoV_tracker", "Github."),
                 tags$br(),tags$br(),tags$h4("Sources"),
                 tags$b("2019-COVID cases: "), tags$a(href="https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series", "Johns Hopkins Center for Systems Science and Engineering github page,")," with additional information from the ",tags$a(href="https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports", "WHO's COVID-19 situation reports."),
                 " In previous versions of this site (up to 17th March 2020), updates were based solely on the WHO's situation reports.",tags$br(),
                 tags$b("2003-SARS cases: "), tags$a(href="https://www.who.int/csr/sars/country/en/", "WHO situation reports"),tags$br(),
                 tags$b("2009-H1N1 confirmed deaths: "), tags$a(href="https://www.who.int/csr/disease/swineflu/updates/en/", "WHO situation reports"),tags$br(),
                 tags$b("2009-H1N1 projected deaths: "), "Model estimates from ", tags$a(href="https://journals.plos.org/plosmedicine/article?id=10.1371/journal.pmed.1001558", "GLaMOR Project"),tags$br(),
                 tags$b("2009-H1N1 cases: "), tags$a(href="https://www.cdc.gov/flu/pandemic-resources/2009-h1n1-pandemic.html", "CDC"),tags$br(),
                 tags$b("2009-H1N1 case fatality rate: "), "a systematic review by ", tags$a(href="https://www.ncbi.nlm.nih.gov/pubmed/24045719", "Wong et al (2009)"), "identified 
                            substantial variation in case fatality rate estimates for the H1N1 pandemic. However, most were in the range of 10 to 100 per 100,000 symptomatic cases (0.01 to 0.1%).
                            The upper limit of this range is used for illustrative purposes in the Outbreak comarisons tab.",tags$br(),
                 tags$b("2014-Ebola cases: "), tags$a(href="https://www.cdc.gov/flu/pandemic-resources/2009-h1n1-pandemic.html", "CDC"),tags$br(),
                 tags$b("Country mapping coordinates: "), tags$a(href="https://gist.github.com/tadast/8827699", "Github"),tags$br(),
                 tags$br(),tags$br(),tags$h4("Authors"),
                 "Dr Edward Parker, The Vaccine Centre, London School of Hygiene & Tropical Medicine",tags$br(),
                 "Quentin Leclerc, Department of Infectious Disease Epidemiology, London School of Hygiene & Tropical Medicine",tags$br(),
                 tags$br(),tags$br(),tags$h4("Contact"),
                 "edward.parker@lshtm.ac.uk",tags$br(),tags$br(),
                 tags$img(src = "vac_dark.png", width = "150px", height = "75px"), tags$img(src = "lshtm_dark.png", width = "150px", height = "75px")
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


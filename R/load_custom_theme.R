#' Loads Custom Theme for the Plots 
#'
#' @return ggplot theme object
#' @export
#' @import ggplot2
#' 
load_custom_theme <- function(){
  out <- tryCatch({
    covid19_theme <- theme_minimal()+
      theme(
        axis.title.x = element_text(face = "bold",
                                    size = 12,
                                    hjust = 0),
        axis.title.y = element_text(face = "bold",
                                    size = 12),
        title = element_text(face = "bold"),
        axis.text.x = element_text(face = "bold"),
        axis.text.y = element_text(face = "bold"),
        legend.title = element_blank())
    covid19_theme
  },
  error = function(cond){
    message("Error in function load_custom_theme()")
    message(cond)
  })
}
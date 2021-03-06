% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cities_with_deaths_data_table.R
\name{cities_with_deaths_data_table}
\alias{cities_with_deaths_data_table}
\title{Datatable with Cities where Deaths were registered}
\usage{
cities_with_deaths_data_table(df, selected_state)
}
\arguments{
\item{df}{Data Frame. Output from function getBrazilCovid19Data()}

\item{selected_state}{String. Selected state (input$selected_state)}
}
\value{
DT::datatable()
}
\description{
Datatable with Cities where Deaths were registered
}

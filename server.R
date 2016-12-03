library(shiny)
source('scripts/calculated_metrics.R')    ##   Import metric calculations

##   Load beginning and end datasets
begin_dataset <- read.csv('data/cluster2006.csv', stringsAsFactors=FALSE)

end_dataset <- read.csv('data/cluster2011.csv', stringsAsFactors=FALSE)

shinyServer(function(input, output) {
     
     ##   Create region dropdown menu
     choose_region <- reactive({
          return(unique(end_dataset$region))
     })
     
     output$region <- renderUI({
          unique_regions <- choose_region()
          selectInput("select_region", "Select region of interest", choices = unique_regions, 
                      unique_regions[1])
     })
     
})
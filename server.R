library(shiny)
source('scripts/calculated_metrics.R')    ##   Import metric calculations

data2006 <- read.csv('data/cluster2006.csv', stringsAsFactors=FALSE)

data2011 <- read.csv('data/cluster2011.csv', stringsAsFactors=FALSE)


shinyServer(function(input, output) {
     
})
# server.R

library(shinydashboard)
library(ggvis)
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
          selectInput("select_region", "Region", choices = unique_regions, 
                      unique_regions[1])
     })
     

     ##   Create bubble plot title   
     output$region_title <- renderText({input$select_region})
     
     output$analysis_title <- renderText({input$analysisType})
     
     selected_region <- reactive({input$select_region})
     
     
     
     
     ##   Create data frames based on different types of analysis
     
     build_visdf <- reactive({
          
          ##   Build dataframe for Employment Growth Composition
          if(input$analysisType == "Employment Growth Composition"){
               
               xvar <- RegionShare(end_dataset, "employee_count")
               yvar <- CAGR(begin_dataset, end_dataset, "employee_count", 5)
               
               new_table <- inner_join(xvar, yvar, by = c('cluster', 'region'))
          
          ##   Build dataframe for Employment Share & Specialization
          } else if(input$analysisType == "Employment Share & Specialization"){
               
               xvar <- LQ(end_dataset, "employee_count")
               yvar <- RegionShare(end_dataset, "employee_count")
               
               new_table <- inner_join(xvar, yvar, by = c('cluster', 'region'))
               
          ##   Build dataframe for Employment Growth & Specialization
          } else if(input$analysisType == "Employment Growth & Specialization"){
               
               xvar <- LQ(end_dataset, "employee_count")
               yvar <- CAGR(begin_dataset, end_dataset, "employee_count", 5)
               
               new_table <- inner_join(xvar, yvar, by = c('cluster', 'region'))
               
          ##   Build dataframe for Revenue Growth & Specialization
          } else {
               
               xvar <- LQ(end_dataset, "revenue")
               yvar <- CAGR(begin_dataset, end_dataset, "revenue", 5)
               
               new_table <- inner_join(xvar, yvar, by = c('cluster', 'region'))
          }
          
          names(new_table) <- c("cluster", "region", "xvar", "yvar")
          
         new_table <- new_table[which(new_table$region == selected_region() ),]
         return(new_table)
     
     })
     
     ##   Axis labels
     axis_labels <- reactive({
          
          ##   Build dataframe for Employment Growth Composition
          if(input$analysisType == "Employment Growth Composition"){
               
               new_labels <- c("Employment share", "Employment growth (CAGR)")
               
               ##   Build dataframe for Employment Share & Specialization
          } else if(input$analysisType == "Employment Share & Specialization"){
               
               new_labels <- c("Location quotient (Employment)", "Employment share")
               
               ##   Build dataframe for Employment Growth & Specialization
          } else if(input$analysisType == "Employment Growth & Specialization"){
               
               new_labels <- c("Location quotient (Employment)", "Employment growth (CAGR)")
               
               ##   Build dataframe for Revenue Growth & Specialization
          } else {
               
              new_labels <- c("Location quotient (Revenue)", "Revenue growth (CAGR)")
          }
          
         
          return(new_labels)
          
     })
     
     
     
     ##   Render bubble
     reactive({
          ggvis(build_visdf(), x = ~xvar, y = ~yvar) %>%
               layer_points() %>%
               add_axis("x", title = axis_labels()[1]) %>%
               add_axis("y", title = axis_labels()[2])
     }) %>%
          bind_shiny("bubble_chart")
          
})
# server.R

library(shinydashboard)
library(ggvis)
library(googleVis)
source('scripts/calculated_metrics.R')    ##   Import metric calculations

##   Load beginning and end datasets
begin_dataset <- read.csv('data/cluster2006.csv', stringsAsFactors=FALSE)

end_dataset <- read.csv('data/cluster2011.csv', stringsAsFactors=FALSE)

cluster_types <- read.csv('data/clustertypes.csv', stringsAsFactors=FALSE)

shinyServer(function(input, output) {
     
     ##   Create region dropdown menu
     choose_region <- reactive({
          return(unique(end_dataset$region))
     })
     
     output$region <- renderUI({
          unique_regions <- choose_region()
          selectInput("select_region", "Region of interest", choices = unique_regions, 
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
               zvar <- end_dataset[,c('cluster', 'region', "employee_count")]
          
          ##   Build dataframe for Employment Share & Specialization
          } else if(input$analysisType == "Employment Share & Specialization"){
               
               xvar <- LQ(end_dataset, "employee_count")
               yvar <- RegionShare(end_dataset, "employee_count")
               zvar <- end_dataset[,c('cluster', 'region', "employee_count")]
               
          ##   Build dataframe for Employment Growth & Specialization
          } else if(input$analysisType == "Employment Growth & Specialization"){
               
               xvar <- LQ(end_dataset, "employee_count")
               yvar <- CAGR(begin_dataset, end_dataset, "employee_count", 5)
               zvar <- RegionShare(end_dataset, "employee_count")
               
          ##   Build dataframe for Revenue Growth & Specialization
          } else {
               
               xvar <- LQ(end_dataset, "revenue")
               yvar <- CAGR(begin_dataset, end_dataset, "revenue", 5)
               zvar <- RegionShare(end_dataset, "revenue")
               
          }
          
          new_table <- inner_join(xvar, yvar, by = c('cluster', 'region')) %>%
               inner_join(zvar, by = c('cluster', 'region')) 
               
          names(new_table) <- c("cluster", "region", "xvar", "yvar", "zvar")
          
          ##   Filter by region
          new_table <- new_table[which(new_table$region == selected_region() ),] %>%
               inner_join(cluster_types, by = 'cluster')
          
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
     
     output$bubble <- renderGvis({
          
          Sys.sleep(0.3)      ## For some reason, Sys.sleep() needs to be here
          
          gvisBubbleChart(build_visdf(), idvar = "cluster", xvar = "xvar", yvar = "yvar",
                          colorvar = "type", sizevar = "zvar", 
                          options = list(chartArea = '{left:10, top:10, bottom:40, width:"80%", height:"50%"}',
                                         width="530px", height="450px",
                                         bubble="{textStyle:{color: 'none'}}"))
     })
     
     ##   Render bubble
     # reactive({
     #      ggvis(build_visdf(), x = ~xvar, y = ~yvar) %>%
     #           layer_points() %>%
     #           add_axis("x", title = axis_labels()[1]) %>%
     #           add_axis("y", title = axis_labels()[2]) %>%
     #           set_options(width = 470, height = 400)
     # }) %>%
     #      bind_shiny("bubble_chart")
          
})
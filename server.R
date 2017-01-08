# server.R

library(shinydashboard)
library(googleVis)
library(leaflet)
source('scripts/calculated_metrics.R')    ##   Import metric calculations

##   Load beginning and end industry datasets
begin_dataset <- read.csv('data/cluster2006.csv', stringsAsFactors=FALSE)
end_dataset <- read.csv('data/cluster2011.csv', stringsAsFactors=FALSE)

##   Load dataset with cluster type definitions
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
     
     selected_type <- reactive({input$clusterType})
     
     ##   Create data frames based on different types of analysis
     
     build_visdf <- reactive({
          
          ##   Build dataframe for Employment Growth Composition
          if(input$analysisType == "Employment Growth Composition"){
               yvar <- RegionShare(end_dataset, "employee_count")
               xvar <- CAGR(begin_dataset, end_dataset, "employee_count", 5)
               zvar <- end_dataset[,c('cluster', 'region', "employee_count")] %>%    ## Round employee count to 
                    mutate(employee_count = round(employee_count))                   ## nearest integer.
          
          ##   Build dataframe for Employment Share & Specialization
          } else if(input$analysisType == "Employment Share & Specialization"){
               yvar <- LQ(end_dataset, "employee_count")
               xvar <- RegionShare(end_dataset, "employee_count")
               zvar <- end_dataset[,c('cluster', 'region', "employee_count")] %>%    ## Round employee count to 
                    mutate(employee_count = round(employee_count))                   ## nearest integer.
               
          ##   Build dataframe for Employment Growth & Specialization
          } else if(input$analysisType == "Employment Growth & Specialization"){
               yvar <- LQ(end_dataset, "employee_count")
               xvar <- CAGR(begin_dataset, end_dataset, "employee_count", 5)
               zvar <- RegionShare(end_dataset, "employee_count")
               
          ##   Build dataframe for Revenue Growth & Specialization
          } else {
               yvar <- LQ(end_dataset, "revenue")
               xvar <- CAGR(begin_dataset, end_dataset, "revenue", 5)
               zvar <- RegionShare(end_dataset, "revenue")
          }
          
          new_table <- inner_join(xvar, yvar, by = c('cluster', 'region')) %>%
               inner_join(zvar, by = c('cluster', 'region')) 
               
          names(new_table) <- c("cluster", "region", "xvar", "yvar", "zvar")
          
          ##   Filter by region
          new_table <- new_table[which(new_table$region == selected_region() ),] %>%
               inner_join(cluster_types, by = 'cluster')
          
          if(selected_type() == "Traded only"){
               new_table <- new_table[which(new_table$type == "traded" ),]
          } else if(selected_type() == "Local only") {
               new_table <- new_table[which(new_table$type == "local" ),]
          }
          
          return(new_table)
     })
     
     ##   Axis labels
     axis_labels <- reactive({
          
          ##   Build dataframe for Employment Growth Composition
          if(input$analysisType == "Employment Growth Composition"){
               
               new_labels <- c("Employment growth", "Employment share", "Employment size")
               
          ##   Build dataframe for Employment Share & Specialization
          } else if(input$analysisType == "Employment Share & Specialization"){
               
               new_labels <- c("Employment share", "Location quotient - Employment", "Employment size")
               
          ##   Build dataframe for Employment Growth & Specialization
          } else if(input$analysisType == "Employment Growth & Specialization"){
               
               new_labels <- c("Employment growth", "Location quotient - Employment", "Employment share")
               
          ##   Build dataframe for Revenue Growth & Specialization
          } else {
               
              new_labels <- c("Revenue growth", "Location quotient - Revenue", "Revenue share")
          }
          
          return(new_labels)
     })
     
     ##   Render bubble chart
     output$bubble <- renderGvis({
          
          x <- axis_labels()[1]
          y <- axis_labels()[2]
          z <- axis_labels()[3]
          
          xaxislabel <- paste0("[{title:'", x,"'}]" )
          yaxislabel <- paste0("[{title:'", y,"'}]" )
          
          vis_table <- build_visdf()
          names(vis_table) <- c("cluster", "region", x, y, z, "type")
          
          Sys.sleep(0.3)      ## For some reason, Sys.sleep() needs to be here
          
          gvisBubbleChart(vis_table, idvar = "cluster", xvar = x, yvar = y,
                          colorvar = "type", sizevar = z, 
                          options = list(chartArea = '{left:60, top:10, bottom:50, right: 95,width:"80%", height:"50%"}',
                                         width= "600px", height= "450px",
                                         hAxes=xaxislabel, vAxes=yaxislabel,
                                         bubble= "{textStyle:{color: 'none'}}"))
     })
     
     ##   Serve HTML files
     output$htmlfile <- renderUI({
          
          file <- switch(input$analysisType,
                    "Employment Growth Composition" = "html/employ-growth-comp.html",
                    "Employment Share & Specialization" = "html/employ-share-spec.html",
                    "Employment Growth & Specialization" = "html/employ-growth-spec.html",
                    "Revenue Growth & Specialization" = "html/rev-growth-spec.html",
                    stop("Unknown option")
          )

          helpText(includeHTML(file))
     })
     
     ##   Load TopoJSON data with region boundaries for Leaflet map
     loadjson <- reactive({
          
          ##   Use switch statement to choose which TopoJSON file to load
          
          region_name <- switch(input$select_region, 
                      "Changhua County" = "changhua",
                      "Chiayi City" = "chiayicity",
                      "Chiayi County" = "chiayicounty",
                      "Hsinchu City" = "hsinchucity",
                      "Hsinchu County" = "hsinchucounty",
                      "Hualien County" = "hualien",
                      "Kaohsiung City" = "kaohsiung",
                      "Keelung City" = "keelung",
                      "Kinmen County" = "kinmen",
                      "Lienchiang County" = "lienchiang",
                      "Miaoli County"= "miaoli",
                      "Nantou County" = "nantou",
                      "New Taipei City" = "newtaipei",
                      "Penghu County" = "penghu",
                      "Pingtung County" = "pingtung",
                      "Taichung City" = "taichung",
                      "Tainan City" = "tainan",
                      "Taipei City" = "taipei",
                      "Taitung County" = "taitung",
                      "Taoyuan City" = "taoyuan",
                      "Taiwan Total" = "total",
                      "Yilan County" = "yilan",
                      "Yunlin County" = "yunlin",
                      "North Region" = "north",
                      "Northwest Region" = "northwest",
                      "Middle Region" = "middle",
                      "Southwest Region" = "southwest",
                      "South Region" = "south",
                      "East Region" = "east",
                      "Outer Islands" = "outerislands")
          
          json_path <- paste0("data/topojson/", region_name, ".json") %>%
               readLines()
          })
     
     ##   Render Leaflet map
     output$twmap <- renderLeaflet({
          
          topoData <- loadjson()
          
          leaflet() %>%
               setView(lng = 121, lat = 23.6, zoom = 7) %>%
                    addProviderTiles("Hydda.Base") %>%
                    addTopoJSON(topoData, weight = 1, color = "#FF6347", fill = TRUE)
     })
})
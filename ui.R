# ui.R

library(shinydashboard)
library(ggvis)
library(googleVis)
library(leaflet)

##   Dashboard title setup
header <- dashboardHeader(title = "Taiwan Industry Cluster Explorer", titleWidth = 350)

##   Dashboard body setup
body <- dashboardBody(
     
     ##   Top row
     fluidRow(
          
          ##   Menu panel
          box(
               width = 3,
               height = 600,
               helpText("Use menus below to select analysis type and filter data."),
               
               ##   Analysis type menu
               selectInput('analysisType', "Analysis",
                           c("Employment Growth Composition", "Employment Share & Specialization",
                             "Employment Growth & Specialization", "Revenue Growth & Specialization")),
               
               ##   Cluster type menu
               selectInput('clusterType', "Cluster type",
                           c("All", "Traded only",
                             "Local only")),

               ##   Region dropdown menu
               uiOutput("region"),
               
               ##   Markdown
               br(),
               uiOutput('htmlfile'),
               br(),
               br()
          ),
          
          ##   Bubble chart panel
          box(
               width = 6,
               height = 600,
               title = textOutput("analysis_title"),
               helpText("Hover over a bubble for tooltip."),
               htmlOutput("bubble")
          ),
          
          ##   Leaflet map panel
          box(
              width = 3,
              height = 600,
              title = textOutput("region_title"),
              helpText('Use +/- buttons or mouse wheel to zoom.'),
              leafletOutput("twmap")
          )
     )
)

##   Render entire dashboard
dashboardPage(
     skin = "purple",
     header,
     dashboardSidebar(disable = TRUE),
     body
)
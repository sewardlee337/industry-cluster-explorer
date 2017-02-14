# ui.R

library(shinydashboard)
library(googleVis)
library(leaflet)

##   Dashboard title setup
header <- dashboardHeader(title = "Taiwan Industry Cluster Explorer", titleWidth = 400)

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
                           c("Economic Dynamism", "Employment Growth Composition", "Employment Share & Specialization",
                             "Employment Growth & Specialization", "Revenue Growth & Specialization")),
               
               ##   Cluster type menu
               selectInput('clusterType', "Cluster type",
                           c("All", "Traded only",
                             "Local only")),

               ##   Region dropdown menu
               uiOutput("region"),
               
               ##   HTML file for analysis description
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
               helpText("Hover over a bubble for tooltip.  Left-click and drag to pan around 
                        the chart horizontally and vertically. Right-click to reset to default view."),
               htmlOutput("bubble")
          ),
          
          ##   Leaflet map panel
          box(
              width = 3,
              height = 600,
              title = textOutput("region_title"),
              helpText('Use +/- buttons or mouse wheel to zoom. Left-click and drag to pan horizontally and vertically.'),
              leafletOutput("twmap")
          )
     ),
     
     fluidRow(
          box(
               width = 12,
               
               br(),
               
               p(strong("Taiwan Industry Cluster Explorer"), "is a project of the",  
                    tags$a(href="http://tisc.nccu.edu.tw/", "Taiwan Institute for Strategy and Competitiveness"), 
                    "(TISC) at", tags$a(href="http://www.nccu.edu.tw/?locale=en", "National Chengchi University"), 
                    "in Taipei.  It is based on research conducted by Dr. Janet Tan, with coaching and
                    assistance provided by Prof. Michael Porter's team at the", 
                    tags$a(href="http://www.isc.hbs.edu/Pages/default.aspx", "Institute of Strategy and Competitiveness"), 
                    "at Harvard Business School.  This project utilizes census data from 2006 and 2011 acquired 
                    from the Directorate General of Budget, Accounting, and Statistics."),
               
               p("The underlying data is subject to certain government limitations -- please consult TISC 
                    prior to reproduction."),
               
               p("Have questions? Want to collaborate? Please contact Dr. Tan (janettan.liu@gmail.com) 
                    or Seward Lee (sewardlee337@gmail.com)."),
               
               br()
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
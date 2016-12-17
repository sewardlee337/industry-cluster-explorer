# ui.R

library(shinydashboard)
library(ggvis)
library(googleVis)

##   Dashboard title setup
header <- dashboardHeader(title = "Taiwan Industry Cluster Explorer", titleWidth = 350)


##   Dashboard body setup
body <- dashboardBody(
     
     ##   Top row
     fluidRow(
          
          ##   Side panel
          box(
               width = 3,
               
               #   Help text
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
               uiOutput("region")


          ),
          
          ##   Main panel
          
          box(
               width = 6,
               title = textOutput("analysis_title"),

               helpText("Hover over a bubble for tooltip."),
               
               htmlOutput("bubble")
          )
          
          
     ),
     
     ##   Bottom row
     fluidRow(
          
          ##   Serve markdown documents here 
          box(
              width = 12,
              includeMarkdown("markdown/employ-share-spec.Rmd")
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

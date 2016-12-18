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
               helpText(includeMarkdown("markdown/employ-share-spec.Rmd")),
               br(),
               br()
          ),
          
          ##   Main panel
          box(
               width = 6,
               title = textOutput("analysis_title"),
               helpText("Hover over a bubble for tooltip."),
               htmlOutput("bubble")
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
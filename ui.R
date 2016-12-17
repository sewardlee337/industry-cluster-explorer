# ui.R

library(shinydashboard)

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
               helpText("Use menus below to select type of analysis and region of interest"),
               
               ##   Analysis type menu
               selectInput('analysisType', "Analysis type",
                           c("Employment Growth Composition", "Employment Share & Specialization",
                             "Employment Growth & Specialization", "Revenue Growth & Specialization")),

               ##   Region dropdown menu
               uiOutput("region")


          ),
          
          ##   Main panel
          
          box(
               title = 
               textOutput("analysis_title"),
               
               ggvisOutput("bubble_chart")
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

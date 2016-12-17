# ui.R

library(shinydashboard)

##   Dashboard title setup
header <- dashboardHeader(title = "Taiwan Industry Cluster Explorer", titleWidth = 450)
     
     
     # titlePanel("Taiwan Industry Cluster Dashboard"),
     # 
     # sidebarLayout(
     #      
     #      sidebarPanel(
     #           
     #           ##   Help text
     #           helpText("Derp derp derp derp derp derp derp"),
     #           
     #           ##   Region dropdown menu
     #           uiOutput("region"),
     #           
     #           ##   Analysis type menu
     #           selectInput('analysisType', "Analysis type", 
     #                       c("Employment Growth Composition", "Employment Share & Specialization", 
     #                         "Employment Growth & Specialization", "Revenue Growth & Specialization"))
     #           
     #      ),
     #      mainPanel("Main panel")
     # )

##   Dashboard body setup
body <- dashboardBody(
     
     ##   Top row
     fluidRow(
          
          ##   Side panel
          box(
               width = 3,
               
               #   Help text
               helpText("Use menus below to select type of analysis and region of interest"),

               ##   Region dropdown menu
               uiOutput("region"),

               ##   Analysis type menu
               selectInput('analysisType', "Analysis type",
                    c("Employment Growth Composition", "Employment Share & Specialization",
                         "Employment Growth & Specialization", "Revenue Growth & Specialization"))
          ),
          
          ##   Main panel
          
          box("Main Panel")
          
          
     ),
     
     ##   Bottom row
     fluidRow(
          
          box()
          
     )
     
     
     
     
)


##   Render entire dashboard

dashboardPage(
     skin = "purple",
     header,
     dashboardSidebar(disable = TRUE),
     body

)

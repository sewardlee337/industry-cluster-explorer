# ui.R

shinyUI(fluidPage(
     
     titlePanel("Taiwan Industry Cluster Dashboard"),
     
     sidebarLayout(
          
          sidebarPanel(
               
               ##   Help text
               helpText("Derp derp derp derp derp derp derp"),
               
               ##   Region dropdown menu
               uiOutput("region")
               
          ),
          mainPanel("Main panel")
          
     )
     
))
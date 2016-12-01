library(shiny)

shinyUI(fluidPage(
     
     titlePanel("Taiwan Industry Cluster Dashboard"),
     
     sidebarLayout(
          
          sidebarPanel(
               
               selectInput("selectRegion", label = h4("Select region"),
                           choices = list("Choice 1"= 1, "Choice 2" = 2,
                                          "Choice 3" = 3))
               
          ),
          mainPanel("Main panel")
          
     )
     
))
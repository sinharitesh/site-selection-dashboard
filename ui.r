library(shinythemes)
shinyUI(fluidPage(
  theme = shinytheme("journal"),
  
  titlePanel("Site Selection Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Parameters - Select to get the data on Map of USA.")

      ,sliderInput("sliderOverall_Score", "Overall Score:",
                  min = 0, max = 250, value = c(0,250))
      ,sliderInput("sliderPatient_Score", "Patient Score:",
                   min = 0, max = 250, value = c(0,250))
      ,sliderInput("sliderTrial_Score", "Trial Score:",
                   min = 0, max = 250, value = c(0,250))
      ,sliderInput("sliderInvestigator_Score", "Investigator Score:",
                   min = 0, max = 250, value = c(0,250))
    ),
   
    mainPanel(
      h4(textOutput("caption")), 
      textOutput("text"),
      textOutput("text2"),
      htmlOutput("gvis")
      
      )
  )
))


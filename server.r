library(shiny)
library(googleVis)
library(plyr)

do.tooltip <- function(site.name, state)
{
  ret <- paste(site.name, "State =", state)
  return(ret)
}

## Start Data
df.site_summary_scores <- read.csv("data/Site_Summary_Scores.csv")
df.site_summary_scores$Tooltip <- paste(df.site_summary_scores$Site,'- State: ', df.site_summary_scores$State, ',Patient Score:', df.site_summary_scores$Patient_Score, ',Trial Score:', df.site_summary_scores$Trial_Score, ',Investigator Score:', df.site_summary_scores$Investigator_Score)
df.Sites <- unique(as.character(df.site_summary_scores$Site))
summary(df.site_summary_scores$Patient_Score)
## End Data 


shinyServer(
  function(input, output) {
    
    os <- reactive({
      input$sliderOverall_Score
    })
    
    ps <- reactive({
      input$sliderPatient_Score
    })
    
    ts <- reactive({
      input$sliderTrial_Score
    })
    is <- reactive({
      input$sliderInvestigator_Score
    })
    

    getsitesdata <- reactive({
      a <- subset(df.site_summary_scores, ((df.site_summary_scores$Overall_Score >= input$sliderOverall_Score[1] & df.site_summary_scores$Overall_Score <= input$sliderOverall_Score[2])))
      a <- subset(a, ((a$Patient_Score > input$sliderPatient_Score[1] & a$Patient_Score < input$sliderPatient_Score[2])))
      a <- subset(a, ((a$Trial_Score > input$sliderTrial_Score[1] & a$Trial_Score < input$sliderTrial_Score[2])))
      a <- subset(a, ((a$Investigator_Score > input$sliderInvestigator_Score[1] & a$Investigator_Score < input$sliderInvestigator_Score[2])))
      return(a)
    })
        
  output$caption <- renderText({
    input$slider.Patient_Score[2]
    
  }) 
  
  output$text <- renderText({
    "Please select the various indicator ranges. This data is shown on selection of various indicators. The data is provided on four parameters:
    1. Overall Score
    2. Patient Score
    3. Trial Score and 
    4. Investigator Score
    "
  })  
  output$text2 <- renderText({
    "Note: The size of the circles are dependent on the selection of the indicators and adjust itself related to the data. If the selection of overall score is 50 to 100 then the circle with a value of 90 will appear big, but if the selection is from 80 to 130, then the same circle will appear small.
    "
  })  
  output$gvis <- 
    renderGvis({
 
      pd <- getsitesdata()
  
      gvisGeoChart(pd, locationvar='State', 
                    sizevar = 'Overall_Score', hovervar = 'Tooltip',
                   options=list( height=400, legend = "Site", 
                                 displayMode='markers', resolution="provinces",
                                 region = "US", showLine=TRUE, colorAxis="{colors:['green','green','green']}",
                                 chartid = "Site Selection Dashboard", backgroundColor.fill = 'white')
      )
      
    })
    
  }
)



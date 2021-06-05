library(shiny)
library("tidyverse")
library(ggplot2)
library(hrbrthemes)
library(zoo)
df <- read.csv("JPmorgan_data.csv")
save(df,file="AppData.Rda")
load("AppData.Rda")
# Input
ui <- fluidPage(
  theme = "bootstrap.min1.css",
  tags$head(
    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
      
      h1 {
        font-family: 'Lobster', cursive;
        font-weight: 700;
        line-height: 1.1;
        color: 	#F5FFFA;
      }

    "))
  ),
  headerPanel("JPmorgan Chase Bank Information(2004-2019)"),
  sidebarPanel(
    
    radioButtons("variable",
                 label = "What would you like to know about the JPmorgan chase bank?",
                 choices = c("branch_data", 
                   "Consol_Assets",
                   "Domestic_Assets",
                   "Pct_Domestic_Assets"),
                 selected = "Consol_Assets")
    ),
    
    # h3(textOutput("caption")),
    mainPanel(
      plotOutput("distPlot"),
      br(), br()
    )
)

#Define the server function
server <- function(input, output) {
  
  
  output$distPlot <- renderPlot({
    ggplot(data=df, aes(Year, y=.data[[input$variable]])) + 
      geom_line( color="steelblue") + 
      geom_point() +
      xlab("Year") +
      geom_smooth(method = "loess")+
      scale_x_yearmon(format="%Y", n=16)
  })
}
shinyApp(ui = ui, server = server)

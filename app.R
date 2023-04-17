# Load packages ----------------------------------------------------------------

library(shiny)
library(ggplot2)
library(dplyr)
library(magrittr)

# Load data --------------------------------------------------------------------


dt <- read.csv("Methane_final.csv")
#----dt <- dt %>% clean_names()

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  
  titlePanel("Global Emissions"),
  p("Methane is responsible for around 30% of the rise in global temperatures since the Industrial Revolution, and rapid and sustained reductions in methane emissions are key to limiting near-term global warming and improving air quality. The energy sector – including oil, natural gas, coal and bioenergy – accounts for nearly 40% of methane emissions from human activity."),
  
  img(src = "https://www.innovationnewsnetwork.com/wp-content/uploads/2022/11/%C2%A9-iStockPetmal-1340519929-800x450.jpg",align="right",height="45%", width="100%"),
  p("Image source from https://www.innovationnewsnetwork.com/wp-content/uploads/2022/11/%C2%A9-iStockPetmal-1340519929-800x450.jpg"),
  
  sidebarLayout(
    
    # Inputs: Select variables to plot
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("region","country","emissions","type","segment","reason","year","notes"), 
                  selected = "region"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("region","country","emissions","type","segment","reason","year","notes"), 
                  selected = "country"),
      
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("region","country","emissions","type","segment","reason","year","notes"),
                  selected = "type")
    ),
    
    # Output: Show scatterplot
    mainPanel(
      plotOutput(outputId = "scatterplot", hover = "plot_hover"),
      dataTableOutput(outputId = "emissionsTable"),
      br()
    )
  )
)

# Define server ----------------------------------------------------------------

server <- function(input, output, session) {
  
  output$scatterplot <- renderPlot({
    ggplot(data = dt, aes_string(x = input$x, y = input$y,
                                     color = input$z)) +
      geom_point()
  })
  
  
  output$emissionsTable <- renderDataTable({
    nearPoints(dt, input$plot_hover) %>%
      select(region, emissions, segment)
  })
  
}

# Create a Shiny app object ----------------------------------------------------

shinyApp(ui = ui, server = server)
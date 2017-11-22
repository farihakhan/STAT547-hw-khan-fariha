setwd('/Users/farihatkhan/Documents/coursework/stat545/stat547/stat545_hw/hw_08/bcl_app/')
library(tidyverse)
library(shiny)

# Define server logic required to draw a histogram
server <- function(input, output) {
      filtered <- reactive({
            bcl %>%
                  filter(Price >= input$priceInput[1],
                         Price <= input$priceInput[2],
                         Type == input$typeInput,
                         Country == input$countryInput
                  )
      })
      
      output$textFilters <- renderText({
            paste("The search returned",
                  nrow(filtered()), "results.")
      })
      
      output$coolplot <- renderPlot({
            ggplot(filtered(), aes(Alcohol_Content)) +
                  geom_histogram()
      })
      
      output$results <- renderTable({
            filtered()
      })
}

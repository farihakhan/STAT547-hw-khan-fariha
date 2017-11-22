#setwd('/Users/farihatkhan/Documents/coursework/stat545/stat547/stat545_hw/hw_08/bcl_app/')
library(tidyverse)
library(shiny)

# Define server logic required to draw a histogram
server <- function(input, output) {
      bcl <- read.csv("bcl_data.csv", stringsAsFactors = FALSE)
      output$countryOutput <- renderUI({
            selectInput("countryInput", "Country",
                        sort(unique(bcl$Country)),
                        selected = "CANADA")
      })
      
      filtered <- reactive({
            if (is.null(input$countryInput)) {
                  return(NULL)
            }
            
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
            if (is.null(filtered())) {
                  return()
            }
            ggplot(filtered(), aes(Alcohol_Content)) +
                  geom_histogram(aes(fill = Country),
                         bins = 40, alpha = 0.5, colour = "gray") +
                   theme_bw() +
                   labs(title = "Distribution of Alcohol Content",
                        x = "Alcohol content %")
      })
      
      output$results <- renderTable({
            filtered()
      })
}

setwd('/Users/farihatkhan/Documents/coursework/stat545/stat547/stat545_hw/hw_08/bcl_app/')
library(tidyverse)
library(shiny)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
ui <- fluidPage(
      titlePanel("BC Liquor Store prices"),
      h5("Fariha Khan: My app"),
      br(),
      
      sidebarLayout(
            sidebarPanel(
                  h3("Refine your search"), 
                  hr(),
      
            # INPUT FEATURES  
      
                  radioButtons(
                        "typeInput", "PRODUCT TYPE",
                        choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                        selected = "WINE"
                        ),
                  br(),
      
                  selectInput(
                        "countryInput", "COUNTRY",
                        c("CANADA", "FRANCE", "ITALY", 
                        "UNITED STATES OF AMERICA", "AUSTRALIA")
                        ),
                  br(),
      
                  sliderInput(
                        "priceInput", "PRICE RANGE",
                        min = 0, max = 300, value = c(0, 300), pre = "$"),
            ),
            
            mainPanel(
                  plotOutput("coolplot"),
                  br(), br(),
                  tableOutput("results")
            )
      )
)

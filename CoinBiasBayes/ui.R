#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Estimate the Bias of a Coin with Bayes' Rule"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("flips",
                   "Number of coin flips:",
                   min = 1,
                   max = 50,
                   value = 30),
       sliderInput("bias",
                   "True coin bias:",
                   min = 0,
                   max = 1,
                   value = 0.3),
       sliderInput("priorMean",
                   "Prior guess of the coin bias:",
                   min = 0,
                   max = 1,
                   value = 0.5),
       sliderInput("priorSD",
                   "Prior certainty around the guess:",
                   min = 0.01,
                   max = 0.2,
                   value = 0.1),
       sliderInput("lengthMCMC",
                   "Number of steps in the sample chain:",
                   min = 10,
                   max = 5000,
                   value = 1000),
       sliderInput("burnIn",
                   "Number of burn-in steps in the chain:",
                   min = 0,
                   max = 500,
                   value = 100),
       submitButton("Submit")
    ),

    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("bayesPlot")
    )
  )
))

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Estimating the Bias of a Coin using Bayesian Inference"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       h3("Parameter Values"),
       sliderInput("flips",
                   "Number of coin flips:",
                   min = 1,
                   max = 50,
                   value = 30),
       sliderInput("priorMean",
                   "Prior guess of the coin bias:",
                   min = 0,
                   max = 1,
                   value = 0.5),
       sliderInput("priorPrecision",
                   "Prior certainty around the guess:",
                   min = 1,
                   max = 20,
                   value = 10),
       sliderInput("lengthMCMC",
                   "Number of steps in the random walk:",
                   min = 100,
                   max = 5000,
                   value = 2000),
       actionButton("go", "Flip Coin"),
       p(""),
       textOutput("coinFlips")
    ),

    # Show a plot of the generated distribution
    mainPanel(
        p("The aim of this app is to use Bayesian inference to estimate the posterior beliefs about the bias of a coin. Suppose there is a mint, but you are not sure if the coins it mints are totally fair. "),
        h3("Instructions"),
        p("Select how many times you want to flip the coin (30 by default). Select your prior guess of the bias (if not sure, leave 50-50). Select how certain you are about your guess (larger values indicate more certainty). Select how many steps you want to allow the algorithm to walk exploring the posterior space (it discards the first 10% of the steps as burn-in). Click on the Flip Coin button (calculation might take some time). Every time you hit the Flip Coin button, the simulation generates the coin flips from a random theta value. For more information about the algorithm follow", a("this link", href = "http://rpubs.com/laandrad/325086"), "or consult the original source (Kruschke, 2010)."),
        p("Kruschke, J. (2010). Doing Bayesian Data Analysis: A Tutorial Introduction with R. Boston, MA., Academic Press."),
        h3("Results"),
        plotlyOutput("bayesPlot", height = "700px")
    )
  )
))

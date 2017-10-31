library(shiny)
library(plotly)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
                
                options(warn = -1)
        
                randomTheta = eventReactive(input$go, {
                         runif(1)
                })
                
                X = reactive({
                                # The data
                                n = input$flips
                                rbinom(n, 1, randomTheta())
                })

                pss = reactive({
                                source("code/posteriordensity.R", local = T)

                                # define number of replications
                                nMC = input$lengthMCMC

                                # prior guess
                                muTheta = input$priorMean
                                sigmaTheta = 1 / input$priorPrecision

                                # use random values from posterior and likelihood
                                # to sample posterior space
                                MCChain(X(), nMC, muTheta, sigmaTheta)
                })

                output$bayesPlot = renderPlotly({
                                
                                source("code/bayesplot.R", local = T)
                                
                                muTheta = input$priorMean
                                sigmaTheta = 1 / input$priorPrecision
                                
                                posteriorPlot(X(),
                                              muTheta,
                                              sigmaTheta,
                                              pss()
                                              )
               })
                
                output$coinFlips = renderText({
                        paste("\n", ifelse(X() == 1, "Heads,", "Tails,"))
                        })
                
})

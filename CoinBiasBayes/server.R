library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
                
                options(warn = -1)
                
                X = reactive({
                                # The data
                                TrueTheta = input$bias
                                n = input$flips
                                rbinom(n, 1, TrueTheta)
                })

                pss = reactive({
                                source("../posterior_density.r", local = T)

                                # define number of replications
                                nMC = input$lengthMCMC
                                burnIn = input$burnIn

                                # prior guess
                                muTheta = input$priorMean
                                sigmaTheta = input$priorSD

                                # use random values from posterior and likelihood
                                # to sample posterior space
                                MCChain(X(), nMC, muTheta, sigmaTheta, burnIn)
                })

                output$bayesPlot = renderPlotly({
                                
                                source("../BayesPlot.r", local = T)
                                
                                muTheta = input$priorMean
                                sigmaTheta = input$priorSD
                                
                                posteriorPlot(X(),
                                              muTheta,
                                              sigmaTheta,
                                              pss()
                                              )

  })
  
})

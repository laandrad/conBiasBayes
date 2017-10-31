posteriorPlot = function(X, muTheta, sigmaTheta, pss) {

  prior = dnorm(seq(0, 1, .04), muTheta, sigmaTheta)
  likelihood = dbinom(seq_along(X), length(X), mean(X))
  poster = hist(pss, plot = F)
  
  p1 = plot_ly(alpha = 0.6) %>%
        add_trace(x = poster$mids,
                  y = poster$counts / sum(poster$counts),
                  type = 'scatter', 
                  mode = 'lines', 
                  fill = 'tozeroy', 
                  name = "Posterior") %>%
        add_trace(x = seq(0, 1, along.with = prior), 
                  y = prior / sum(prior), 
                  type = 'scatter', 
                  mode = 'lines', 
                  fill = 'tozeroy',
                  name = "Prior") %>%
        add_trace(x = seq(0, 1, along.with = likelihood), 
              y = likelihood / sum(likelihood), 
              type = 'scatter', 
              mode = 'lines', 
              fill = 'tozeroy',
              name = "Likelihood")  %>%
        layout(xaxis = list(title = 'P(x)'),
                yaxis = list(title = 'Density')
                  )

  p2 = plot_ly(
               x = ~seq_along(pss), 
               y = ~pss,
               type = 'scatter',
               mode = 'lines', 
               name = "MCMC steps",
               line = list(simplyfy = F)
              ) %>% 
        layout(xaxis = list(
                  title = "MCMC Random Walk",
                  zeroline = F),
               yaxis = list(
                  title = "Plausible Theta",
                  zeroline = F,
                  range = c(0, 1))
               )
  
  subplot(p1, p2, nrows = 2, margin = 0.05, 
          titleX = T, titleY = T, heights = c(0.4, 0.6))
  
}

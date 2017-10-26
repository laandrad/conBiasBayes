posteriorPlot = function(X, muTheta, sigmaTheta, pss) {
  if (!require(plotly)) {
        install.packages("plotly")
  }
  if (!require(dplyr)) {
        install.packages("dplyr")
  }
  if (!require(RColorBrewer)) {
    install.packages("RColorBrewer")
  }
  
  library(plotly)
  library(dplyr)
  library(RColorBrewer)
  
  prior = dnorm(seq(0, 1, .01), muTheta, sigmaTheta)
  likelihood = dbinom(seq_along(X), length(X), mean(X))
  poster = hist(pss, plot = F)

  p = plot_ly(alpha = 0.6) %>%
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
              name = "Likelihood") %>%
        layout(xaxis = list(title = 'P(x)'),
               yaxis = list(title = 'Density'))
  p
}

accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}

MCMCPlot = function(pss, everyNSteps = 3) {
  # prune chain
  pss = pss[seq(1, length(pss), everyNSteps)]
  # create animation
  cat("Accumulating frames along the MCMC chain...\n")
  tic = proc.time()
  d = accumulate_by(data.frame(pss, step = seq_along(pss)), ~step)
  toc = proc.time()
  cat("\nFinished accumulating frames. Time taken:", (toc - tic)[3], "secs\n")
  cat("\nCreating animation of the MCMC chain...\n")
  tic = proc.time()
  p =  plot_ly(data = d,
               x = ~step, 
               y = ~pss,
               frame = ~frame, 
               type = 'scatter',
               mode = 'lines', 
               line = list(simplyfy = F)) %>% 
        layout(xaxis = list(
               title = "Step in the Chain",
               zeroline = F),
               yaxis = list(
                  title = "Value of Plausible Theta",
                  zeroline = F)) %>% 
        animation_opts(
                frame = 10, 
                transition = 0, 
                redraw = FALSE) %>%
        animation_slider(
                hide = T
              ) %>%
        animation_button(
                x = 1, xanchor = "right", y = 0, yanchor = "bottom"
              )
  toc = proc.time()
  cat("\nFinished creating animation. Time taken: ", (toc - tic)[3], "secs\n")
  p 
}
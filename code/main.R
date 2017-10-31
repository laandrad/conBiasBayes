# The data
n = 30
X = rbinom(n, 1, runif(1))

## define number of replications
nMC = 3000

## initialize posterior sample space with a prior guess
muTheta = 0.5
sigmaTheta = 0.2

# Sample posterior space
source("code/posteriordensity.R")
pss = MCChain(X, nMC, muTheta, sigmaTheta)

source("code/bayesplot.R")
posteriorPlot(X, muTheta, sigmaTheta, pss)

# The data
TrueTheta = 0.3
n = 50
X = rbinom(n, 1, TrueTheta)

## define number of replications
nMC = 500

## initialize posterior sample space with a prior guess
muTheta = 0.5
sigmaTheta = 0.2

# Sample posterior space
source("posterior_density.r")
pss = MCChain(X, nMC, muTheta, sigmaTheta, burnIn = 50)

source("BayesPlot.r")
posteriorPlot(X, muTheta, sigmaTheta, pss)


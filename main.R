
# The data
TrueTheta = 0.3
n = 100
X = rbinom(n, 1, TrueTheta)

## define number of replications
nMC = 1000

## initialize posterior sample space with a prior guess
muTheta = 0.5
sigmaTheta = 0.1

# Sample posterior space
source("posterior_density.r")
pss = MCChain(X, nMC, muTheta, sigmaTheta, burnIn = 100)

source("BayesPlot.r")
posteriorPlot(X, muTheta, sigmaTheta, pss$finalChain)

MCMCPlot(pss$rawChain, everyNSteps = 3)

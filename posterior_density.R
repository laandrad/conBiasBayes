
# define the likelihood function
ProbXGivenTheta = function(k, n, theta) {
                    theta^k * (1 - theta)^(n - k)
}

# define the prior function
ProbTheta = function(theta, muTheta, sigmaTheta) {
              dnorm(theta, muTheta, sigmaTheta)
}

# Posterior function
posterior = function(k, n, theta, muTheta, sigmaTheta) {
              ProbXGivenTheta(k, n, theta) * ProbTheta(theta, muTheta, sigmaTheta)
}

# Montecarlo Sampling
## randomly generate a theta value between 0 and 1
## randomly sample a value from X
## compute posterior probability of theta given x
## if posterior of theta is larger than previous value take that theta value,
## else stick with prior theta
MCSample = function(X, currentTheta, muTheta, sigmaTheta) {
              n = length(X)
              k = sum(X)
              
              proposedTheta = rnorm(1, muTheta, sigmaTheta)
              if (proposedTheta > 1) {
                      proposedTheta = 0.99
              } else if (proposedTheta < 0) {
                      proposedTheta = 0.01
              }

              pProposed = posterior(k, n, proposedTheta, muTheta, sigmaTheta)
              pCurrent = posterior(k, n, currentTheta, muTheta, sigmaTheta)
              
              if (pProposed / pCurrent > 0.5) {
                plausibleTheta = proposedTheta
              } else {
                plausibleTheta = currentTheta
              }
              
              plausibleTheta
} 

## iterate over a large number of times
MCChain = function(X, nMC,  muTheta, sigmaTheta, burnIn = 100) {
            initTheta = runif(1, 0, 1)
            # posterior sample space (PSS)
            pss = numeric(nMC)
            pss[1] = initTheta
            
            for (i in 2:nMC)
              pss[i] = MCSample(X, currentTheta = pss[i - 1], 
                                             muTheta, sigmaTheta)
            
            pss[-(1:burnIn)]
}

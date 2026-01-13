# bayesfn

Bayesian methods for parameter estimation of the folded normal distribution and two-sample mean testing, with maximum likelihood estimation (MLE) provided as a baseline for comparison.

## Features
- **Bayesian estimation**: Estimate `mu` and `sigma` of the folded normal via Stan (`fn_bayes_est()`).
- **Bayesian two-sample mean test**: Compare two folded-normal means using posterior probabilities (`fn_ttest_bayes()`).
- **MLE baseline**: Fast maximum likelihood estimator for `mu` and `sigma` (`fn_mle()`).

## Installation
This package depends on `rstan` and a working C++14 toolchain.

- From a local checkout:

```r
# From the project root
install.packages("devtools") # if not installed
devtools::install_local(".")
# or during development
devtools::load_all(".")
```

### System requirements (Windows)
- R and RTools with C++14 support
- `rstan` configured (see the RStan installation guide)

## Quick start

### 1) Simulate folded-normal data
```r
set.seed(1)
mu    <- 1.0
sigma <- 0.5
x <- abs(rnorm(200, mean = mu, sd = sigma))
```

### 2) MLE baseline
```r
library(bayesfn)
mle_fit <- fn_mle(x)
mle_fit$mu     # MLE for mu
mle_fit$sigma  # MLE for sigma
```

### 3) Bayesian estimation
```r
# By default uses a cached Stan model; adjust iteration settings as needed
bayes_fit <- fn_bayes_est(x, iter = 2000, warmup = 1000, chains = 4)

bayes_fit$mu            # posterior mean of mu
bayes_fit$sigma         # posterior mean of sigma
bayes_fit$Rhat_mu       # R-hat diagnostic for mu
bayes_fit$Rhat_sigma    # R-hat diagnostic for sigma
length(bayes_fit$mu_samples)     # number of posterior samples
length(bayes_fit$sigma_samples)  # number of posterior samples
```

### 4) Bayesian two-sample mean test
```r
x1 <- abs(rnorm(150, mean = 0.8, sd = 0.4))
x2 <- abs(rnorm(150, mean = 1.1, sd = 0.5))

# Test H0: mu1 < mu2; returns posterior P(mu1 > mu2) and a decision
tt <- fn_ttest_bayes(x1, x2, confidence_level = 0.05, iter = 2000, warmup = 1000)

tt$p_value   # P(mu1 > mu2)
tt$decision  # 0 accept H0, 1 accept H1
```

## Stan model compilation & caching
The package uses a cached compiled Stan model for speed.
- `get_stan_model()` automatically retrieves a cached model if available.
- If needed, compile and cache once:

```r
library(bayesfn)
mdl <- compile_stan_model(stan_code)  # provided in the package
```

On first use, compilation may take some time depending on your toolchain.

## License
GPL-3

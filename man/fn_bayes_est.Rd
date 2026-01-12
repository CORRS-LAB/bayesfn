\name{fn_bayes_est}
\alias{fn_bayes_est}
\title{Bayesian estimation for folded normal}
\description{Estimates folded normal parameters for a numeric vector using a cached Stan model to avoid recompilation.}
\usage{fn_bayes_est(x, sigma_lower = 1e-2, mu_upper = 10, iter = 10000, warmup = 4000, chains = 4, model = NULL, support_restrict = FALSE)}
\arguments{
  \item{x}{Numeric vector of observations.}
  \item{sigma_lower}{Lower bound for \code{sigma}.}
  \item{mu_upper}{Upper bound for \code{mu}.}
  \item{iter}{Iterations per chain.}
  \item{warmup}{Warmup iterations per chain.}
  \item{chains}{Number of chains.}
  \item{model}{Optional compiled Stan model; if \code{NULL}, a cached model is loaded.}
  \item{support_restrict}{Logical; if \code{TRUE}, restricts parameter supports using the data by setting \code{sigma_lower <- sd(x)} and \code{mu_upper <- mean(x)}. Default \code{FALSE}.}
}
\value{A list with posterior means, Rhat diagnostics, and posterior samples for \code{mu} and \code{sigma}.}
\examples{
## Requires rstan and a compiled/cached model
# set.seed(1); x <- abs(rnorm(50, 1.2, 0.7))
# fit <- fn_bayes_est(x)
}

\name{fn_ttest_bayes}
\alias{fn_ttest_bayes}
\title{Bayesian two-sample test for folded normal means}
\description{Tests H0: \eqn{\mu_x < \mu_y} using posterior samples from a cached Stan model. Returns samples and a decision.}
\usage{fn_ttest_bayes(x1, x2, confidence_level = 0.05, iter = 10000, warmup = 4000, chains = 4, model = NULL)}
\arguments{
  \item{x1}{Numeric vector for sample 1.}
  \item{x2}{Numeric vector for sample 2.}
  \item{confidence_level}{Numeric in (0,1); default 0.05.}
  \item{iter}{Iterations per chain.}
  \item{warmup}{Warmup iterations per chain.}
  \item{chains}{Number of chains.}
  \item{model}{Optional compiled Stan model; if \code{NULL}, a cached model is loaded.}
}
\value{A list containing posterior samples for \code{mu1}, \code{mu2}, \code{sigma1}, \code{sigma2}, the posterior probability \code{p_value = P(mu1 > mu2)}, and \code{decision} (0 accept H0, 1 accept H1).}
\examples{
## Requires rstan and a compiled/cached model
# set.seed(1)
# x1 <- abs(rnorm(50, 1.2, 0.7))
# x2 <- abs(rnorm(50, 1.0, 0.8))
# res <- fn_ttest_bayes(x1, x2)
}

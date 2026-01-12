\name{mle_folded_normal}
\alias{mle_folded_normal}
\title{MLE for Folded Normal Distribution}
\description{
Estimates the parameters of the folded normal distribution via maximum likelihood.
The optimization uses \code{nlm} with a log-parameterization for \code{sigma} to ensure positivity.
}
\usage{
mle_folded_normal(x, start = NULL)
}
\arguments{
  \item{x}{Numeric vector of observations. Non-finite values are removed.}
  \item{start}{Optional numeric vector of length 2 providing initial values for \code{(mu, log_sigma)}.
  If \code{NULL}, defaults are computed from \code{x}.}
}
\value{
A list with elements:
\itemize{
  \item \code{logLik}: The maximized log-likelihood value.
  \item \code{mu}: Estimated mean of the underlying normal distribution.
  \item \code{sigma}: Estimated standard deviation (> 0) of the underlying normal distribution.
  \item \code{convergence}: Convergence code returned by \code{nlm}.
  \item \code{iterations}: Number of iterations performed by \code{nlm}.
}
}
\details{
The folded normal density for \code{x} given parameters \code{mu} and \code{sigma} is
\deqn{f(x;\,\mu,\sigma) = \phi(x;\,\mu,\sigma) + \phi(-x;\,\mu,\sigma),}
where \code{\phi(\cdot;\,\mu,\sigma)} is the normal density with mean \code{mu} and standard deviation \code{sigma},
and \code{x} is treated as an absolute value (i.e., \code{abs(x)}).
}
\examples{
## Simulate data from a folded normal by taking absolute values
set.seed(123)
x <- abs(rnorm(200, mean = 1.2, sd = 0.7))

## Estimate parameters
fit <- mle_folded_normal(x)
str(fit)

## Provide custom starting values (mu, log_sigma)
fit2 <- mle_folded_normal(x, start = c(1, log(1)))
}

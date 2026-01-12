\name{fn_mle}
\alias{fn_mle}
\title{MLE for Folded Normal Distribution}
\description{
Estimates the parameters of the folded normal distribution via maximum likelihood.
The optimization uses \code{nlm} with a log-parameterization for \code{sigma} to ensure positivity.
}
\usage{
fn_mle(x, start = NULL)
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
\deqn{f(x;\,\mu,\sigma) = \phi(x;\,\mu,\sigma) + \phi(-x;\,\mu,\sigma).}
Here, \eqn{\phi(\cdot;\,\mu,\sigma)} denotes the normal density with mean \eqn{\mu} and standard deviation \eqn{\sigma}.
Values of \code{x} are treated as absolute values, i.e., \code{abs(x)}.
}
\examples{
## Simulate data from a folded normal by taking absolute values
set.seed(123)
x <- abs(rnorm(200, mean = 1.2, sd = 0.7))

## Estimate parameters
fit <- fn_mle(x)
str(fit)

## Provide custom starting values (mu, log_sigma)
fit2 <- fn_mle(x, start = c(1, log(1)))
}

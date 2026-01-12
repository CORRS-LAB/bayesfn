##' Folded normal density
##'
##' Computes the density of the folded normal distribution for `x` given
##' parameters `mu` and `sigma`. Values of `x` are treated as absolute values.
##'
##' @param x Numeric vector of observations.
##' @param mu Mean of the underlying normal distribution.
##' @param sigma Standard deviation (> 0) of the underlying normal distribution.
##' @return Numeric vector of densities.
##' @keywords internal
density_folded_normal <- function(x, mu, sigma) {
  x <- abs(as.numeric(x))
  dnorm(x, mean = mu, sd = sigma) + dnorm(-x, mean = mu, sd = sigma)
}

neg_loglik_folded_normal <- function(par, x) {
  mu <- par[1]
  sigma <- exp(par[2])
  dens <- density_folded_normal(x, mu, sigma)
  -sum(log(dens))
}

##' MLE for folded normal
##'
##' Estimates `mu` and `sigma` of the folded normal distribution via maximum
##' likelihood using `nlm` with a log-parameterization for `sigma` to ensure
##' positivity.
##'
##' @param x Numeric vector of observations.
##' @param start Optional numeric vector of length 2: initial values for
##'   `(mu, log_sigma)`. If `NULL`, sensible defaults based on `x` are used.
##' @return A list with elements `logLik`, `mu`, `sigma`, `convergence`,
##'   and `iterations`.
##' @export
mle_folded_normal <- function(x, start = NULL) {
  x <- as.numeric(x)
  x <- x[is.finite(x)]
  eps <- 1e-6
  if (length(x) == 0L) stop("x must contain at least one finite numeric value")
  if (is.null(start)) {
    mu0 <- mean(x)
    sd0 <- sd(x)
    if (!is.finite(sd0) || sd0 <= 0) sd0 <- mad(x, constant = 1)
    if (!is.finite(sd0) || sd0 <= 0) sd0 <- 1
    start <- c(mu0, log(sd0 + eps))
  }
  r <- nlm(neg_loglik_folded_normal, start, x = x)
  mu_est <- r$estimate[1]
  sigma_est <- exp(r$estimate[2])
  list(
    logLik = -r$minimum,
    mu = mu_est,
    sigma = sigma_est,
    convergence = r$code,
    iterations = r$iterations
  )
}

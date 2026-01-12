##' Bayesian two-sample test for folded normal means
##'
##' Tests H0: \eqn{\mu_x < \mu_y} vs H1 using posterior samples from a
##' cached Stan model. Returns posterior samples and a decision at the
##' given confidence level.
##'
##' @param x1 Numeric vector for sample 1.
##' @param x2 Numeric vector for sample 2.
##' @param confidence_level Numeric in (0,1); default 0.05.
##' @param iter Iterations per chain; default 10000.
##' @param warmup Warmup per chain; default 4000.
##' @param chains Number of chains; default 4.
##' @param model Optional compiled Stan model; if \code{NULL}, a cached model is loaded.
##' @return A list containing posterior samples for \code{mu1}, \code{mu2}, \code{sigma1}, \code{sigma2},
##'   the posterior probability \code{p_value = P(mu1 > mu2)}, and \code{decision} (0 accept H0, 1 accept H1).
##' @export
two_sample_testing <- function(x1, x2,
                               confidence_level = 0.05,
                               iter = 10000,
                               warmup = 4000,
                               chains = 4,
                               model = NULL) {
  x1 <- as.numeric(x1)
  x2 <- as.numeric(x2)
  if (is.null(model)) {
    model <- get_stan_model()
  }
  eta_lower <- log(1e-2)
  mu_upper <- 10
  dl_1 <- list(N = length(x1), y = x1, eta_lower = eta_lower, mu_upper = mu_upper)
  dl_2 <- list(N = length(x2), y = x2, eta_lower = eta_lower, mu_upper = mu_upper)
  fit_1 <- rstan::sampling(model, data = dl_1, iter = iter, warmup = warmup, chains = chains)
  fit_2 <- rstan::sampling(model, data = dl_2, iter = iter, warmup = warmup, chains = chains)
  s1 <- rstan::extract(fit_1)
  s2 <- rstan::extract(fit_2)
  mu1 <- s1[["mu"]]
  mu2 <- s2[["mu"]]
  sigma1 <- s1[["sigma"]]
  sigma2 <- s2[["sigma"]]
  prob <- mean(mu1 > mu2)
  decision <- if (!is.null(confidence_level)) as.integer(prob > 1 - confidence_level) else NULL
  list(mu1 = mu1,
       mu2 = mu2,
       sigma1 = sigma1,
       sigma2 = sigma2,
       p_value = prob,
       decision = decision)
}

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
##' @param sigma_lower Lower bound for \code{sigma}; default \code{1e-2}. Used for both groups
##'   unless \code{support_restrict = TRUE}.
##' @param mu_upper Upper bound for \code{mu}; default \code{10}. Used for both groups
##'   unless \code{support_restrict = TRUE}.
##' @param support_restrict Logical; if \code{TRUE}, restricts parameter supports per group using the data by
##'   setting \code{sigma_lower_i <- sd(xi)} and \code{mu_upper_i <- mean(xi)} for each sample \code{i=1,2}.
##' @return A list containing posterior samples for \code{mu1}, \code{mu2}, \code{sigma1}, \code{sigma2},
##'   the posterior probability \code{p_value = P(mu1 > mu2)}, and \code{decision} (0 accept H0, 1 accept H1).
##' @export
fn_ttest_bayes <- function(x1, x2,
                               confidence_level = 0.05,
                               iter = 10000,
                               warmup = 4000,
                               chains = 4,
                               model = NULL,
                               sigma_lower = 1e-2,
                               mu_upper = 10,
                               support_restrict = FALSE) {
  x1 <- as.numeric(x1)
  x2 <- as.numeric(x2)
  x1 <- abs(x1)
  x2 <- abs(x2)
  if (is.null(model)) {
    model <- get_stan_model()
  }
  if(support_restrict) {
    sigma_lower1 <- sd(x1)
    mu_upper1 <- mean(x1)
    sigma_lower2 <- sd(x2)
    mu_upper2 <- mean(x2)
  } else {
    sigma_lower1 <- sigma_lower
    sigma_lower2 <- sigma_lower
    mu_upper1 <- mu_upper
    mu_upper2 <- mu_upper
  }
  dl_1 <- list(N = length(x1), y = x1, eta_lower = log(sigma_lower1), mu_upper = mu_upper1)
  dl_2 <- list(N = length(x2), y = x2, eta_lower = log(sigma_lower2), mu_upper = mu_upper2)
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

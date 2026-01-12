##' Bayesian estimation for folded normal
##'
##' Runs a Bayesian estimation of the folded normal parameters for a numeric
##' vector using a cached Stan model to avoid recompilation.
##'
##' @param x Numeric vector of observations.
##' @param sigma_lower Lower bound for \code{sigma} (default \code{1e-2}).
##' @param mu_upper Upper bound for \code{mu} (default \code{10}).
##' @param iter Number of iterations per chain (default \code{10000}).
##' @param warmup Warmup iterations per chain (default \code{4000}).
##' @param chains Number of chains (default \code{4}).
##' @param model Optional compiled Stan model; if \code{NULL}, a cached model is loaded.
##' @return A list with posterior means, Rhat diagnostics, and posterior samples for \code{mu} and \code{sigma}.
##' @export
fitwrap <- function(x,
                                        sigma_lower = 1e-2,
                                        mu_upper = 10,
                                        iter = 10000,
                                        warmup = 4000,
                                        chains = 4,
                                        model = NULL) {
    x <- as.numeric(x)
    if (is.null(model)) {
        model <- get_stan_model()
    }
    dl <- list(
        N = length(x),
        y = x,
        eta_lower = log(sigma_lower),
        mu_upper = mu_upper
    )
    fit <- rstan::sampling(model, data = dl, iter = iter, warmup = warmup, chains = chains)
    fit_summary <- rstan::summary(fit)$summary
    fitsamples <- rstan::extract(fit)
    list(
        mu = fit_summary["mu", "mean"],
        sigma = fit_summary["sigma", "mean"],
        Rhat_mu = fit_summary["mu", "Rhat"],
        Rhat_sigma = fit_summary["sigma", "Rhat"],
        mu_samples = fitsamples[["mu"]],
        sigma_samples = fitsamples[["sigma"]]
    )
}

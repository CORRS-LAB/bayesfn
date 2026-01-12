# Stan model caching utilities for bayesfn

.pkgenv <- new.env(parent = emptyenv())

#' Retrieve compiled Stan model, using cached copy if available
#'
#' This function looks for a previously cached compiled Stan model in a
#' user cache directory. If found, it loads and returns it. If a model has
#' already been loaded in this session, it returns that. If no cached model
#' is found, it tries to locate a packaged model file via \code{system.file}.
#' If none is found, an error is raised instructing the user to compile
#' the Stan code once via \code{compile_stan_model(stan_code)}.
#'
#' @return A compiled Stan model object.
get_stan_model <- function() {
  if (exists("stan_model", envir = .pkgenv, inherits = FALSE)) {
    return(get("stan_model", envir = .pkgenv, inherits = FALSE))
  }
  # Try user cache
  cache_dir <- rappdirs::user_cache_dir("bayesfn")
  cache_path <- file.path(cache_dir, "stanmodel.rds")
  if (file.exists(cache_path)) {
    mdl <- readRDS(cache_path)
    assign("stan_model", mdl, envir = .pkgenv)
    return(mdl)
  }
  # Try packaged files
  pkg_rds <- system.file("stanmodel.rds", package = "bayesfn")
  if (nzchar(pkg_rds) && file.exists(pkg_rds)) {
    mdl <- readRDS(pkg_rds)
    assign("stan_model", mdl, envir = .pkgenv)
    return(mdl)
  }
  pkg_rdata <- system.file("stanmodel.rdata", package = "bayesfn")
  if (nzchar(pkg_rdata) && file.exists(pkg_rdata)) {
    e <- new.env(parent = emptyenv())
    load(pkg_rdata, envir = e)
    # Attempt common object names
    for (nm in c("model", "stan_model", "stanmodel")) {
      if (exists(nm, envir = e, inherits = FALSE)) {
        mdl <- get(nm, envir = e, inherits = FALSE)
        assign("stan_model", mdl, envir = .pkgenv)
        return(mdl)
      }
    }
  }
  # As a last resort, if bundled stan_code exists, compile once and cache
  if (exists("stan_code", envir = asNamespace("bayesfn"), inherits = FALSE)) {
    sc <- get("stan_code", envir = asNamespace("bayesfn"), inherits = FALSE)
    mdl <- rstan::stan_model(model_code = sc)
    assign("stan_model", mdl, envir = .pkgenv)
    # cache persistently
    cache_dir <- rappdirs::user_cache_dir("bayesfn")
    dir.create(cache_dir, showWarnings = FALSE, recursive = TRUE)
    saveRDS(mdl, file.path(cache_dir, "stanmodel.rds"))
    return(mdl)
  }
  stop("No cached Stan model found. Please compile once via compile_stan_model(stan_code).",
       call. = FALSE)
}

#' Compile Stan code and cache the model
#'
#' @param stan_code Character string containing the Stan program.
#' @param save Logical, whether to persist the compiled model to a user cache directory.
#' @return The compiled Stan model object.
#' @export
compile_stan_model <- function(stan_code, save = TRUE) {
  if (missing(stan_code) || !is.character(stan_code) || length(stan_code) != 1) {
    stop("stan_code must be a single character string containing the Stan program.", call. = FALSE)
  }
  mdl <- rstan::stan_model(model_code = stan_code)
  assign("stan_model", mdl, envir = .pkgenv)
  if (isTRUE(save)) {
    cache_dir <- rappdirs::user_cache_dir("bayesfn")
    dir.create(cache_dir, showWarnings = FALSE, recursive = TRUE)
    saveRDS(mdl, file.path(cache_dir, "stanmodel.rds"))
  }
  invisible(mdl)
}

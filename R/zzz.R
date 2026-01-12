# Package load hook to opportunistically load cached Stan model
.onLoad <- function(libname, pkgname) {
  # Try to pre-load a cached model; ignore errors to avoid slowing down attach
  try({
    mdl <- get_stan_model()
    invisible(mdl)
  }, silent = TRUE)
}

\name{compile_stan_model}
\alias{compile_stan_model}
\title{Compile and cache Stan model}
\description{Compiles the bundled Stan code and caches the model so subsequent calls avoid recompilation.}
\usage{compile_stan_model(stan_code, save = TRUE)}
\arguments{
  \item{stan_code}{Character string containing the Stan program.}
  \item{save}{Logical; persist the compiled model to a user cache directory.}
}
\value{The compiled Stan model object (invisible).}
\examples{
## Compile once and cache
# compile_stan_model(stan_code)
}

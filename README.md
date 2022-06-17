
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wbc.counter

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Web
app](https://img.shields.io/badge/WEB-App-red.svg)](https://r-ubesp.dctv.unipd.it/shiny/WBC-counter/)
<!-- badges: end -->

The goal of `{wbc.counter}` is to provide the implementation of an
application of EFSA Exit Strategy on how to provide cumulative evidence
of the absence of African swine fever virus circulation in wild boar
populations using standard surveillance measures.

## Installation

You can install the development version of `{wbc.counter}` like so:

``` r
# install.packages("remotes")
# install.packages("renv")

remotes::install_github("UBEP-DCTV/wbc.counter")
renv::restore()
```

The application source code is in `app/app.R`

## Run

You can find a running instance of the application, freely hosted by
[UBEP](https://www.unipd-ubep.it/) facilities, at
<https://r-ubesp.dctv.unipd.it/shiny/WBC-counter/>.

Once you have installed the package, this is how you can run the
application locally

``` r
library(wbc.counter)
shiny::runApp("app")
```

## Code of Conduct

Please note that the wbc.counter project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

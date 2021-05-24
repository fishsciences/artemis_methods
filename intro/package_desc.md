## Overview of `artemis` Functionality

In addition to the modeling framework described above, the `artemis`
package includes several utility and convenience functions associated
with the planning and analysis of eDNA surveys and sampling. Taken all
together, the functions in the `artemis` R package can be grouped into
a few categories: Modeling, Simulation, Post-hoc analyses, and
Utilities. Modeling and simulation are primarily introduced here, with
detailed vignettes available for post-hoc analyses and utilities
included in the package installation or via the package website 
[`https://fishsciences.github.io/artemis/`](https://fishsciences.github.io/artemis/index.html).

### Modeling

The modeling functions in `artemis` are intended to be drop-in
replacements for `lm()` or `glm()` [@R] while utilizing the generative
model as described in the previous section. An example call to the
modeling function `eDNA_lm()` is,

```
eDNA_lm(Cq ~ Distance_m, 
        data = eDNA_data,
        std_curve_alpha = 21.2, 
        std_curve_beta = -1.5)

```

Note that the parameters for the conversion to $ln[eDNA]$ are
user-provided.  Just as with other modeling functions in R, the user
provides a formula for the model in the form `response ~ predictors`.

The data for the model formula is supplied as a `data.frame` object
passed to the `data` argument of `eDNA_lm()`. Although the model
technically uses the latent variable $ln[eDNA]$ "under the hood" as
the response to the predictors, the formula in `eDNA_lm()` is
expressed on Cq, since Cq is typically present in the raw output of
qPCR analysis.

Internally, the conversion between Cq and $ln[eDNA]$ is conducted
using standard curve coefficients provided by the user. Importantly,
these can be specified as a vector of $\alpha_{std\_curve}$ and
$\beta_{std\_curve}$ values corresponding to the rows of the user's
input data. This allows the use of multiple standard curves within the
same model. Thus, data from different studies or data which use
multiple standard curves can easily be analyzed together.

For mixed- or random-effects models, the modeling function `eDNA_lmer()` can be
used. The formula syntax follows the convention of `lmer()` [@lme4] and
specifies the random effects in the model with,

```
(parameter | grouping variable)

```

Both model types are fit using a Bayesian model fit via the Stan MCMC
program [@stan]. In both `artemis` modeling functions, additional
parameters can be passed to control the MCMC algorithm via the "`...`"
arguments.

### Simulation

The simulation functions `sim_eDNA_lm()` and `sim_eDNA_lmer()` allow
researchers to see the implications of assumptions on the expected
concentration of eDNA, e.g. how $ln[eDNA]$ responds to hypothetical
environmental effects. This can be important both to understand
effects as estimated by an `artemis` model fit to collected data,
and/or as a way to design a study prior to collecting data.

The simulation functions are based on the generative model as outlined
previously, and are populated similarly. As with the `artemis`
modeling functions, the relationships in the simulation are specified
using a model formula. Then, the user provides a set of parameters
(i.e. the "effects") for the linear model on $ln[eDNA]$, the standard
curve coefficients, and the measurement error on $ln[eDNA]$. Lastly, the user
provides the covariate levels for which simulations are desired and
the number of simulations to generate.

For example, a simulation call might be specified
as,

```
sim_eDNA_lm(Cq ~ distance + volume,
              variable_list = list(Cq = 1,
                                   distance = c(0, 10, 50),
                                   volume = c(50, 200)),
              betas = c(intercept = -10.6, 
                        distance = -0.05, 
                        volume = 0.01),
              sigma_ln_eDNA = 1, 
              std_curve_alpha = 21.2,
              std_curve_beta = -1.5)
```
<!--
### Post-hoc analyses

Often, the purpose of an eDNA sampling study is to inform a field
sampling protocol. For these cases, we typically want to know how
likely we are to detect eDNA, given the way that we sampled. The
`est_p_detect()` function returns the calculated probability of at
least one positive detection across a configuration of planned samples
and technical replicates, for example,

```
est_p_detect(variable_levels = c(Intercept = 1, 
                                            Distance = 100),
                        betas = c(Intercept = -10.5, 
                                  Distance = -0.03),
                        ln_eDNA_sd = 1, 
                        std_curve_alpha = 21.2, 
                        std_curve_beta = -1.5,
                        n_rep = 12:30)

```

would return the probability of one or more positive technical
replicates for a design where the distance from source is 100 units,
and the effect of distance on $ln[eDNA]$ is -0.03. The argument
`n_rep` represents the product of the number of eDNA filters and the
number of technical replicates analyzed for each filter, and can be
supplied with a vector that corresponds to a proposed range. For
example, if we planned to take 2-5 filters at each sampling point, and
then analyze six technical replicates for each filter, that would
correspond to the range of `n_rep = 12:30`. In this way, we can use
the `est_p_detect()` function to examine the change in probability of
detection for different levels and combinations of covariates,
including number of filters and technical replicates.

### Utilities

In addition to convenience functions for converting back and forth
from Cq to $ln[eDNA]$ via the parameters of a standard curve (the
functions `lnconc_to_cq()`and `cq_to_lnconc()`), the `artemis` package
also includes methods for R's `plot()`, `summary()`, `data.frame()`,
and `predict()` functions for the `eDNA_model`, `eDNA_simulation`, and
`eDNA_p_detect` classes. For further information, please refer to the
package vignettes and tutorials at
[`https://fishsciences.github.io/artemis/`](https://fishsciences.github.io/artemis/index.html).
-->

### Installation

The `artemis` package is available via the Comprehensive R Archive
Network (CRAN), and can be installed from within R via
`install.packages("artemis")`. The latest development versions is also
available via github at
[`https://github.com/fishsciences/artemis`](https://github.com/fishsciences/artemis).

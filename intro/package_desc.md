## Overview of `artemis` Functionality

The functions included in `artemis` can be grouped into a few
categories; 

  1. Modeling 
  2. Simulation
  3. Post-hoc analyses
  4. Utilities


First, the modeling functions are intended to be drop-in replacements
for `lm()` or `glm()` [@R] while utilizing the generative model as outlined
previously. An example call to the modeling function `eDNA_lm()` is,

```
eDNA_lm(Cq ~ Distance_m, 
        data = eDNA_data,
        std_curve_alpha = 21.2, std_curve_beta = -1.5)

```

As in `lm()`, the user provides a formula for the model in the form,

```
Cq ~ predictors
```

Although the model technically uses the latent variable [eDNA] as the
response to the predictors, the formula is expressed on Cq to avoid
potential confusion regarding the user potentially specifying a column which does
not exist in the input data.frame. 

Internally, the conversion between Cq and [eDNA] is conducted using
standard curve coefficients provided by the user. Importantly, these
can be specified as a vector of $\alpha_{std\_curve}$ and
$\beta_{std\_curve}$ values. This allows the use of multiple standard
curves within the same model. Thus, data from different studies can
easily be analyzed together.

For mixed-effects models, the modeling function `eDNA_lmer()` can be
used. The formula syntax follows the convention of `lmer()` [@lme4] and
specifies the random effects in the model with,

```
(parameter | grouping variable)

```

Both model types are fit using a Bayesian model fit via the Stan MCMC
program [@stan]. Additional parameters can be passed to control the MCMC via
the `...` arguments in either modeling function.

Next, the simulation functions `sim_eDNA_lm()` and
`sim_eDNA_lmer()` allow researchers to see the implications of
assumptions on the expected [eDNA], e.g. how [eDNA] responds to
hypothetical environmental effects. This can be important both to
understand effects as estimated by an `artemis` model fit to collected
data, or as a way to design a study prior to collecting data.

The simulation functions are based on the generative model as outlined
previously, and function similarly to the `artemis` modeling
functions. The relationships in the simulation are specified using a
model formula. Then, the user provides a set of parameters (i.e. the
"effects") for the linear model on log [eDNA], the standard curve
coefficients, and the measurement error on Cq. Lastly, the user
provides the covariate levels for which simulations are desired and
the number of simulations to generate.

An example of a simulation call with random effects,

```
sim_eDNA_lmer(Cq ~ distance + volume + (1|rep) + (1|tech_rep),
              variable_list = vars,
              betas = c(intercept = -10.6, distance = -0.05, volume = 0.01),
              sigma_Cq = 1,
              sigma_rand = c(0.1, 0.1), 
              std_curve_alpha = 21.2,
              std_curve_beta = -1.5)

```

The `artemis` package also includes methods for R's `plot()`,
`summary()`, `data.frame()`, and `predict()` functions for the
`eDNA_model` and `eDNA_simulation` classes.


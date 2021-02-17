## Overview of `artemis` Functionality

The functions included in `artemis` can be grouped into a few
categories; 

  1. Modeling 
  2. Simulation
  3. Post-hoc analyses
  4. Utilities


First, the modeling functions are intended to be drop-in replacements
for `lm()` or `glm()` while utilizing the generative model as outlined
previously. As in `lm()`, the user provides a formula of the form,

```
Cq ~ predictors
```

Although the model technically uses the latent variable [eDNA] as the
response to the predictors, the formula is on Cq to avoid
confusion. Internally, the conversion between Cq and [eDNA] is
conducted.

<!-- Maybe swap this after the modeling? -->

Next, the simulation functions, `sim_eDNA_lm()` and
`sim_eDNA_lmer()`, allow researchers to see the implications of
assumptions on the expected [eDNA], e.g. how [eDNA] responds to
hypothetical environmental effects. The simulation functions are based
on the generative model as outlined previously. The user provides a
set of parameters for the linear model on log [eDNA], the standard
curve coefficients, and the measurement error on Cq. Lastly, the user
provides the covariate levels for which simulations are desired and
the number of simulations to generate. 

 <!-- Example of the simulation workflow here -->
```{r eval = FALSE, warning = FALSE}
sim_eDNA_lmer(Cq ~ distance + volume + (1|rep) + (1|tech_rep),
              variable_list = vars,
              betas = c(intercept = -10.6, distance = -0.05, volume = 0.01),
              sigma_Cq = 1,
              sigma_rand = c(0.1, 0.1), 
              std_curve_alpha = 21.2,
              std_curve_beta = -1.5)

```


The `artemis` package also includes methods for R's `plot()`,
`summary()`, `data.frame()`, and `predict()` functions.


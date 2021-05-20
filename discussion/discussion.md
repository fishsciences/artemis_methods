# Discussion

We were motivated to create the `artemis` package out of the need for better contextualization of both non-detections and the strength of positive detections in eDNA studies. To answer questions such as "Would we
have detected the species of interest if it were within a certain
distance from the sampling site?", we needed to understand the
parameters of the sampling regime in that system. For example, how
quickly did the concentration of eDNA decrease with distance? How much did the filtered
volume of water increase the concentration of eDNA in the filter? We first tried to address these questions using off-the-shelf statistical models, but the results
were not robust.

Our analysis demonstrates the bias introduced by data censorship, as well as how that bias can be mitigated with the use of models which explicitly account for it. In the
case of censored data, like the data generated from a qPCR analysis, the
assumptions of a standard linear model are not met, and we cannot reliably expect valid intervals or unbiased model estimates from it. A model that accounts for the data generation process is needed, but custom statistical models are often inaccessible to the average researcher. By mimicking the syntax of the `lmer` package and the `lm` function in base R, the `artemis` R package provides a simple replacement for standard linear models in R, and also contains several utilities and convenience functions for working with eDNA data and model estimates. More importantly, however, the `artemis` package implements statistical models which account for the data censorship inherent to qPCR data.

In situations where the primary interest is to understand how the concentration of eDNA responds to various sampling or environmental factors, the models in `artemis` are
drop-in replacements for standard linear models. However, when the
primary interest is to estimate presence or absence of a target species, `artemis` requires some additional steps. First, an `artemis` model needs to be fit to
 observed data from the system of interest, for example from a live car
or other controlled experiment. Then, using the estimates, we can produce
predictions of the probability of positive detection for a certain set
of conditions. In other words, after calibrating our estimates, we
can predict how likely we would be to _not_ detect a species if it were
present, given some conditions on the sampling. While not the exact
corollary to traditional occupancy or presence/absence modeling, this may
 be more informative in some situations. 

Environmental DNA sampling studies are often of interest where other
forms of sampling are difficult or impossible, or to supplement an
existing sampling procedure [@adams_beyond_2019]. The species of interest may be quite
rare. For these situations, a standard presence/absence analysis might
lead one to conclude absence, with uncertainty. By contrast, while they do require the additional step of parameterizing for a given sampling procedure, environment, and design, the models implented in `artemis` allow probability statements like the following to be made: "If the species of interest were within 50m of our sampling site, we would have had 95% probability of detecting it."

The censored latent variable models in `artemis` performed better in multiple
metrics compared to standard linear mixed effects models, against both simulated and
observed data. Although `artemis` under-performed in-sample prediction relative to a standard binomial GLM, it also had better performance in out-of-sample prediction. This is an indication that the binomial GLM was over-fit to the in-sample data set. While we demonstrate here that biased estimates are possible when fitting standard linear models to censored data, the degree of bias will depend on the exact characteristics of the
data set. In general, the more observations which experience censorship, the more bias there can be in the estimates. As we observed in the model comparison task, this can invalidate computed Credible Intervals. 

If it were feasible, a mechanistic model of eDNA movement and diffusion from point source would perhaps be the most preferable of all. In our experience conducting eDNA field surveys and experiments, however, parameterizing mechanistic models of particle diffusion and flow to contextualize eDNA data is difficult, cost-prohibitive, and time-consuming, and is often not fully transferable to new environments. The `artemis` package provides a modeling framework that allows for a simple method to generate probability statements from our qPCR data, which in turn allows us to quickly make decisions about future eDNA sampling designs.



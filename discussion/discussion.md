# Discussion

We were motivated to create the `artemis` package out of the need for better contextualization of non-detections in eDNA studies. To answer questions such as "Would we
have detected the species of interest if it were within a certain
distance from the sampling site?", we needed to understand the
parameters of the sampling regime in that system. For example, how
quickly did the concentration of eDNA decrease with distance? How much did the filtered
volume of water increase the concentration of eDNA in the filter? We first tried to address these questions using off-the-shelf statistical models, but the results
were not robust.

The validity of parameter estimates and Confidence/Credible Intervals from a
statistical model are dependent upon the assumptions of the model being met. In the
case of censored data such as data from qPCR eDNA studies, these
assumptions do not hold for a standard linear model and a more appropriate model is needed to get
unbiased estimates and accurate intervals. Here, we demonstrate both
the bias introduced by data censorship, and how this bias is not
present with models which explicitly account for data-censorship.  By mimicking the syntax of the `lmer` package and the `lm` function in base R, the
`artemis` R package provides a simple replacement for standard linear
models in R, but also uses statistical models which account for the data
censorship inherent in qPCR data. Additionally, `artemis` includes
many convienence functions for working with model estimates.

The censored latent variable models in `artemis` performed better in multiple
metrics compared to standard linear models, against both simulated and
observed data. While we demonstrate here that biased estimates are
possible when fitting standard linear models to censored data, the
degree of bias will depend on the exact characteristics of the
dataset. In general, the more observations which experience
censorship, the more bias there can be in the estimates. As we observed here, this can invalidate computed Credible Intervals. 

In situations where the primary interest is to understand how the concentration of eDNA responds to various sampling or environmental factors, `artemis` is a
drop-in replacement for standard linear models. However, when the
primary interest is to estimate presence or absence of a target species, `artemis` requires some additional steps. First, an `artemis` model needs to be fit to
the observed data from the system of interest, for example from a live-car
or other controled experiment. Then, using these estimates, we can produce
predictions of the probability of positive detection for a certain set
of conditions. Or in other words, after calibrating our estimates, we
can predict how likely we would be to not detect a species if it were
present, given some conditions on the sampling. While not the exact
corollary to traditional occupancy or presence/absence modeling, it
can in some situations be more informative. Although `artemis`
under-performed in-sample prediction relative to a standard binomial GLM, it had better performance in out-of-sample prediction. This is an indication that the binomial GLM was over-fit to the in-sample dataset.

Environmental DNA sampling studies are often of interest where other
forms of sampling are difficult or impossible, or to supplement an
existing sampling procedure [@adams_beyond_2019]. The species of interest is often
rare. For these situations, a standard presence/absence analysis might
lead one to conclude absence, with uncertainty. By contrast, the workflow outlined above, while it requires the additional step of parameterizing a model for a given sampling procedure, environment, and design, allows probability statements like the following to be made: "If the species of interest were
within 50m of our sampling site, we would have had 95% probability of detecting it." 

To be clear, a mechanistic model of eDNA movement and diffusion from
point source would be preferable. In our
experience, however, setting up mechanistic models of particle
diffusion and flow to contextualize eDNA data is difficult and 
time-consuming, and is often not fully transferable to new environments. The `artemis` package provides a modeling framework that allows for a simple and quick method to generate probability statements from our sampling designs, which in turn allow us to quickly make decisions about eDNA survey designs. 

The need for non-invasive cost-effective sampling, especially for
low-density, cryptic, difficult to sample populations, is growing and
will continue to drive development of molecular-based methods
[@adams_beyond_2019].  This need also includes effective
early-detection for invasive species [@miliangarcia_optimization_2021;
@sepulveda_adding_2019].  Improved processing and analysis tools for molecular-based methods will lead to improved management of natural resources.


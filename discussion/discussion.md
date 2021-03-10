# Discussion

The creation of `artemis` was motivated to contextualize
non-detections in eDNA studies. To answer questions such as "Would we
have detected the species of interest if it were within a certain
distance from the sampling site?", we needed to understand the
parameters of the sampling regime in that system. For example, how
quickly did [eDNA] fall off with distance? How much did the filtered
volume of water increase [eDNA] in the filter? These questions could
be answered using off-the-shelf statistical models, but the results
were not robust.

The parameter estimates and confidence/credible intervals from a
statistical model are depenent on the assumptions being valid. In the
case of censored data such as data from qPCR eDNA studies, these
assumptions do not hold and a more appropriate model is needed to get
unbiased estimates and accurate intervals. Here, we demonstrate both
the bias introduced by data censorship, and how this bias is not
present with models which explicitly account for data-censorship.
The `artemis` R package provides a simple replacement for standard
linear models in R, but using underlying these statistical models which
account for the data censorship. Additionally, `artemis` includes many
convienence functions for working with model estimates. 

In situations where the primary interest is to understand how [eDNA]
responds to various sampling or environmental factors, `artemis` is a
drop-in replacement for standard linear models. However, when the
primary interest is to estimate presence/absence, `artemis` requires
some additional steps. First, an `artemis` model needs to be fit to
the observed data from the system of interest, often from a live-car
or other controled experiment. Then, using these estimates, we can produce
predictions of the probability of positive detection for a certain set
of conditions. Or in other words, after calibrating our estimates, we
can predict how likely we would be to not detect a species if it were
present, given some conditions on the sampling. While not the exact
corollary to traditional occupancy or presence/absence modeling, it
can in some situations be more informative.

Environmental DNA sampling studies are often of interest where other
forms of sampling are difficult or impossible, or to suppliment an
existing sampling procedure. The species of interest is often
rare. For these situations, a standard presence/absence analysis might
reveal complete absence. By contrast, the workflow outlined above
allows probability statements such as "If the species of interest were
within 50m of our sampling site, we would have 95% probability of
detection." It does, however, require the additional step of
parameterizing a model for the environment and situation. 

To be clear, a mechanistic model of eDNA movement and diffusion from
point source would be preferable. 
<!-- Examples of these models? -->
Though we demonstrate here that
`artemis` provides a modeling framework more appropriate for qPCR eDNA
data, we cannot claim it is ultimately the best model. In our
experience, however, setting up mechanistic models of particle
diffusion and flow to contextualize eDNA data is difficult,
time-consuming, and the end product does not have the desired level of
accuracy for many purposes. Having a simple and quick method to
generate probability statements allows us to quickly refine sampling
designs and make decisions. 


----------------


Discussion of when and how the truncated latent variable model
out-performed other modeling approaches for this data Introduction of
the artemis package and its related suite of modeling functions
Discussion of questions and scenarios for which our model would be the
less appropriate choice than others presented

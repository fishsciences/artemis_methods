## Common approaches to analyzing eDNA data 

<!-- @Von - please insert these citations into the bib file and replace refs here -->

qPCR data from eDNA studies are often modeled via a binary response
model, e.g. occupancy models [@schmidt_site_2013; @dorazio_2018] or some form of
binomial regression [@moyer_assessing_2014; @song_making_2017;
@hinlo_environmental_2017]. In these, the response is a binary
variable signifying the presence/absence of eDNA in the sample. More
accurately, this binary variable indicates whether a sample had a Cq
value below the censoring point, i.e., the detection threshold. Presence is assumed when a sample
had at least one value below this threshold, though studies vary on
what defines the unit of study, e.g. a single detection in a technical
replicate, filter, sampling point, or occurrence. Regardless, by using
"off-the-shelf" statistical models and programmatic tools, these analysis methods allow for easy
estimation of various covariates on the probability of the target species' presence.

Using a binary response for eDNA studies has the advantage of ease of
analysis, as many off-the-shelf statistical programs can estimate a
binomial model. However, a trade-off comes with this ease of
analysis within a study, and that is the difficulty in comparing _between_
studies. Binary response models are dependent on the threshold which
defines a non-detection. This cutoff threshold is a function of 1) the
standard curve, which defines the ln[eDNA] that corresponds to the
threshold value, and 2) researcher decisions. For example, in
response to the level of sensitivity of an assay, some researchers
might use a maximum Cq threshold of 35 cycles
[@huver_development_2015], while others use 40 or even 45 cycles [@piggott_evaluating_2016]. Thus the ln[eDNA] which corresponds to the maximum Cq value for
a particular set of extractions varies between studies, and therefore "presence" of a target species
across studies can refer to different actual concentrations of eDNA in samples.

One solution to this quandary is to model either the Cq values
themselves, the concentration, or the copy number as a continuous response variable in a linear regression, wherein the effects of various covariates on it can be estimated.  In particular,
using the ln[eDNA] or copy number avoids some of the issues outlined above. Similar to a
binary response variable, modeling ln[eDNA] or copy number can be accomplished
using common statistical software. However, as with binomial implementations, the continuous Cq,
concentration, or copy number is still associated with the detection
threshold: since the standard curve, which is lab-dependent, defines
the concentration at which further qPCR cycles are not attempted, the
standard curve defines a statistical censoring point for the response variable, regardless of whether it is modeled as binary or continuous.

Statistical censoring is a well-studied phenomenon where data values
above or below a certain threshold value are recorded as the threshold
value<!--does this need citation?-->. Conceptually, this represents a partially
missing value - it is known that the value is beyond the threshold,
but its exact value is unknown. A naive analysis of censored data
which does not take this into account (such as the linear modeling of
Cq, eDNA concentration, or copy number described above) will overestimate
the certainty associated with values near or at the threshold. In eDNA studies, when all ln[eDNA] or copy number values are relatively high (i.e. far from
the censoring point) the censoring point will have negligible impact on the
analysis. However, when there are many values near the censoring point (that is, near the limit of detection),
estimates will be biased.

Therefore, there is a need to take the above issues into consideration
in eDNA analyses, while also providing the ease of use of common
statistical programs.

## Modeling qPCR eDNA Data with `artemis` {#mod_str}

We created the `artemis` R package to implement Bayesian censored
latent variable models, which mitigate the issues with commonly-used
statistical analysis techniques on qPCR data. At
its core, `artemis` is a specialized Generalized Linear Model, where
the predictors are assumed to affect the response variable additively,
in this case $ln[eDNA]$,

$$ ln[eDNA]_{i} = X_{i} \beta $$ 

where $\beta$ is a vector of effects on $ln[eDNA]_{i}$, and $X_{i}$
is a vector of predictors.  Since `artemis` directly models the
effect of the predictors on the latent (unobserved) variable, $ln[eDNA]$,
it is unnecessary for the researcher to back-transform the data prior
to modeling. Internally, `artemis` conducts this conversion using the
user-supplied values for the formula,

$$\hat{Cq_i} = \alpha_{std\_curve} + \beta_{std\_curve}* ln[eDNA]_i  $$

Where $\alpha_{std\_curve}$ and $\beta_{std\_curve}$ are fixed values
from setting the standard curve in the lab prior to qPCR.  

Internally, the back-transformed $ln[eDNA]_i$ values are considered a
sample with measurement error from the true $ln[eDNA]_i$ value
($\hat{ln[eDNA]_i}$) in the extract. 

$$ ln[eDNA]_i \sim Trunc. Normal(\hat{ln[eDNA]_i}, \sigma_{Cq}, U) $$

Where the observed $ln[eDNA]_i$ values are censored at the
predetermined threshold, $U$. This threshold is back-transformed from
the threshold on Cq. Importantly, the $\hat{ln[eDNA]}$ values in
the model are not censored, allowing the latent variable to reflect the "true"
log-concentration of eDNA beyond the censorship point. The likelihood that a sampled $ln[eDNA]$
value will exceed the threshold is a function of the measurement error
and the estimated latent $\hat{ln[eDNA]_i}$ value. We calculate this
likelihood using the normal
cumulative distribution function, $\Phi()$,

$$ Pr(ln[eDNA]_i > U ) = 1 - \Phi(\hat{ln[eDNA]_i} - \mu_i / \sigma)$$

Thus, the models in `artemis` account for the data censoring process by
estimating the probability that the observed value will exceed the
threshold. As detection limits vary with genetic assay, the upper
threshold on Cq in the model is specifiable by the user.

<!-- Lastly, there are optional zero-inflated versions of `artemis` models, implemented in the package by the functions
`eDNA_lm_zinf()` and `eDNA_lmer_zinf()`. We included these zero-inflated versions after observing that there can be near-zero concentrations of eDNA even in
situations where higher concentrations of eDNA would have been expected (i.e., when samples were taken very close to the source of a large, known quantity of eDNA). This was
attributed to filter failures or other (unknown) issues with the sampling. To
account for this mechanism, the zero-inflated versions of the models
allow for the occurrence of eDNA concentrations that are equal to zero (or effectively zero, according to the detection threshold) from a secondary
mechanism. Currently, the functions do not support user-provided
predictors on the zero-inflated component, and just estimate a flat
probability of zero detections for all observations. However, users
can provide a prior for the expected probability of "true" zero
observations from a secondary mechanism. -->  This model formulation makes
several assumptions: 1) $ln[eDNA]$ is assumed to be uniform within a
sample, 2) $ln[eDNA]$ is sampled with normally distributed errors, and
3) there are no false detections, i.e. the measurement error cannot
result in a positive detection when the target species' eDNA is not present in the sample.

Importantly, this formulation produces estimates of the effect sizes
which are modeled directly on $ln[eDNA]$ or copy number, rather
than Cq, therefore are independent of the standard curve and can be
compared between studies that use different standard curves. This model formulation also
accounts for the data censoring at the upper limit of qPCR cycles,
handling uncertainty and reducing bias in the
estimates.

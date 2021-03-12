## Common approaches to analyzing eDNA data 

<!-- @Von - please insert these citations into the bib file and replace refs here -->

qPCR data from eDNA studies are often modeled via a binary response
model, e.g. occupancy models (Schmidt et al 2013) or some form of
binomial regression (Moyer et al. 2014; Song et al. 2017; Hinlo et
al. 2017). In these, the response variable is a binary variable
signifying the presence/absence of eDNA in the sample. More
accurately, this binary variable indicates whether a sample had a Cq
value below the detection threshold. Presence is take to be when a
sample has at least one value below this threshold, though studies
vary on what defines the unit of study, e.g. a single detection in a
technical replicate, filter, or sampling point or
occurnace. Regardless, these analysis methods allow for easy
estimation of various covariates on the probability of presence using
off-the-shelf analysis programs.

hese methods which use a binary response variable have a significant
weakness, however - they are dependent on the threshold which defines
a non-detection. This cutoff threshold is a
function of 1) the standard curve, which defines the [eDNA] which
corresponds to the threshold value, and 2) and researcher
decisions. For example, some researchers use a maximum Cq threshold of
40 cycles, while others use 50 cycles. Thus the [eDNA] which
corresponds to the maximum Cq value for a particular set of
extractions varies between studies and "presence" in different studies
can refers to different concentrations of eDNA.

Using a binary response for eDNA studies has the advantage of ease of
analysis, as many off-the-shelf statistical programs can estimate a
binomial model. However, there is a trade-off with this; the ease of analysis
within a study verses difficulty in comparing between studies.

One solution to this quandary is to model either the Cq values
themselves or a concentration/copy number (as back-calculated from the
Cq values via the standard curve) as a continuous response variable.
This response variable is then analyzed using a linear model to
estimate the effects of various covariates on [eDNA].  Similar to the
binary response variable, this can be accomplished using common
statistical software. In particular, using the [eDNA] or copy number
values backtransformed from the observed Cq values using the standard
curve can avoids some of the above issues. However, even in this case,
the response variable is still dependent on a particular standard
curve due to the detection threshold. Since the standard curve defines
the concentration at which further qPCR cycles are not attempted, the
standard curve defines a censoring point for the response variable.

Statistical censoring is a well studied phenomenon where data values
above or below a certain threshold value are recorded as the threshold
value (citation needed). In effect, this represents a partially missing value - it is
known that the value is beyond the threshold, but its exact value is
unknown. A naive analysis of censored data which does not take this
into account will underestimate uncertainty in values near or at the
threshold. In eDNA studies, this means that when all [eDNA] values are
relatively high, i.e. far from the censoring point, the censoring
point has negligable impact on the analysis. When there are values are near the
censoring point, estimates will be biased. 

Therefore, there is a need to take the above into consideration in the
analysis, while also providing the ease of use of common statistical
programs. 

## Modeling qPCR eDNA Data with `artemis` {#mod_str}

To address the above weaknesses of common statistical analysis
techniques with qPCR eDNA data, we created the `artemis` R package. At
its core, `artemis` implements Bayesian censored latent variable
models. Additionally, `artemis` includes utilities to aid in the
design and analysis of eDNA survey studies, including simulation and
power analysis functions.

 <!-- probably cut this
 
  3. The potential sources of measurement error in the extraction and 
     qPCR processes are difficult to separate and quantify. For
     example, Cq values produced by qPCR become more variable at the
     threshold of detection, i.e. as the number of eDNA molecules
     available for amplification approaches zero.  This source of
     variability in the response is different from that produced by
     error introduced in the pipetting process, but they have the same
     effect on Cq (namely, increasing variability).
-->

At its core, `artemis` is a specialized Generalized Linear
Model, where the predictors are assumed to additively affect the
response variable, in this case $log[eDNA]$, 

$$ log[eDNA]_{i} = X_{i} \beta $$ 

where $\beta$ is a vector of effects on $log[eDNA]$, $X$ is the model
matrix of predictors.
Since `artemis` directly models the
effect of the predictors on the latent (unobserved) variable, [eDNA], it is unnecessary for the researcher to
back-transform the data prior to modeling. Internally, `artemis`
conducts this conversion, 

$$\hat{Cq_i} = \alpha_{std\_curve} + \beta_{std\_curve}* log[eDNA]_i  $$

Where $\alpha_{std\_curve}$ and $\beta_{std\_curve}$ are fixed values
from setting the standard curve in the lab prior to qPCR.  These
coefficients for the standard curve equation ($\alpha_{std\_curve}$
and $\beta_{std\_curve}$) are provided to the modeling function.

Internally, the observed Cq value ($Cq_i$) is considered a sample with
measurement error from the true Cq value ($\hat{Cq_i}$) in
extract. Thus, `artemis` accounts for measurement error in this
conversion. 

$$ Cq_i \sim Trunc. Normal(\hat{Cq_i}, \sigma_{Cq}, U) $$

Where the observed Cq values, $Cq_i$, are censored at the
predetermined threshold, U, Importantly, the $\hat{Cq_i}$ values in
the model are not, allowing the latent variable to reflect the "true"
[eDNA] beyond the censorship point. The likelihood that a sampled Cq
value will exceed the threshold, given measurement error in the
process and an estimated $\hat{Cq_i}$ value is given by the normal
cumulative distribution function, $\Phi()$,

$$ Pr[Cq_i > U ] = 1 - \Phi(\hat{Cq_i} - \mu / \sigma)$$

Thus, `artemis` accounts for the the data censoring process by
accounting for the probability that the observed value will exceed the
threshold. As detection limits vary with genetic assay, the upper
threshold on Cq in the model is adjustable by the user.

<!-- Not in current version

Lastly, there is an optional zero-inflated component in the model. From
multiple experiments, it was observed there can be near-zero
concentrations of eDNA even in situations where higher concentrations
were expected. This was attributed to filter failures. The expected
probability of this occuring is user-provided, and allows for "true"
zero observations
   -->

This model formulation makes several assumptions:
 
  1. $log[eDNA]$ is assumed to be uniform within a sample.
  
  2. $log[eDNA]$ is sampled with normally distributed errors.
  	
  3. There are no false detections, i.e. the measurement error cannot
    result in a positive detection when eDNA is not present in the
    sample. 

Importantly, this formulation produces estimates of the effect sizes
which:

  - are modeled directly on $log[eDNA]$ or copy number, rather than Cq, *therefore are independent
	of the standard curve and can be compared between studies*.
  
  - account for the data censoring at the upper limit of qPCR
    cycles, *which properly accounts for uncertainty and reduces bias in the estimates.*
	
	<!--
  - directly model the measurement error on qPCR extraction, *allowing
    quantification of the amount of uncertainty attributable to
    uncertainty in the effect sizes vs. lab procedure.*

In `artemis`, the model is specified using an R model formula, similar
to the `lm()` or `lmer()` functions. This model formula is used to
construct the model on $log[eDNA]$. The functions in `artemis`
generalize to any eDNA survey data containing Cq values associated
with a standard curve for the target species.

-->


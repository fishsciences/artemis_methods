## Modeling [eDNA]

<!-- adapted from vignette -->

### Common qPCR eDNA analyses

qPCR data from eDNA studies are often modeled via a binary response
model, e.g. occupancy models (Schmidt et al 2013) or some form of
binomial regression (Moyer et al. 2014; Song et al. 2017; Hinlo et
al. 2017). In these, the response variable is a binary variable
signifying the presence/absence of eDNA in the sample. This binary
variable commonly indicates whether a sample had a Cq value below the
threshold, though studies vary on the unit of study, e.g. a technical
replicate, filter, or sampling point or occurnace. Regardless, these
analysis methods allow for easy estimation of various covariates on
the probability of presence using off-the-shelf analysis programs. 

However, these methods which use a binary response variable have a
significant weakness - they are dependent on the cut-off point which
defines a non-detection. A "non-detection" is more appropriately
defined as a concentration below a pre-specified cutoff threshold.  As
discussed previously, this cutoff threshold is a function of the
standard curve and researcher decisions. The [eDNA] which corresponds
to the maximum Cq value for a particular set of extractions varies
between studies.  For example, some analyses use a maximum Cq
threshold of 40 cycles, while others use 50 cycles. Therefore,
"presence" in different studies actually refers to different
concentrations of eDNA between the two studies. Hence there is a
trade-off; the ease of analysis within a study verses difficulty in
comparing between studies.

One solution to this quandary is to model either the Cq values
themselves or a concentration/copy number (as back-calculated from the
Cq values via the standard curve) as a continuous response variable.
This response variable is then analyzed using a linear model to
estimate the effects of various covariates on [eDNA].  Similar to the
binary response variable, this can be accomplished using common
statistical software. However, while this addresses some issues
related to using a binary response variable, the response variable is
still dependent on a particular standard curve. Since the standard
curve defines the concentration at which further qPCR cycles are not
attempted, the standard curve defines a censoring point for the
response variable.

Statistican censoring is a well studied phenomenon where data values
above or below a certain threshold value are recorded as the threshold
value. In effect, this represents a partially missing value - it is
known that the value is beyond the threshold, but its exact value is
unknown. A naive analysis of censored data which does not take this
into account will underestimate uncertainty in values near or at the
threshold. In eDNA studies, this means that when [eDNA] values are
relatively large, i.e. far from the censoring point, the censoring
point has negligable impact on the analysis. When values are near the
censoring point, estimates will be biased. 


Therefore, there is a need to take the above into consideration in the
analysis, while also providing the ease of use of common statistical
programs. 

Data from eDNA sampling surveys is often analyzed with occupancy
models or GLMS, but there are several characteristics of qPCR data in
particular which made us feel that it would benefit from a different
modeling approach.  Specifically, our approach to this data makes use
of Bayesian truncated latent variable models written in
[Stan](mc-stan.org).


### Modeling qPCR eDNA Data with `artemis`


The `artemis` R package was created to aid in the design and analysis
of eDNA survey studies by offering a custom suite
of models for quantitative polymerase chain reaction (qPCR) data from
extracted eDNA samples. 

  1. In eDNA samples that are extracted and run through qPCR analysis,
     the concentration of eDNA is not directly measured. Instead, the
     amount of eDNA present is represented as a function of the number
     of quantification cycles of qPCR (hereafter referred to as the
     "Cq" value) completed before amplification takes place. eDNA
     concentration ($[eDNA]$) is then related to Cq via a standard
     curve generated in the lab for the target species. This standard
     curve formula typically takes the form: $$Cq = log[eDNA] *
     \beta + \alpha$$ The standard curve is specific to the lab
     reagents and techniques used. The implication of this is that
     models using Cq values (or a derived value such as a "positive"
     detection) as the response result in estimates of effect sizes
     which cannot be directly compared between different studies using
     different standard curves.
	 
  2. A higher Cq value corresponds to a lower concentration of eDNA in
     a sample. Above a pre-determined threshold, additional
     quantification cycles are not attempted. Therefore,
     "non-detection" is taken to be any sample which requires more
     than the threshold number of cycles to detect. Failing to account
     for this data censoring process can result in increased
     uncertainty and bias in our estimates of the effect sizes.
  
  3. The potential sources of measurement error in the extraction and
     qPCR processes are difficult to separate and quantify. For
     example, Cq values produced by qPCR become more variable at the
     threshold of detection, i.e. as the number of eDNA molecules
     available for amplification approaches zero.  This source of
     variability in the response is different from that produced by
     error introduced in the pipetting process, but they have the same
     effect on Cq (namely, increasing variability).
	 
The `artemis` package addresses these issues by directly modeling the
effect of the predictors on the latent (unobserved) variable, eDNA
concentration. It does this by linking eDNA concentration to the
observed response via the parameters of an associated standard
curve. The general model is as follows:

$$ Cq_i \sim Normal(\hat{Cq_i}, \sigma_{Cq}) $$
$$\hat{Cq_i} = \alpha_{std\_curve} + \beta_{std\_curve}* log[eDNA]_i  $$
$$ log[eDNA]_{i} = X_{i} \beta $$ 

where $\beta$ is a vector of effects on $log[eDNA]$, $X$ is the model
matrix of predictors and $\alpha_{std\_curve}$ and
$\beta_{std\_curve}$ are fixed values provided by the standard curve.

Additionally, there is a zero-inflated component in the model. From
multiple experiments, it was observed there can be near-zero
concentrations of eDNA even in situations where higher concentrations
were expected. This was attributed to filter failures. The expected
probability of this occuring is user-provided, and allows for "true"
zero observations when set to a value greater than 0.

As detection limits vary with genetic assay, the upper threshold on Cq
in the model is adjustable.  Any values of $\hat{Cq_i}$ which are
greater than the upper limit on $Cq_i$ are recorded as the threshold
value.  For example, a $\hat{Cq_i}$ value of 42 is recorded as 40 when
the upper limit is 40 cycles.

   
This model formulation makes several assumptions:
 
  - $log[eDNA]$ is assumed to be uniform within a sample.
  
  - $log[eDNA]$ is sampled without error.
  
  - All measurement error is introduced in the extraction/qPCR
    stage. Field sampling is assumed to take place without error.*
	
  - There are no false detections, i.e. the measurement error cannot
    result in a positive detection when eDNA is not present in the
    sample. 


*`*`Future versions of the `artemis` package might allow for measurement
error in both the field collection and qPCR stages.*

Importantly, this formulation produces estimates of the effect sizes
which:


  - are modeled directly on $log[eDNA]$ rather than Cq, *therefore are independent
	of the standard curve and can be compared between studies*.
  
  - account for the data censoring at the upper limit of qPCR
    cycles, *which reduces uncertainty and bias in the estimates.*
	
  - directly model the measurement error on qPCR extraction, *allowing
    quantification of the amount of uncertainty attributable to
    uncertainty in the effect sizes vs. lab procedure.*

In `artemis`, the model is specified using a model formula, similar to
the `lm()` or `lmer()` functions. This model formula is used to
construct the model on $log[eDNA]$.

The functions in `artemis` generalize to any eDNA survey data
containing Cq values associated with a standard curve for the target
species.

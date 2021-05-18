# Methods

## Simulation 

To demonstrate the strength and utility of the `artemis` package for
modeling eDNA data, we compare `artemis` models to standard
mixed-effects analysis.  We simulated 500 datasets using the
generative process outlined previously in [Section 1.4](#mod_str).  Then, we used two
different eDNA modeling approaches, a linear mixed-effects model and
`artemis`'s censored-data mixed-effects model to attempt to estimate
the original parameters used to simulate the data. 

For this task, only models which directly estimate effects on the
latent or back-transformed ln[eDNA] values were compared. To further
make the results more directly comparable, the mixed-effects model was
fit using the `rstanarm` R package(v2.21.1, @rstanarm), a Bayesian modeling package. The
`rstanarm` and `artemis` packages both use the Stan probabilistic
programming language to estimate parameters [@stan]. Furthermore, many of the
defaults in `artemis` functions mirror those in `rstanarm`, which in
turn mirror those of the `(g)lm` [@R] and `(g)lmer` [@lme4] functions. For the
purposes of this demonstration, we simulated an experiment with two
different filtered volumes, 50 and 100mL, and ten different distances
from eDNA emission source spread equidistant from 0 to 1000
m. Additionally, we simulated three filters per measurement and three
technical replicates per filter. All simulation was done in R, and the
code can be found at
[`https://github.com/fishsciences/artemis_methods`](https://github.com/fishsciences/artemis_methods).
Note that while `artemis` contains similar functions to simulate data,
we opted to replicate the data outside of `artemis`'s functions for
transparency. 

## Experimental Data

The data used were the combined qPCR results from a Delta Smelt "live
car" experiment conducted in the primary intake channel of the Tracy
Fish Collection Facility (TFCF). The TFCF collects fish before they
are permanently entrained into the US Bureau of Reclamation’s Central
Valley Project (CVP). This water intake is located the southwest
portion of the CVP in the Sacramento - San Joaquin River Delta,
California, USA [@bowen2004].  The data used here are from an experiment completed on 2017-08-02, part
of a series of live car experiments at the CVP in coordination with the TFCF in August-September of 2017.  All water filtering, eDNA extraction, and qPCR analysis procedures associated with the experiment
followed those described in @schumer_utilizing_2019.  One hundred live (cultured)
Delta Smelt were placed in a rigid, meshed enclosure (the "live car") and suspended from the primary
louvers in the intake channel. Two sets of three water samples each were taken
at 10m intervals, from 10m-50m, from near to far in the downstream direction relative to the live car.  The first set of samples pulled 50mL of water through each filter; the second set of samples pulled 200mL per filter. This procedure was then replicated in the upstream direction (far to near) relative to the live car. Note that the car itself (distance = ~0m) was not actually
sampled. Approval for this experiment was via United States Fish and Wildlife Service (protocol 2017 §10(a)(1)(A) recovery permit TE-027742-5) and California Department of Fish and Wildlife (protocol 2017 MOU under Scientific Collecting Permit SC-005544). Each filter was extracted and analyzed three times with qPCR
(three technical replications). The qPCR data from these experiments
is plotted in Figure 1. 

To model these
data, we assume a fixed effect of distance (m) and volume sampled
(mL). For mixed-effects models, we assume a random intercept term for
each unique filter (FilterID).

Two different methods were used to compare model performance. First,
the Pareto-Smoothed Leave-one-out Information Criteria was calculated
for each model using the `loo` package in R [@loo]. This metric
assesses a model's performance predicting out-of-sample data, which
gives a measure of how well the model performs relative to the risk of
overfitting to the data. Next, each model was used to predict the
expected response values for a third experiment's dataset collected in
the same system. This gives a realistic example of prediction error
for each model.

<!-- Unsure about this - might need clarification --> 

To broaden the comparisons to other models commonly used to analyze
eDNA data, we compared the classification performance between binomial
models.  First we fit a binomial mixed-effects model to the same
experimental dataset as above. The response was "presence", a binary
variable indicating whether the Cq was lower than the detection
threshold according to its standard curve. The model was fit similar
to the linear models above using the `rstanarm` R package.  We then
generated a predicted value (presence or absence) for each observation
in the in-sample dataset (the data used to estimate model parameters)
and the out-of-sample dataset (data not used to estimate
parameters). Since the Bayesian model produces many posterior
predictions, we took a predicted "presence" to be when 50% or more of
the posterior predictions were presences.  To compare to a model fit
with `artemis`, predictions were generated for each observation. The
median predicted Cq value was taken as the predicted value, and then
predictions were classified as presence/absence according to whether
the predicted value was below or above the detection threshold.
Finally, to compare the classification performance for the in-sample
and out-of-sample predictions, the precision (the proportion of
positive predictions actually correct) and recall (the proportion of
actual positives predicted correctly) were calculated. A precision of
1 indicates the model had no false positives. A recall of 1 indicates
the model had no false negatives [@googleml].

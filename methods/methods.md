# Methods

To demonstrate the strength and utility of the `artemis` package for
modeling eDNA data, we compare the models in the `artemis` package to
standard mixed-effects analysis. To ensure that the results were
directly comparable, competing models were fit using the
`rstanarm` R package (v2.21.1) [@rstanarm], a Bayesian modeling
package. The `rstanarm` package was chosen for several reasons. First,
the `rstanarm` and `artemis` packages both use the Stan
probabilistic programming language as a back-end to estimate parameters
[@stan]. Furthermore, many of the defaults in `artemis` functions
mirror those in `rstanarm`, which in turn mirror those of the `(g)lm`
[@R] and `(g)lmer` [@lme4] functions. Both `artemis` and `rstanarm`
models support similar model comparison metrics, allowing one-to-one
comparisons between models.

## Simulated data 

We simulated 500 datasets using the generative process outlined
previously in [Section 1.3](#mod_str) with known parameter values.  We
then used two different eDNA modeling approaches to recover
(estimate) the original parameters used to simulate the data: a linear
mixed-effects model, and `artemis`'s censored-data mixed-effects
model.

For this task, only models which directly estimate effects on the
latent or back-transformed $ln[eDNA]$ values were compared. Hence, the
the simulations first simulated $ln[eDNA]$ values then converted these
to Cq values via a hypothetical standard curve. These Cq values were
used directly by the `artemis` models (which internally convert to
$ln[eDNA]$), but had to be back-transformed to $ln[eDNA]$ prior to
modeling with `rstanarm`. For the purposes of this demonstration, we
simulated an experiment with two different filtered volumes, 50 and
100mL, and ten different distances from eDNA emission source spread
equidistant from 0 to 1000 m. Additionally, we simulated three filters
per measurement and three technical replicates per filter. Note that
while `artemis` contains similar functions to simulate data, we opted
to replicate the data in base R, outside of `artemis`'s functions, for
transparency.  All data and code is freely available at 
[`https://github.com/fishsciences/artemis_methods`](https://github.com/fishsciences/artemis_methods)
[@2021_artemis].

## Experimental data 

In addition to simulated data, we also employed a previously-collected
experimental data set for the task of model comparison. The data used
were the qPCR results from a Delta Smelt "live car" experiment
conducted in the primary intake channel of the Tracy Fish Collection
Facility (TFCF). The TFCF collects fish before they are permanently
entrained into the US Bureau of Reclamation’s Central Valley Project
(CVP). This water intake is located in the southwest portion of the
CVP, in the Sacramento - San Joaquin River Delta, California, USA
[@bowen2004]. The experiment was completed on 2017-08-02, part of a
series of live car experiments at the CVP in coordination with the
TFCF in August-September of 2017.  All water filtering, eDNA
extraction, and qPCR analysis procedures associated with the
experiment followed those described in @schumer_utilizing_2019.

In this experiment, one hundred live (cultured) Delta Smelt were
placed in a rigid, meshed enclosure (the "live car") that was
suspended from the primary louvers in the intake channel. Two sets of
three water samples each were then filtered at 10m intervals,
beginning at 10m and ending at 50m from near to far in the downstream
direction relative to the live car.  The first set of three samples
pulled 50mL of water through each filter at each interval; the second
set of three samples pulled 200mL per filter at each interval. This
procedure was then replicated in the upstream direction (from far to
near) relative to the live car. Each filter was extracted and analyzed
three times with qPCR (three technical replications). The qPCR data
from these experiments is plotted in Figure 1. Approval for the
experiment was via United States Fish and Wildlife Service (protocol
2017 §10(a)(1)(A) recovery permit REDACTED<!--TE-027742-5-->) and California
Department of Fish and Wildlife (REDACTED<!--protocol 2017 MOU under Scientific
Collecting Permit SC-005544-->).

To model the experimental data, we assume a fixed effect of distance
(m) and volume sampled (mL). For mixed-effects models, we assume a
random intercept term for each unique filter (FilterID).

## Model comparison

Two different methods were used to compare performance between the
standard mixed-effects linear model and the `artemis` model. First,
the Pareto-Smoothed Leave-one-out Information Criteria was calculated
for each model using the `loo` package in R [@loo]. This metric
assesses a model's performance by approximating predictive performance
on out-of-sample data. This provides a measure of how well the model
performs relative to its risk of overfitting to the data. Next, each
model was used to predict the expected response values for a second
experimental data set, collected in the same system and following the
same procedures as described above. From these predictions, the Root
Mean Square Error (RMSE) was calculated. This allowed for a realistic
example of out-of-sample prediction error for each model.

To broaden the comparisons to other models commonly used to analyze
eDNA data, we also compared the classification performance between
binomial models. First we fit a binomial mixed-effects model to the
first experimental data set. The modeled response was "presence", a
binary variable indicating whether the Cq of an observation was lower
than the detection threshold, according to its standard curve. The
model was fit similarly to the mixed-effects linear model, again using
the `rstanarm` R package.  We then generated a predicted value
(presence or absence) for each observation in the in-sample data set
(the data used to estimate model parameters) and the out-of-sample
data set (data not used to estimate parameters). Since the Bayesian
model produces many posterior predictions, we took a predicted
"presence" to be when 50% or more of the posterior predictions were
presences.  To compare to the model fit with `artemis`, predictions
were generated for each observation. The median predicted Cq value was
taken as the predicted value, and each prediction was then classified
as a presence or an absence, according to whether the predicted value
was below or above the detection threshold.  Finally, to compare the
classification performance for the in-sample and out-of-sample
predictions, the precision (the proportion of positive predictions
that agree with those found in the data) and recall (the proportion of
positives in the data that were correctly predicted) were
calculated. A precision of 1 indicates the model had no false
positives. A recall of 1 indicates the model had no false negatives
[@googleml].

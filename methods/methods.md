# Methods
<!--
*Most of these are in the introduction.* 
Explanation and presentation of model structure
Presentation of alternative models
Occupancy and how covariates are modeled when deriving probability of detection
Binomial
Beta-binomial
Negative binomial
Logistic regression
Explanation of model comparison process and performance criteria
Diagnostics
Inferences
Probability of detection
Effect sizes
-->
## Simulation 

To demonstrate the strength and utility of the `artemis` package for
modeling eDNA data, we compare `artemis` models to standard
mixed-effects analysis.  We simulated one hundred datasets using the
generative process outlined previously [Modeling eDNA](#mod_str).  Then, we used two
different eDNA modeling approaches, a linear mixed-effects model and
`artemis`'s censored-data mixed-effects model to attempt to estimate
the original parameters used to simulated the data. 

For this task, only models which directly estimate effects on the
latent or backtransformed ln[eDNA] values were compared. To further
make the results more directly comparible, the mixed-effects model was
fit using the `rstanarm` R package(v2.21.1, @rstanarm), a Bayesian modeling package. The
`rstanarm` and `artemis` packages both use the Stan probabilistic
programming language to estimate parameters [@stan]. Furthermore, many of the
defaults in `artemis` functions mirror those in `rstanarm` , which in
turn mirror those of the `(g)lm` [@R] and `(g)lmer` [@lme4] functions. For the
purposes of this demonstration, we simulated an experiment with two
different filtered volumes, 50 and 100mL, and ten different distances
from eDNA emission source spread equidistant from 0 to 1000
m. Additionally, we simulated three filters per measurement and three
technical replicates per filter. All simulation was done in R, and the
code can be found at
[https://github.com/fishsciences/artemis_methods](https://github.com/fishsciences/artemis_methods).
Note that while `artemis` contains similar functions to simulate data,
we opted to replicate the data outside of `artemis`'s functions for
transparency. We also demonstrate the performance of `artemis` versus standard linear
 models using real-world data.

## Experimental Data

 <!-- From help file for datasets -->
 The data used were the qPCR results of two Delta Smelt live car experiments conducted in the
 primary channel of the Central Valley Project.  The experiments were completed on
 2017-08-02, part of a series of 6 experiments total completed at the
 CVP with dead Delta Smelt in August-September of 2017.  The two
 experiments were identical in design and execution.  100 dead Delta
 Smelt were placed in a car and suspended from the primary
 louvers. From distances of 10-50m, 3 replicate filters were taken
 every 10m at 50mL and 200mL, sampled from near to far relative to
 the car.  Note that the car itself (Distance_m = ~0) was not
 actually sampled. Each filter was extracted and analyzed three times with qPCR (three technical replications). The qPCR data from these experiments is plotted in Figure X.


To compare the performance of these models, two different methods were
used. First, the Pareto-Smoothed Leave-one-out Information Criteria
was calculated for each model using the `loo` package in R
[@loo]. This metric assesses a model's performance predicting
out-of-sample data, which gives a measure of how will the model
performs relative to the risk of overfitting to the data. Next, each
model was used to predict the expected response values for a 
second dataset collected in the same system. This gives a real world
example of prediction error for each model.

<!-- Unsure about this - might need clarification --> 

To broaden the comparisons to other models used to analyze eDNA data,
we compared the classification performance between binomial models.
First we fit a binomial mixed-effects model to the same dataset as
above. The response was "presence", a binary variable indicating
whether the Cq was lower than the detection threshold. The model was
fit similar to the linear models above using the `rstanarm` R package.
We then generated a predicted value (presence or absence) for each
observation in the in-sample dataset (the data used to estimate model
parameters) and the out-of-sample dataset (data not used to estimate
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

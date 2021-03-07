# Methods

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
transparancy. 

<!-- Unsure about this --> 
To broaden the comparisons
to other models used to analyze eDNA data, we conducted
cross-validation against the simulated data with a broader set of
models.  First each model was fit to a subset of the simulated
data. Then the model fit was used to produce predictions for the
withheld observations. For models where the response is a binary
variable (e.g. "detection"), the predictions from continuous models
were converted into a binary variable for the comparison. For
continuous models, the mean prediction error was calculated. For
binary models, the precision (the proportion of positive predictions
actually correct) and recall (the proportion of actual positives
predicted correctly) were calculated. A precision of 1 indicates the
model had no false positives. A recall of 1 indicates the model had no
false negatives.


## Experimental Data

We also demonstrate the performance of `artemis` verse standard linear
 models using real-world data.  
 <!-- From help file for datasets -->
 qPCR results of Delta Smelt live car experiment conducted in the
 primary of the CVP.  The second of two experiments completed on
 2017-08-02, part of a series of 6 experiments total completed at the
 CVP with dead Delta Smelt in August-September of 2017.  This
 experiment was identical to the first (`cvp01`).  100 dead Delta
 Smelt were placed in a car and suspended from the primary
 louvers. From distances of 10-50m, 3 replicate filters were taken
 every 10m at 50mL and 200mL, sampled from near to far relative to
 live car.  Note that the live car itself (Distance_m = ~0) was not
 actually sampled.  Date: 2017-08-02 StdCrvID: ds-2018-09-27 Tech reps
 per filter: 3 Total filters: 30 Biomass (N): 100 Distance range (m):
 10-50 Volume values (mL): 50, 200

To compare the performance of these models, two different methods were
used. First, the Pareto-Smoothed Leave-one-out Information Criteria
was calculated for each model using the `loo` package in R
[@loo]. This metric assesses a model's performance predicting
out-of-sample data, which gives a measure of how will the model
performs relative to the risk of overfitting to the data. Next, each
model was used to predict the expected response values for a 
second dataset collected in the same system. This gives a real world
example of prediction error for each model.

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

To compare different eDNA modeling approaches, data were simulated and
then each candidate model was fit to those data. The data followed the
same generative process outlined in (section ref). For the purposes of
this demonstration, we simulated an experiment with two different
filtered volumes, 50 and 100mL, and ten different distances from
source spread equidistant from 0 to 1000 m. Additionally, we simulated
three filters per measurement and three technical replicates per
filter. The simulation was done in R, and the code can be found at
[https://github.com/fishsciences/artemis_methods](https://github.com/fishsciences/artemis_methods).

Since the parameters for the data generating process are known for the
simulated data, we can compare how accurately these parameters are
estimated and investigate any bias in the estimation. For this task,
only candidate models which directly estimate effects on the latent or
backtransformed ln[eDNA] values can be compared, namely `lme4`'s
`lmer()` verses `artemis`'s `eDNA_lmer()`.

To broaden the comparisons to other models used to analyze eDNA data,
we conducted cross-validation against the simulated data with a
broader set of models.  First each model was fit to a subset of the
simulated data. Then the model fit was used to produce predictions for
the withheld observations. For models where the response is a binary
variable (e.g. "detection"), the predictions from continuous models
were converted into a binary variable for the comparison. For
continuous models, the mean prediction error was calculated. For
binary models, the precision (the proportion of positive predictions
actually correct) and recall (the proportion of actual positives
predicted correctly) were calculated. A precision of 1 indicates the
model had no false positives. A recall of 1 indicates the model had no
false negatives [@googleml].


## Experimental Data

Explanation of live car experiments and data used to fit the models

# Results

Model diagnostics and inferences from each model 

## Simulated data

Based on 500 simulated datasets, the standard linear mixed-effects
models produced biased estimates. The estimates for the four
generative parameters (Intercept, $\beta_{distance}$, $\beta_{volume}$,
and $\sigma$), were all skewed from the true values used to generate
the dataset. One effect of this bias was the 95% Credible Intervals
produced from the standard model did not include the true values in
14% of cases, higher than the expected rate.

By contrast, the estimates produced by the censored-data
mixed effects model in `artemis` were centered around the true
values for all four parameters. Additionally, the 95% credible
intervals included the true parameter values in all but 3.8% of cases, within
the expected range.

## Experimental data

When fit to the same experimental data, `artemis` models demonstrated
favorable characteristics compared to alternative models. While the
differences in parameter estimates were relatively small, the
predictive performance as measured by the Pareto-Smoothed
Leave-One-Out Information Criteria suggested the `artemis` models fit
the data <!--better?--> compared to widely-used
alternatives. Furthermore, when the parameter estimates for each model
were used to predict data for a second set of experimental data, the
`artemis` models had lower RMSE <!--@Matt what is RSME--> on the
predictions.

![Comparison of lmer vs eDNA_lmer to recover parameters from 500 simulated
datasets. Blue areas are the 95\% Credible Intervals, while black areas
are the median parameter estimates. The "true value" used in the
simulation is marked as a dashed line.](analysis/figs/coef_est_compare.png) <!-- this figure did not show up in @Von's pdf-->

In a comparison between `artemis` models and a binomial mixed-effects
model fit to the same data, the binomial data showed both better
precision and recall for the in-sample data, relative to the `artemis`
model (0.92 vs. 0.72 precision; 0.94 vs. 0.88 recall). However, when
used to classify out-of-sample data, the binomial model's performance
showed similar results to the `artemis` predictions in precision (0.57
vs 0.56 precision), but worse recall (0.69 vs 0.77 recall). This
suggests that the binomial data was overfit to the original
data. Futhermore, the binomial model would produce more false
negatives compared to the `artemis` classification predicting the same
data.

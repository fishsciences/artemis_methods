# Results

Model diagnostics and inferences from each model 

## Simulated data

Based on 500 simulated datasets, the standard linear mixed-effects
models produced biased estimates. The estimates for the four
generative parameters (Intercept, $\beta_{distance}$, $\beta{volume},
and $\sigma$), were all skewed from the true values used to generate
the dataset. One effect of this bias was the 95% Credible Intervals
produced from the standard model did not include the true values in
14% of cases, higher than the expected rate.

By contrast, the estiamtes produced by the censored-data
mixed effects model in `artemis` were centered around the true
values for all four parameters. Additionally, the 95% credible
intervals included the true parameter values in 3.8% of cases, within
the expected range.

## Experimental data

When fit to the same experimental data, `artemis` models demonstrated
favorable characteristics compared to their traditional
counterparts. While the differences in parameter estimates were
relatively small, the predictive preformance as measured by the
Pareto-Smoothed Leave-One-Out Information Criteria suggested the
`artemis` models fit the data compared to the traditional
alternative. Furthermore, when the parameter estimates for each model
were used to predict data for a second set of experimental data, the
`artemis` models had lower RMSE on the predictions.

![Comparison of lmer vs eDNA_lmer to recover parameters from 500 simulated
datasets. Blue areas are the 95\% Credible Intervals, while black areas
are the median parameter estimates. The "true value" used in the
simulation is marked as a dashed line.](analysis/figs/coef_est_compare.png)

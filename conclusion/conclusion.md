# Conclusion

The need for non-invasive, cost-effective sampling, especially for
low-density, cryptic, or difficult-to-sample populations, is growing and
will continue to drive development of molecular-based methods
[@adams_beyond_2019].  This need also includes effective
early-detection for invasive species [@miliangarcia_optimization_2021;
@sepulveda_adding_2019]. As monitoring programs continue to adopt eDNA methods
more broadly, there is an accompanying demand for robust, reliable, open-source
analysis and modeling tools.

To address many of the issues that arise when analyzing data from qPCR 
analysis using standard statistical methods, we developed the `artemis` R package,
which includes many utility and convenience functions in support of eDNA research and analysis. Importantly, the `artemis` package provides drop-in replacements for linear modeling functions in R. It does this with latent variable models that are customized to the data generating process inherent to qPCR data derived from eDNA samples. These models show less bias and more predictive accuracy for censored qPCR data when compared to standard linear models.

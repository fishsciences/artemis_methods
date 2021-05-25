## Estimating [eDNA] via qPCR

In eDNA samples that undergo fluorescence-based quantitative real-time PCR, the amount of eDNA present in the sample is estimated
from the number of quantification cycles of qPCR (hereafter the “Cq”
value) completed before amplification takes place during qPCR. By this process, the
concentration of eDNA is not directly measured. The relationship
between eDNA concentration ([eDNA]) and Cq values is determined via a
standard curve generated in the lab from the assay for the target species.  The
standard curve is specific to the lab reagents and techniques
used. This standard curve formula typically takes the form:

\begin{equation}
 Cq = \beta * ln([eDNA]) + \alpha 
\end{equation}

Where $\alpha$ is the intercept and
$\beta$ is the slope for the standard curve equation and $ln([eDNA])$ is the natural logarithmic concentration of eDNA (ln[eDNA]). These
coefficients are determined in the lab during the calibration process. 
A higher Cq value, i.e. more quantification cycles, corresponds to a
lower concentration of eDNA in a sample. Above a pre-determined
threshold, additional quantification cycles are not
attempted. Although this threshold would ideally correspond to when
the [eDNA] concentration is zero, the threshold for Cq values typically
corresponds to a non-zero eDNA concentration.  Since “non-detection”
is taken to be any sample which requires more than the threshold
number of cycles to detect, a data censoring process
occurs. Crucially, because the Cq values are dependent on the
standard curve and hence the specifics of a particular lab, the censoring
point is also lab dependent. 

This censoring process can create several issues for analyzing qPCR data from eDNA
samples. The most concerning issue is that failure to take the data censoring process
into account may lead to biases in model estimates and 
invalid confidence or credible intervals. Additionally, when there is
a large amount of data clustered at the censoring point, the
estimated measurement error will be artificially low. This would in turn give rise to
unrealistic expectations for the results of planned sampling efforts, and/or biased predictions.  

To mitigate these issues in the analysis of our own eDNA data, we developed the `artemis` package for the R programming environment. In
`artemis`, we implement a set of models to directly estimate the effect of
 predictors on the latent (unobserved) response variable, ln[eDNA] . This is
accomplished by linking ln[eDNA] to the observed response variable (Cq) via the
standard curve parameters.  Our objects here are to introduce the
censored latent variable models in the `artemis` R package, and to
demonstrate how the `artemis` R package can be used in the analysis of qPCR data from eDNA samples.
We compare the performance of `artemis` to several other commonly-used
modeling approaches in eDNA research and discuss the benefits and
trade-offs for each.


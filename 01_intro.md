# Introduction

qPCR data from eDNA studies are often modeled via occupancy models
(Schmidt et al 2013) or some form of binomial regression (Moyer et
al. 2014; Song et al. 2017; Hinlo et al. 2017).  These are both
suitable, but there are several characteristics of eDNA data which
made us feel that it would benefit from a different modeling approach.

In eDNA samples, the amount of eDNA present is represented as a
function of the number of quantification cycles of qPCR (hereafter
referred to as the “Cq” value) completed before amplification takes
place during qPCR. The eDNA concentration ([eDNA]) is then related to
Cq via a standard curve generated in the lab for the target
species. This standard curve formula typically takes the form:

The standard curve is specific to the lab reagents and techniques
used. The implication of this is that models using Cq values (or a
derived value such as “positive detection”) as the response result in
estimates of effect sizes which cannot be directly compared between
different studies using different standard curves.  A higher Cq value
corresponds to a lower concentration of eDNA in a sample. Above a
pre-determined threshold, additional quantification cycles are not
attempted. Therefore, “non-detection” is taken to be any sample which
requires more than the threshold number of cycles to detect. Not
taking this data truncation process into account in the model can
result in increased uncertainty and bias in our estimates of the
effect sizes.  The potential sources of measurement error in the
extraction and qPCR processes are difficult to separate and
quantify. For example, Cq values produced by qPCR become more variable
at the threshold of detection, i.e. as the number of eDNA molecules
available for amplification approaches zero. This source of
variability in the response is different from that produced by error
introduced in the pipetting process during extraction, but they have
the same effect on Cq (namely, increasing variability).  We addressed
these issues by directly modeling the effect of the predictors on the
latent (unobserved) variable, eDNA concentration. This is accomplished
by linking eDNA concentration to the observed response via the
standard curve parameters.  The goal of this paper is to introduce
this truncated latent variable model in the analysis of eDNA data, and
to compare its performance to several other commonly-used modeling
approaches in the field: occupancy modeling for deriving the
probability of detection, and binomial regression (beta-binomial,
negative binomial, and logistic regression).

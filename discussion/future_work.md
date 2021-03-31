## Future Work

Although `artemis` was designed to model ln[eDNA] values as the latent
response, the functions are sufficiently general to allow other
response variables as well. For example, copy number can easily be
used, so long as the correct standard curve parameters are
provided for the conversion from Cq to copy number. However, the
functions have not been extensively tested on copy number, and there
might be some aspects of copy number as a latent response variable
which require a different model parameterization. More testing is
needed. 

It has been observed that qPCR results in more variable measurements
as concentrations of eDNA decrease. During the Beta development
stage, we implemented a basic parameterization to allow for this in
the model. This initial attempt was based on normally distributed
errors which increase as concentrations decrease. However, the errors
appear to be more likely Poisson distributed (citation). Initial
testing reveals some issues with using normally distributed errors.
Further work is needed to evaluate and implement the most robust
method to model the mechanisms involved.

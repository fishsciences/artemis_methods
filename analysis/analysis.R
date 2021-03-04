# Analysis script for the artemis methods paper

library(elaphos)
library(artemis)
library(rstanarm)
library(loo)

# Set once here so we can easily swap the experiment here
d = cvp02

#------------------------------------------------------------------------------#
# single experiment 

# Need standard curve
i = match(d$StdCrvID, StdCrvKey$StdCrvID)
a = StdCrvKey$StdCrvAlpha_lnForm[i]
b = StdCrvKey$StdCrvBeta_lnForm[i]

mod_art = eDNA_lm(Cq ~ Distance_m + Volume_mL,
                  data = d,
                  std_curve_alpha = a,
                  std_curve_beta = b)

# Manual back-conversion to log[eDNA]
# a + b * x = y
# (y - a) / b
d$ln_eDNA = (d$Cq - a) / b

mod_lm = stan_glm(ln_eDNA  ~ Distance_m + Volume_mL,
                data = d, family = "gaussian")

# comparison: prediction - errors
loo_art = artemis::loo(mod_art)
loo_lm = loo(mod_lm)

loo_compare(loo_art, loo_lm)

#------------------------------------------------------------------------------#
# random effects


mod_arter = eDNA_lmer(Cq ~ Distance_m + Volume_mL + (1|FilterID),
                  data = d,
                  std_curve_alpha = a,
                  std_curve_beta = b)

mod_lmer = stan_glmer(ln_eDNA  ~ Distance_m + Volume_mL + (1|FilterID),
                data = d, family = "gaussian")

# comparison: prediction - errors
loo_arter = artemis::loo(mod_arter)
loo_lmer = loo(mod_lmer)

loo_compare(art = loo_art, art_lmer = loo_arter, loo_lm, loo_lmer)

#------------------------------------------------------------------------------#
# Out of sample predictions

# Analysis script for the artemis methods paper

library(elaphos)
library(artemis)
library(rstanarm)

mod_binom = stan_glm(I(Cq < 40) ~ Distance_m + Volume_mL,
                data = cvp02, family = "binomial")

mod_norm = lm(Cq ~ Distance_m + Volume_mL, cvp02)

mod_art = eDNA_lm(Cq ~ Distance_m + Volume_mL, cvp02, 21, -1.5)


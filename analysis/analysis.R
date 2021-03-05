# Analysis script for the artemis methods paper

library(elaphos)
library(artemis)
library(rstanarm)
library(loo)

# Set once here so we can easily swap the experiment here
d = rbind(cvp01, cvp02)

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

saveRDS(mod_arter, file = "output/artemis_lmer_fit.rds")

mod_lmer = stan_glmer(ln_eDNA  ~ Distance_m + Volume_mL + (1|FilterID),
                data = d, family = "gaussian")

saveRDS(mod_lmer, file = "output/rstanarm_lmer_fit.rds")

# comparison: prediction - errors
loo_arter = artemis::loo(mod_arter)
loo_lmer = loo(mod_lmer, cores = 4)

comp = loo_compare(art = loo_art, art_lmer = loo_arter, loo_lm, loo_lmer)

saveRDS(comp, file = "output/compare_loo.rds")

#------------------------------------------------------------------------------#
# Out of sample predictions - not sure if this makes sense
d2 = cvp04
i = match(d2$StdCrvID, StdCrvKey$StdCrvID)
a2 = StdCrvKey$StdCrvAlpha_lnForm[i]
b2 = StdCrvKey$StdCrvBeta_lnForm[i]

d2$ln_eDNA = (d2$Cq - a2) / b2

lmer_pred = posterior_predict(mod_lmer, newdata = d2)
lmer_ln_eDNA = apply(lmer_pred, 2, mean)
lmer_Cq = lmer_ln_eDNA * b2 + a2
lmer_Cq[lmer_Cq > 40] = 40

# TODO: Fix artemis predict
art_pred = predict(mod_arter, newdata = d2[,c("Distance_m", "Volume_mL")])

art_ln_eDNA = apply(art_pred$ln_conc, 1, mean)
art_Cq = apply(art_pred$Cq_hat, 1, mean)
art_Cq[art_Cq > 40] = 40

par(mfrow = c(1, 2))
plot(d2$Cq, lmer_Cq, xlim = c(30, 40), ylim = c(30,40))
abline(0,1, lty = 2, col = "red")
abline(lm(d2$Cq ~ lmer_Cq))

plot(d2$Cq, art_Cq, xlim = c(30, 40), ylim = c(30,40))
abline(0,1, lty = 2, col = "red")
abline(lm(d2$Cq ~ art_Cq))

sqrt(mean((d2$Cq - lmer_Cq) ^ 2))
sqrt(mean((d2$Cq - art_Cq) ^ 2))

#### ln eDNA ####
plot(d2$ln_eDNA, lmer_ln_eDNA)
abline(0,1, lty = 2)
abline(lm(d2$ln_eDNA ~ lmer_ln_eDNA))
plot(d2$ln_eDNA, art_ln_eDNA)
abline(0,1, lty = 2)
abline(lm(d2$ln_eDNA ~ art_ln_eDNA))

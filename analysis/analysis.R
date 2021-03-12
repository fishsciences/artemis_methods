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

<<<<<<< HEAD
#------------------------------------------------------------------------------#
# compare binomial predictions
d$presence = as.integer(d$Cq < 40)
binom_mod = stan_glmer(ln_eDNA  ~ Distance_m + Volume_mL + (1|FilterID),
                       data = d, family = "gaussian")
=======
# Binomial comparison:

d$presence = as.integer(d$Cq < 40)

mod_binom = stan_glmer(presence  ~ Distance_m + Volume_mL + (1|FilterID),
                       data = d, family = "binomial")

binom_pp = posterior_predict(mod_binom)

# prediction more than 50% cases
pred_pres = colSums(binom_pp) / nrow(binom_pp) > 0.50
pred_pres

recall_prec = function(pred, obs)
    {
        true_pos = sum(obs & pred)
        tot_pos = sum(pred)
        false_neg = sum(obs & !pred)

        return(c(
            precision_binom = true_pos / tot_pos,
            recall_binom = true_pos / (true_pos + false_neg)))
}
## artemis - lmer predictions

art_pp = predict(mod_arter)
art_pres = (rowMeans(art_pp$Cq_hat) < 40)


## out of sample
d2$presence = d2$Cq < 40
pred_oos_binom = posterior_predict(mod_binom, newdata = d2)
pred_pres_oos = colSums(pred_oos_binom) / nrow(pred_oos_binom) > 0.50
pred_pres_oos

art_pp_oos = predict(mod_arter, newdata = d2[,c("Distance_m", "Volume_mL")])
art_pres_oos = (rowMeans(art_pp_oos$Cq_hat) < 40)

binom_comparision = data.frame(
    binomial_in_sample = recall_prec(pred_pres, d$presence),
    artemis_in_sample = recall_prec(art_pres, d$presence),
    binomial_out_sample = recall_prec(pred_pres_oos, d2$presence),
    artmis_out_sample = recall_prec(art_pres_oos, d2$presence))
saveRDS(t(binom_comparision), file = "output/binom_compare.rds")
>>>>>>> 97729843a31ebf7a1f31f082cc2f4d18b3ee64c9

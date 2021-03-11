# Cross-validation to compare models
# with presence-absence as response

library(artemis)
library(rstanarm)
options(mc.cores = parallel::detectCores()/2) # only use half cores

source("funs.R")
#------------------------------------------------------------------------------#
# replicated estimates
# make N datasets
set.seed(1234)
n_sim = 200
sim_datasets = replicate(n_sim, rep_dataset(), simplify = FALSE)

# add presence col
sim_datasets = lapply(sim_datasets, function(df) {
    df$presence = as.integer(df$Cq < 40)
    df
})


out_of_sample_glmer = function(d1, d2)
{
    fit = stan_glmer(presence ~ volume_mL + dist_km + (1|filterID), d1, family = "binomial")
    pp = posterior_predict(fit, newdata = d2)
    
    ff = colSums(pp)/ nrow(pp) > .5
    true_pos = sum(ff == 1 & d2$presence == 1)
    false_neg = sum(ff == 0 & d2$presence == 1)
    tot_pos = sum(ff)
    c(precision =  true_pos / tot_pos,
      recall = true_pos / (true_pos + false_neg))
}

out_of_sample_artemis = function(d1, d2)
{
    fit = eDNA_lmer(Cq ~ volume_mL + dist_km + (1|filterID), d1,
                    std_curve_alpha = 21.5, std_curve_beta = -1.5)
    # browser()
    pp = predict(fit, newdata = d2[,c("volume_mL", "dist_km")])
    ff = apply(pp$Cq_hat, 1, function(x) sum(x<40)/ length(x)) > .5
    true_pos = sum(ff == 1 & d2$presence == 1)
    false_neg = sum(ff == 0 & d2$presence == 1)
    tot_pos = sum(ff)
    c(precision =  true_pos / tot_pos,
      recall = true_pos / (true_pos + false_neg))
}

ans = mapply(out_of_sample_artemis, d1 = sim_datasets[1:250], d2 = sim_datasets[251:500])
saveRDS(ans, file = "binom_oos.rds")
ans2 = mapply(out_of_sample_artemis, d1 = sim_datasets[1:250], d2 = sim_datasets[251:500])
saveRDS(ans2, file = "artemis_oos.rds")

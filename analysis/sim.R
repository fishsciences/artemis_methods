# Simulation and fitting of models
library(ggplot2)
library(artemis)
library(rstanarm)
options(mc.cores = parallel::detectCores()/2) # only use half cores
# basic simulation of ln[eDNA]
# Using the generative model in the manuscript

# Set to TRUE to re-run the simulations
# the artemis fits take a while to complete
run_sims = FALSE

#------------------------------------------------------------------------------#
# functions
source("funs.R")
#------------------------------------------------------------------------------#
# replicated estimates
# make N datasets
if(run_sims){
set.seed(1234)
n_sim = 500
sim_datasets = replicate(n_sim, rep_dataset(), simplify = FALSE)


lmer_ests = lapply(sim_datasets, fit_and_extract, fun = stan_glmer,
                   model_formula = ln_eDNA_backtransform ~ dist_km + volume_mL + (1|filterID),
                   extract_fun = summary_stan)
## lmer_ests = do.call(rbind, lmer_ests)
saveRDS(lmer_ests, file = "lmer_sim_results.rds")

arter_ests = lapply(sim_datasets, fit_and_extract, fun = eDNA_lmer, std_curve_alpha = 21.5, std_curve_beta = -1.5,
                    extract_fun = summary_artemis)
## arter_ests = do.call(rbind, arter_ests)
saveRDS(arter_ests, file = "art_sim_results.rds")
 }



#------------------------------------------------------------------------------#

# Old Stuff
if(FALSE){
#----------------------------------------#
# fit models to simulated data
library(artemis)
library(lme4)

# lm models - ignore random effects
mod_lm = lm(Cq ~ dist_km + volume_mL, d)
mod_lm2 = lm(ln_eDNA_backtransform ~ dist_km + volume_mL, d)

mod_art = eDNA_lm(Cq ~ dist_km + volume_mL, d,
        std_curve_alpha = std_alpha,
        std_curve_beta=std_beta, upper_Cq = upper_Cq)

mod_lmer = lmer(Cq ~ dist_km + volume_mL + (1|filterID), d)
mod_lmer2 = lmer(ln_eDNA_backtransform ~ dist_km + volume_mL + (1|filterID), d)

mod_arter = eDNA_lmer(Cq ~ dist_km + volume_mL+ (1|filterID), d,
        std_curve_alpha = std_alpha,
        std_curve_beta=std_beta, upper_Cq = upper_Cq)


summary(mod_lmer2)
summary(mod_arter)
}

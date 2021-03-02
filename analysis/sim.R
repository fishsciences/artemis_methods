# Simulation and fitting of models
library(ggplot2)
# basic simulation of ln[eDNA]
# Using the generative model in the manuscript

set.seed(123)
# constants
intercept = -12
ln_sd = 1.5
beta_dist = -4
beta_vol = 0.05
distance_km = seq(0,1, length.out = 10)
volume_mL = c(50,100)
filterID = 1:3
tech_reps = 1:3
std_alpha = 21.5
std_beta = -1.5
upper_Cq = 40
filter_u = rnorm(length(filterID), 0, 1) # random effect on filter

d = expand.grid(dist_km = distance_km,
                filterID = filterID,
                tech_rep = tech_reps,
                volume_mL = volume_mL)

d$ln_eDNA_hat = intercept +
    beta_dist * d$dist_km +
    beta_vol * d$volume_mL +
    filter_u[d$filterID]

d$ln_eDNA = rnorm(nrow(d), d$ln_eDNA_hat, ln_sd)
d$Cq = d$ln_eDNA * std_beta + std_alpha
d$Cq[d$Cq > upper_Cq] = upper_Cq
d$ln_eDNA_backtransform = (d$Cq - std_alpha) / std_beta
summary(d)

plot(Cq ~ dist_km, d)

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

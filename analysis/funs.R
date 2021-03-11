
rep_dataset = function(# constants
                       intercept = -12,
                       ln_sd = 1.5,
                       beta_dist = -4,
                       beta_vol = 0.05,
                       distance_km = seq(0,1, length.out = 10),
                       volume_mL = c(50,100),
                       filterID = 1:3,
                       tech_reps = 1:3,
                       std_alpha = 21.5,
                       std_beta = -1.5,
                       upper_Cq = 40,
                       filter_u = rnorm(length(filterID), 0, 1), # random effect on filter

                       d = expand.grid(dist_km = distance_km,
                                       filterID = filterID,
                                       tech_rep = tech_reps,
                                       volume_mL = volume_mL))
{
    d$ln_eDNA_hat = intercept +
        beta_dist * d$dist_km +
        beta_vol * d$volume_mL +
        filter_u[d$filterID]
    
    d$ln_eDNA = rnorm(nrow(d), d$ln_eDNA_hat, ln_sd)
    d$Cq = d$ln_eDNA * std_beta + std_alpha
    d$Cq[d$Cq > upper_Cq] = upper_Cq
    d$ln_eDNA_backtransform = (d$Cq - std_alpha) / std_beta
    d
}

fit_and_extract = function(data = rep_dataset(),
                           fun = lmer,
                           extract_fun = fixef,
                           model_formula = Cq ~ dist_km + volume_mL + (1|filterID),
                           ...)
{
    mod = fun(model_formula, data, ...)
    extract_fun(mod)
}

# add to artemis 
fixef.eDNA_model = function(object, ...){
    tmp = summary(object, ...)
    structure(tmp$Mean, names = rownames(tmp))
}

summary_stan = function(x, p = c(0.05,0.5, 0.95),
                        r = c(1:3, 7),
                        c= 4:6)
{
    summary(x, probs = p)[r, c]
}

summary_artemis = function(x, p = c(0.05,0.5,0.95),
                           c = 2:4)
{
    summary(x, probs = p)[,2:4]
}


out_of_sample = function(df1, df2, model, pred_fun, ...)
{
    fit = model(...)
    d = pred_fun(fit, df2)

}

s = x^1500

.3 = x^1500

   

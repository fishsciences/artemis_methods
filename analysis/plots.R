library(ggplot2)
library(gridExtra)

source("plot_funs.R")
# plots
lmer_ests = readRDS("output/lmer_sim_results.rds")
arter_ests = readRDS("output/art_sim_results.rds")

true_vals = c(-12, -4, 0.05, 1.5)
coef_list_lmer = lapply(1:4, function(i)
    do.call(rbind, lapply(lmer_ests, "[", i, 1:3)))
coef_list_art = lapply(1:4, function(i)
    do.call(rbind, lapply(arter_ests, "[", i, 1:3)))


aa = mapply(mk_coef_plot, coef_list_lmer, coef_list_art, true_vals, rownames(lmer_ests[[1]]), SIMPLIFY = FALSE)

png("figs/coef_est_compare.png", 8, 5, "in", res = 300)
marrangeGrob(aa, nrow = 2, ncol = 2)
dev.off()

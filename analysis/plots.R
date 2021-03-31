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

# Raw data plot - Fig 1
d = rbind(elaphos::cvp01, elaphos::cvp02)

ggplot(d, aes(x = Distance_m, y = Cq)) +
  geom_jitter(aes(color = factor(Volume_mL)), 
              width = 0.75,
              shape = 1,
              size = 1.5,
              stroke = 0.75) +
  fishpals::scale_color_fishpals("greensunfish", discrete = TRUE) +
  theme_minimal() +
  guides(color = guide_legend(title = "Filtered Volume (mL)")) +
  theme(legend.direction = "horizontal",
        legend.position = "top")

png("figs/experimental_raw_data.png", 8, 5, "in", res = 300)
dev.off()

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
library(elaphos)
d = rbind(elaphos::cvp01, elaphos::cvp02)
# Need standard curve
i = match(d$StdCrvID, StdCrvKey$StdCrvID)
a = StdCrvKey$StdCrvAlpha_lnForm[i]
b = StdCrvKey$StdCrvBeta_lnForm[i]

d$ln_eDNA = artemis::cq_to_lnconc(d$Cq, a, b)

v40 = artemis::cq_to_lnconc(40.0, unique(a), unique(b))


png("figs/experimental_raw_data.png", 8, 5, "in", res = 300)

ggplot(d, aes(x = factor(Distance_m), y = ln_eDNA)) +
  geom_jitter(
    size = 1,
    alpha = 0.5,
    shape = 1,
    aes(color = factor(Volume_mL)),
    position = position_jitterdodge(jitter.width = 0.05, 
                                    dodge.width = 0.55
                                    ),
    show.legend = FALSE
  ) +
  geom_boxplot(
     alpha = 0.25,
    aes(color = factor(Volume_mL),
        fill = factor(Volume_mL)),
    position = position_dodge(width = 0.5),
    width = 0.25,
    size = 0.4,
    outlier.shape = NA
  ) +
  geom_hline(aes(yintercept = v40), lty = 2, size = 0.45) +
  scale_color_manual(values = c("gray45", "gray10")) +
  scale_fill_manual(values = c("gray45", "gray10")) +

  theme_minimal() +
  theme(legend.position = "bottom") +
  labs(x = "Distance (m) from live car",
       y = "ln[eDNA]") +
  guides(color = guide_legend(title = "Filtered volume (mL)"),
         fill = guide_legend(title = "Filtered volume (mL)"))

dev.off()

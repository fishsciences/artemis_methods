# Figure 1 - CVP experiments

library(elaphos)
library(ggplot2)
library(fishpals)

d = rbind(cvp01, cvp02)
# Need standard curve
i = match(d$StdCrvID, StdCrvKey$StdCrvID)
a = StdCrvKey$StdCrvAlpha_lnForm[i]
b = StdCrvKey$StdCrvBeta_lnForm[i]

d$ln_eDNA = artemis::cq_to_lnconc(d$Cq, a, b)

v40 = artemis::cq_to_lnconc(40.0, unique(a), unique(b))

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

  theme_report(inner_border = FALSE) +
  theme(legend.position = "bottom") +
  labs(x = "Distance (m) from live car",
       y = "ln[eDNA]") +
  guides(color = guide_legend(title = "Filtered volume (mL)"),
         fill = guide_legend(title = "Filtered volume (mL)"))

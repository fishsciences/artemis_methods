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

ggplot(d, aes(x = Distance_m, y = Cq)) +
  geom_jitter(
    width = 0.25,
    size = 1.2,
    alpha = 0.5,
    aes(color = Species),
    show.legend = FALSE
  ) +
  geom_boxplot(
    alpha = 0.5,
    aes(group = Distance_m),
    width = 1.1,
    size = 0.48,
    outlier.shape = NA
  ) +
  scale_color_fishpals() +
  theme_report(inner_border = FALSE)

table(d$TechRep)

v40 = artemis::cq_to_lnconc(40.0, unique(a), unique(b))

ggplot(d, aes(x = Distance_m, y = ln_eDNA)) +
  geom_jitter(
    width = 0.25,
    size = 1.2,
    alpha = 0.5,
    aes(color = Species),
    show.legend = FALSE
  ) +
  geom_boxplot(
    alpha = 0.5,
    aes(group = Distance_m),
    width = 1.1,
    size = 0.48,
    outlier.shape = NA
  ) +
  geom_hline(aes(yintercept = v40), lty = 2, size = 0.45) +
  scale_color_fishpals() +
  theme_report(inner_border = FALSE)

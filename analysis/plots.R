# plots
lmer_ests = readRDS("lmer_sim_results.rds")
arter_ests = readRDS("art_sim_results.rds")

lmer_sum = apply(lmer_ests, 2, function(x) c(mean = mean(x), quantile(x, probs =c(0.05, 0.95))))
art_sum = apply(arter_ests, 2, function(x) c(mean = mean(x), quantile(x, probs =c(0.05, 0.95))))

# ugly, fragile - fix later
plot_data = data.frame(
    med = c(lmer_sum[1,], art_sum[1,-4], c(-12, -4, 0.05)),
    lwr = c(lmer_sum[2,], art_sum[2,-4], rep(NA, 3)),
    upr = c(lmer_sum[3,], art_sum[3,-4], rep(NA, 3)),
    var = colnames(lmer_sum),
    model = rep(c("lmer", "eDNA_lmer", "True values"), each = 3))
plot_data = plot_data[order(plot_data$var),]

png(filename = "comp.png", width = 5, height=7, units = "in", res = 300)
par(mfrow = c(3,1))
by(plot_data, plot_data$var, function(df){
    
    i = df$model != "True values"
    dotchart(df$med[i], labels = df$model[i],
             xlim = c(min(df$lwr[i]), max(df$upr[i])),
             main = unique(df$var[i]))
    abline(v = df$med[!i], lty = 2)
    segments(x0 = df$lwr[i], x1 = df$upr[i], y0 = 1:2)
})
dev.off()

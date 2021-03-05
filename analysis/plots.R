library(ggplot2)
library(gridExtra)

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

true_vals = c(-12, -4, 0.05, 1.5)
coef_list_lmer = lapply(1:4, function(i)
    do.call(rbind, lapply(lmer_ests, "[", i, 1:3)))
coef_list_art = lapply(1:4, function(i)
    do.call(rbind, lapply(arter_ests, "[", i, 1:3)))

mk_coef_plot = function(coef_df, coef_df2, true_val, main,
                        lwr_ci1 = coef_df[,1],
                        upr_ci1 = coef_df[,3],
                        med1 = coef_df[,2],
                        lwr_ci2 = coef_df2[,1],
                        upr_ci2 = coef_df2[,3],
                        med2 = coef_df2[,2],
                        models = c("lmer", "eDNA_lmer"))
    {
        ggplot() + geom_segment(aes(x = lwr_ci1, xend = upr_ci1,
                                    y = factor(1), yend = 1),
                                alpha = 0.1, size = 1, color = "blue") +
            geom_point(aes(x = med1, y = 1), size = 3, alpha = 0.1) +
            geom_segment(aes(x = lwr_ci2, xend = upr_ci2,
                             y = factor(2), yend = 2),
                         alpha = 0.1, size = 1, color = "blue") +
            geom_point(aes(x = med2, y = 2), size = 3, alpha = 0.1) +
            theme_bw() +
            geom_vline(xintercept = true_val, linetype = "dashed") +
            xlab("Coefficient estimate") +
            ylab("Model") +
            scale_y_discrete(breaks = 1:2, labels = models) +
            ggtitle(main)
    }

par(mfrow = c(2,2))
aa = mapply(mk_coef_plot, coef_list_lmer, coef_list_art, true_vals, rownames(lmer_ests[[1]]), SIMPLIFY = FALSE)

marrangeGrob(aa, nrow = 2, ncol = 2)
#ggsave("coef_comparison.png")

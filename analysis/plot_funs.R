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

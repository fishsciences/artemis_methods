SIM_RESULTS = output/lmer_sim_results.rds output/art_sim_results.rds
MODEL_FITS = output/rstanarm_lmer_fit.rds output/artemis_lmer_fit.rds
MODEL_LOO = output/compare_loo.rds
FIGS = figs/coef_est_compare.png
TABS = tables/
RSCRIPT = Rscript $<

all: $(FIGS) $(TABS)

$(MODEL_FITS) $(MODEL_LOO) &: analysis.R
	$(RSCRIPT)

$(FIGS) &: plots.R plot_funs.R
	$(RSCIPT)

$(TABS) &: tables.R
	$(RSCRIPT)

SIM_RESULTS = output/lmer_sim_results.rds output/art_sim_results.rds
MODEL_FITS = output/rstanarm_lmer_fit.rds output/artemis_lmer_fit.rds
MODEL_LOO = output/compare_loo.rds
FIGS = figs/coef_est_compare.png
TABS = tables.md
RSCRIPT = Rscript $<
KNIT = Rscript -e "knitr::knit('$<')"

all: $(FIGS) $(TABS)

$(SIM_RESULTS) &: sim.R | output
	$(RSCRIPT)

$(MODEL_FITS) $(MODEL_LOO) &: analysis.R | output
	$(RSCRIPT)

$(FIGS) &: plots.R plot_funs.R $(SIM_RESULTS) $(MODEL_FITS) | figs
	$(RSCIPT)

$(TABS) &: tables.Rmd $(SIM_RESULTS) $(MODEL_FITS) $(MODEL_LOO) | output
	$(KNIT)

clean:
	rm -rf output/* tables.md

output:
	mkdir output
figs:
	mkdir figs

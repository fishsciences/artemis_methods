PANDOC = /usr/bin/pandoc
LUA_FILTERS = $(HOME)/lua-filters/filters
INTRO = intro/intro.md intro/estimating_eDNA.md intro/modeling_eDNA.md intro/package_desc.md
METHODS = methods/methods.md
DISCUSSION = discussion/discussion.md discussion/future_work.md
TABS = analysis/tables.md
FIGS = figure_caps.md
SECTIONS=abstract.md $(INTRO) $(METHODS) results/results.md  $(DISCUSSION) conclusion/conclusion.md $(TABS) $(FIGS)
# FIGS = analysis/figs/coef_est_compare.png analysis/figs/experimental_raw_data.png
FORMAT=format.yaml
BIB=artemis.bibtex
TABS_FIGS = analysis/tables.md 
SUBMISSION=artemis_pkg.pdf
MANUSCRIPT=artemis_methods.pdf
DOC=artemis_methods.docx
MD=artemis_methods.md

submission: $(SUBMISSION) title_page.pdf

$(MANUSCRIPT): $(SECTIONS) acknowledgements.md $(FORMAT) $(FIGS) $(BIB)
	pandoc --citeproc \
		--lua-filter=$(LUA_FILTERS)/scholarly-metadata.lua \
        --lua-filter=$(LUA_FILTERS)/author-info-blocks.lua \
        --verbose -s -o $@ $(SECTIONS) $(FORMAT)

$(SUBMISSION): $(SECTIONS) sub_format.yaml $(FIGS) $(BIB)
	pandoc --citeproc \
		--lua-filter=$(LUA_FILTERS)/scholarly-metadata.lua \
        --lua-filter=$(LUA_FILTERS)/author-info-blocks.lua \
        --verbose -s -o $@ $(SECTIONS) --metadata-file sub_format.yaml

title_page.pdf: title_page.md acknowledgements.md $(FORMAT)
	pandoc \
		--lua-filter=$(LUA_FILTERS)/scholarly-metadata.lua \
        --lua-filter=$(LUA_FILTERS)/author-info-blocks.lua \
		-o $@ title_page.md acknowledgements.md $(FORMAT)	

$(DOC): $(SECTIONS) $(FORMAT) $(FIGS) $(BIB)
	pandoc --citeproc --verbose -s -o $@ $(SECTIONS) $(FORMAT)

$(MD): $(SECTIONS) $(FORMAT) $(FIGS) $(BIB)
	pandoc --citeproc --verbose -s -o $@ $(SECTIONS) $(FORMAT)

test.md: $(SECTIONS) $(FORMAT) $(TABS_FIGS) $(BIB)
	pandoc --citeproc --verbose -s -o $@ $(SECTIONS) $(FORMAT)

all: $(MANUSCRIPT)

$(TABS_FIGS) &: analysis/tables.Rmd
	$(MAKE) -C analysis

clean:
	rm artemis_methods.pdf

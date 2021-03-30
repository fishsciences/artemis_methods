PANDOC = /usr/bin/pandoc
INTRO = intro/intro.md intro/estimating_eDNA.md intro/modeling_eDNA.md intro/package_desc.md
METHODS = methods/methods.md
DISCUSSION = discussion/discussion.md discussion/future_work.md
TABS = analysis/tables.md 
SECTIONS=abstract.md $(INTRO) $(METHODS) results/results.md  $(DISCUSSION) conclusion/conclusion.md $(TABS)
FIGS = analysis/figs/coef_est_compare.png
FORMAT=format.yaml
BIB=artemis.bibtex

MANUSCRIPT=artemis_methods.pdf
DOC=artemis_methods.docx
MD=artemis_methods.md

$(MANUSCRIPT): $(SECTIONS) $(FORMAT) $(FIGS) $(BIB)
	$(PANDOC) --citeproc --verbose -s -o $@ $(SECTIONS) $(FORMAT)

$(DOC): $(SECTIONS) $(FORMAT) $(FIGS) $(BIB)
	$(PANDOC) --citeproc --verbose -s -o $@ $(SECTIONS) $(FORMAT)

$(MD): $(SECTIONS) $(FORMAT) $(FIGS) $(BIB)
	$(PANDOC) --citeproc --verbose -s -o $@ $(SECTIONS) $(FORMAT)

test.md: $(SECTIONS) $(FORMAT) $(TABS_FIGS) $(BIB)
	pandoc --citeproc --verbose -s -o $@ $(SECTIONS) $(FORMAT)

all: $(MANUSCRIPT)

$(TABS_FIGS) &: analysis/tables.Rmd
	$(MAKE) -C analysis

clean:
	rm artemis_methods.pdf

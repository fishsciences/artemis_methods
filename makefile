
INTRO = intro/intro.md intro/eDNA_background.md intro/estimating_eDNA.md intro/modeling_eDNA.md intro/package_desc.md
METHODS = methods/methods.md
SECTIONS=abstract.md $(INTRO) $(METHODS) results/results.md discussion/discussion.md discussion/future_work.md conclusion/conclusion.md
TABS_FIGS = analysis/tables.md
FORMAT=format.yaml
BIB=artemis.bibtex

MANUSCRIPT=artemis_methods.pdf

$(MANUSCRIPT): $(SECTIONS) $(FORMAT) $(BIB) $(TABS_FIGS)
	pandoc --citeproc -s -o $@ $^

test.md: $(SECTIONS) $(FORMAT) $(BIB)
	pandoc artemis.bibtex --verbose --citeproc -o $@ $^

all: $(MANUSCRIPT)

$(TABS_FIGS) &: 
	$(MAKE) -C analysis


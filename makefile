PANDOC = /usr/bin/pandoc
INTRO = intro/intro.md intro/eDNA_background.md intro/estimating_eDNA.md intro/modeling_eDNA.md intro/package_desc.md
METHODS = methods/methods.md
DISCUSSION = discussion/discussion.md discussion/future_work.md
SECTIONS=abstract.md $(INTRO) $(METHODS) results/results.md  $(DISCUSSION) conclusion/conclusion.md $(TABS_FIGS)
TABS_FIGS = analysis/tables.md
FORMAT=format.yaml
BIB=artemis.bibtex

MANUSCRIPT=artemis_methods.pdf

$(MANUSCRIPT): $(SECTIONS) $(FORMAT) $(TABS_FIGS) $(BIB)
	$(PANDOC) --citeproc --verbose -s -o $@ $(SECTIONS) $(FORMAT)

test.md: $(SECTIONS) $(FORMAT) $(TABS_FIGS) $(BIB)
	pandoc --citeproc --verbose -s -o $@ $(SECTIONS) $(FORMAT)

all: $(MANUSCRIPT)

$(TABS_FIGS) &: 
	$(MAKE) -C analysis

clean:
	rm artemis_methods.pdf

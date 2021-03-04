
INTRO = intro/intro.md intro/eDNA_background.md intro/estimating_eDNA.md intro/modeling_eDNA.md intro/package_desc.md
METHODS = methods/methods.md
SECTIONS=abstract.md $(INTRO) $(METHODS) results/results.md discussion/discussion.md conclusion/conclusion.md
FORMAT=format.yaml
BIB=artemis.bib

MANUSCRIPT=artemis_methods.pdf

$(MANUSCRIPT): $(SECTIONS) $(FORMAT) $(BIB)
	pandoc -o $@ $^

test.md: $(SECTIONS) $(FORMAT) $(BIB)
	pandoc artemis.bib --verbose --citeproc -o $@ $^

all: $(MANUSCRIPT)

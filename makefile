
INTRO = intro/intro.md intro/eDNA_background.md intro/estimating_eDNA.md intro/modeling_eDNA.md intro/package_desc.md
METHODS = methods/methods.md
SECTIONS=abstract.md $(INTRO) $(METHODS) results/results.md discussion/discussion.md conclusion/conclusion.md
FORMAT=format.yaml
BIB=artemis.bibtex

MANUSCRIPT=artemis_methods.pdf

$(MANUSCRIPT): $(SECTIONS) $(FORMAT) $(BIB)
	pandoc --citeproc -o $@ $^

test.md: $(SECTIONS) $(FORMAT) $(BIB)
	pandoc artemis.bibtex --verbose --citeproc -o $@ $^

all: $(MANUSCRIPT)

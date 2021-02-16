
INTRO = intro/intro.md intro/eDNA_background.md intro/estimating_eDNA.md intro/modeling_eDNA.md intro/package_desc.md
METHODS = methods/methods.md
SECTIONS=abstract.md $(INTRO) $(METHODS) results/results.md discussion/discussion.md conclusion/conclusion.md
FORMAT=format.yaml

MANUSCRIPT=artemis_methods.pdf

$(MANUSCRIPT): $(SECTIONS) $(FORMAT)
	pandoc -o $@ $^

all: $(MANUSCRIPT)

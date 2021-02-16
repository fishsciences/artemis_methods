SECTIONS=abstract.md intro/intro.md intro/modeling_eDNA.md methods/methods.md results/results.md discussion/discussion.md conclusion/conclusion.md
FORMAT=format.yaml

MANUSCRIPT=artemis_methods.pdf

$(MANUSCRIPT): $(SECTIONS) $(FORMAT)
	pandoc -o $@ $^

all: $(MANUSCRIPT)

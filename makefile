SECTIONS=00_abstract.md 01_intro.md 02_methods.md 03_results.md 04_discussion.md 05_conclusion.md
FORMAT=format.yaml

MANUSCRIPT=artemis_methods.pdf

$(MANUSCRIPT): $(SECTIONS) $(FORMAT)
	pandoc -o $@ $^

all: $(MANUSCRIPT)

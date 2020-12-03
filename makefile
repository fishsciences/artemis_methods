SECTIONS=00_abstract.md 01_intro.md 02_methods.md 03_results.md 04_discussion.md 05_conclusion.md

MANUSCRIPT=artemis_methods.pdf

$(MANUSCRIPT): $(SECTIONS)
	pandoc -o $@ $^

ms: $(MANUSCRIPT)

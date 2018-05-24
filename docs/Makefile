TOPDIR := ..
include $(TOPDIR)/Makedefs


PDF := B.pdf
$(PDF): $(shell find . -name "*.tex")


all: $(PDF)
	@

clean:
	@rm -f *.aux *.log *.out *.toc *.pdf *.gz

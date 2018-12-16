tex-main-source := notes.tex
tex-sources := $(tex-main-source) eulers-method.tex
prog-sources := eulers-method.scm
output := notes.pdf

$(output) : $(tex-sources) $(prog-sources)
	pdflatex $(tex-main-source)
	pdflatex $(tex-main-source)
	pdflatex $(tex-main-source)

.PHONY: clean
clean:
	rm $(output)
	rm $(output:pdf=toc)
	rm $(output:pdf=aux)
	rm $(output:pdf=log)

## Makefile

all: 07_automatingData.html

#lotr_raw.tsv:
#	curl -L http://bit.ly/lotr_raw-tsv >lotr_raw.tsv

gapminder.tsv:
	Rscript 00_downloadData.R

gap_data.tsv lifeExp_vs_year.png ReOrd_lifeExp_vs_year.png 01_filter-reorder-plot.html: 01_cleanData.R gap_data.tsv 
	Rscript -e "rmarkdown::render('$<')"

gap_Rdata.tsv top_Asia.png top_Americas.png top_Africa.png top_Europe.png: gap_Rdata.tsv 02_analyzeData.R
	Rscript 02_analyzeData.R
	rm Rplots.pdf

07_automatingData.html: 07_automatingData.Rmd gap_Rdata.tsv
	Rscript -e "rmarkdown::render('$<')"

clean:
	rm -rf *.tsv *.png 0*.md *.html 
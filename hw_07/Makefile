## Makefile

all: 07_automatingData.html

#lotr_raw.tsv:
#	curl -L http://bit.ly/lotr_raw-tsv >lotr_raw.tsv

gapminder.tsv:
	Rscript 00_downloadData.R

gap_data.tsv lifeExp_vs_year.png ReOrd_lifeExp_vs_year.png 01_filter-reorder-plot.html: 01_cleanData.R lotr_raw.tsv 
	Rscript -e "rmarkdown::render('$<')"

total-words-by-film-race.tsv: lotr_clean.tsv 02_aggregate-plot.R
	Rscript 02_aggregate-plot.R
	rm Rplots.pdf

03_lotr-report.html: 03_lotr-report.Rmd lotr_clean.tsv barchart_total-words-by-race.png
	Rscript -e "rmarkdown::render('$<')"

clean:
	rm -rf *.tsv *.png 0*.md *.html 
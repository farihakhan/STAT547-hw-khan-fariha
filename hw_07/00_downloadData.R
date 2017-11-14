## Download data that will be used for homework 7

if(!file.exists("data")){
      dir.create("data")
}
fileUrl <- "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/extdata/gapminder.tsv"

download.file(fileUrl, destfile = "./data/gapminder.tsv")
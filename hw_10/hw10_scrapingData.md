# HW10 Scraping data - IMDb Top 250 Rate Movies
Fariha Khan  
2017-12-07  





```r
## Load packages
suppressPackageStartupMessages(library(tidyverse)) 
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(kableExtra))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(rvest))
```


### Get data from web
I wrote my code in an R script to make the markdown cleaner to view.
The rScript for the first part is found [here]()

```r
suppressMessages(source('rScripts/01_scrapeData.r'))
```


### View data structure

##### View [html_structure](https://github.com/farihakhan/STAT547-hw-khan-fariha/blob/master/hw_10/html_structure.md)


```r
imdb
```

```
## {xml_document}
## <html xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset= ...
## [2] <body id="styleguide-v2" class="fixed">\n<script>\n    if (typeof ue ...
```

```r
imdb %>%
      html_nodes(".titleColumn") %>% 
      html_text() %>%
      head()
```

```
## [1] "\n      1.\n      The Shawshank Redemption\n        (1994)\n    "
## [2] "\n      2.\n      The Godfather\n        (1972)\n    "           
## [3] "\n      3.\n      The Godfather: Part II\n        (1974)\n    "  
## [4] "\n      4.\n      The Dark Knight\n        (2008)\n    "         
## [5] "\n      5.\n      12 Angry Men\n        (1957)\n    "            
## [6] "\n      6.\n      Schindler's List\n        (1993)\n    "
```


### Extract and structure data:

I stored each column variable into character lists. I changed some of the data types of the variables to allow analysis.

The extracted variables are:

 - Title
 
 - Year released
 
 - Rating 
 
 - Number of IMDb user votes
 
 - Brief cast info
 
 - Link associated with each movie
 
<style>
pre code, pre, code {
  white-space: pre !important;
  overflow-x: scroll !important;
  word-break: keep-all !important;
  word-wrap: initial !important;
}
</style>

```r
Title <- imdb %>% 
      html_nodes(".titleColumn") %>% 
      html_nodes("a, #text") %>% 
      html_text()

yearRelease <- imdb %>% 
      html_nodes(".secondaryInfo") %>% 
      html_text() %>% 
      str_replace_all(c("[(|)]" = "")) %>% 
      as.numeric()

Rating <- imdb %>% 
      html_nodes(".ratingColumn.imdbRating") %>% 
      html_nodes("strong") %>% 
      html_text() %>% 
      as.numeric()

Votes <- imdb %>% 
      html_nodes(".ratingColumn.imdbRating") %>% 
      html_nodes("strong") %>% 
      html_attrs() %>% 
      map("title") %>% 
      unlist()

Cast <- imdb %>% 
      html_nodes(".titleColumn") %>% 
      html_nodes("a, #text") %>% 
      html_attrs() %>% 
      map("title") %>% 
      unlist()

Link <- imdb %>% 
      html_nodes(".titleColumn") %>% 
      html_nodes("a, #text") %>% 
      html_attrs() %>% 
      map("href") %>% 
      unlist()
```


### Create summary dataframe


```r
imdb_df <- extractFields(imdb)
imdb_df %>% glimpse()
```

```
## Observations: 250
## Variables: 6
## $ Title       <fctr> The Shawshank Redemption, The Godfather, The Godf...
## $ yearRelease <dbl> 1994, 1972, 1974, 2008, 1957, 1993, 1994, 2003, 19...
## $ Rating      <dbl> 9.2, 9.2, 9.0, 9.0, 8.9, 8.9, 8.9, 8.9, 8.8, 8.8, ...
## $ Cast        <fctr> Frank Darabont (dir.), Tim Robbins, Morgan Freema...
## $ Votes       <fctr> 9.2 based on 1,884,579 user ratings, 9.2 based on...
## $ Link        <chr> "http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FG...
```

### Clean dataset

Parse out names of the cast memebers for analysis

```r
imdb_kable1
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-y: scroll; height:500px; "><table class="table table-striped" style="margin-left: auto; margin-right: auto;">
<caption>imdb Top 250 Rated movies</caption>
 <thead><tr>
<th style="text-align:center;"> Title </th>
   <th style="text-align:center;"> yearRelease </th>
   <th style="text-align:center;"> Rating </th>
   <th style="text-align:center;"> no.Votes </th>
   <th style="text-align:center;"> Director </th>
   <th style="text-align:center;"> Cast1 </th>
   <th style="text-align:center;"> Cast2 </th>
   <th style="text-align:center;"> movieURL </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:center;"> The Shawshank Redemption </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 9.2 </td>
   <td style="text-align:center;"> 1884579 </td>
   <td style="text-align:center;"> Frank Darabont </td>
   <td style="text-align:center;"> Tim Robbins </td>
   <td style="text-align:center;"> Morgan Freeman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_1) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Godfather </td>
   <td style="text-align:center;"> 1972 </td>
   <td style="text-align:center;"> 9.2 </td>
   <td style="text-align:center;"> 1286677 </td>
   <td style="text-align:center;"> Francis Ford Coppola </td>
   <td style="text-align:center;"> Marlon Brando </td>
   <td style="text-align:center;"> Al Pacino </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0068646/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_2) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Godfather: Part II </td>
   <td style="text-align:center;"> 1974 </td>
   <td style="text-align:center;"> 9.0 </td>
   <td style="text-align:center;"> 887575 </td>
   <td style="text-align:center;"> Francis Ford Coppola </td>
   <td style="text-align:center;"> Al Pacino </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0071562/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_3) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Dark Knight </td>
   <td style="text-align:center;"> 2008 </td>
   <td style="text-align:center;"> 9.0 </td>
   <td style="text-align:center;"> 1860509 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Christian Bale </td>
   <td style="text-align:center;"> Heath Ledger </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0468569/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_4) </td>
  </tr>
<tr>
<td style="text-align:center;"> 12 Angry Men </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.9 </td>
   <td style="text-align:center;"> 517017 </td>
   <td style="text-align:center;"> Sidney Lumet </td>
   <td style="text-align:center;"> Henry Fonda </td>
   <td style="text-align:center;"> Lee J. Cobb </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0050083/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_5) </td>
  </tr>
<tr>
<td style="text-align:center;"> Schindler's List </td>
   <td style="text-align:center;"> 1993 </td>
   <td style="text-align:center;"> 8.9 </td>
   <td style="text-align:center;"> 968914 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Liam Neeson </td>
   <td style="text-align:center;"> Ralph Fiennes </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0108052/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_6) </td>
  </tr>
<tr>
<td style="text-align:center;"> Pulp Fiction </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 8.9 </td>
   <td style="text-align:center;"> 1474181 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> John Travolta </td>
   <td style="text-align:center;"> Uma Thurman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0110912/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_7) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Lord of the Rings: The Return of the King </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.9 </td>
   <td style="text-align:center;"> 1346700 </td>
   <td style="text-align:center;"> Peter Jackson </td>
   <td style="text-align:center;"> Elijah Wood </td>
   <td style="text-align:center;"> Viggo Mortensen </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0167260/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_8) </td>
  </tr>
<tr>
<td style="text-align:center;"> Il buono, il brutto, il cattivo </td>
   <td style="text-align:center;"> 1966 </td>
   <td style="text-align:center;"> 8.8 </td>
   <td style="text-align:center;"> 558307 </td>
   <td style="text-align:center;"> Sergio Leone </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Eli Wallach </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0060196/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_9) </td>
  </tr>
<tr>
<td style="text-align:center;"> Fight Club </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.8 </td>
   <td style="text-align:center;"> 1510493 </td>
   <td style="text-align:center;"> David Fincher </td>
   <td style="text-align:center;"> Brad Pitt </td>
   <td style="text-align:center;"> Edward Norton </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0137523/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_10) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Lord of the Rings: The Fellowship of the Ring </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.8 </td>
   <td style="text-align:center;"> 1366940 </td>
   <td style="text-align:center;"> Peter Jackson </td>
   <td style="text-align:center;"> Elijah Wood </td>
   <td style="text-align:center;"> Ian McKellen </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0120737/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_11) </td>
  </tr>
<tr>
<td style="text-align:center;"> Forrest Gump </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 1422069 </td>
   <td style="text-align:center;"> Robert Zemeckis </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Robin Wright </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0109830/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_12) </td>
  </tr>
<tr>
<td style="text-align:center;"> Star Wars: Episode V - The Empire Strikes Back </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 940527 </td>
   <td style="text-align:center;"> Irvin Kershner </td>
   <td style="text-align:center;"> Mark Hamill </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0080684/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_13) </td>
  </tr>
<tr>
<td style="text-align:center;"> Inception </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 1649521 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Joseph Gordon-Levitt </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1375666/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_14) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Lord of the Rings: The Two Towers </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 1218943 </td>
   <td style="text-align:center;"> Peter Jackson </td>
   <td style="text-align:center;"> Elijah Wood </td>
   <td style="text-align:center;"> Ian McKellen </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0167261/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_15) </td>
  </tr>
<tr>
<td style="text-align:center;"> One Flew Over the Cuckoo's Nest </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 752391 </td>
   <td style="text-align:center;"> Milos Forman </td>
   <td style="text-align:center;"> Jack Nicholson </td>
   <td style="text-align:center;"> Louise Fletcher </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0073486/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_16) </td>
  </tr>
<tr>
<td style="text-align:center;"> Goodfellas </td>
   <td style="text-align:center;"> 1990 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 812075 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Ray Liotta </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0099685/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_17) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Matrix </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 1355703 </td>
   <td style="text-align:center;"> Lana Wachowski </td>
   <td style="text-align:center;"> Keanu Reeves </td>
   <td style="text-align:center;"> Laurence Fishburne </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0133093/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_18) </td>
  </tr>
<tr>
<td style="text-align:center;"> Shichinin no samurai </td>
   <td style="text-align:center;"> 1954 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 253946 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Toshirô Mifune </td>
   <td style="text-align:center;"> Takashi Shimura </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0047478/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_19) </td>
  </tr>
<tr>
<td style="text-align:center;"> Star Wars </td>
   <td style="text-align:center;"> 1977 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 1012779 </td>
   <td style="text-align:center;"> George Lucas </td>
   <td style="text-align:center;"> Mark Hamill </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0076759/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_20) </td>
  </tr>
<tr>
<td style="text-align:center;"> Cidade de Deus </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 586626 </td>
   <td style="text-align:center;"> Fernando Meirelles </td>
   <td style="text-align:center;"> Alexandre Rodrigues </td>
   <td style="text-align:center;"> Leandro Firmino </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0317248/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_21) </td>
  </tr>
<tr>
<td style="text-align:center;"> Se7en </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 1149334 </td>
   <td style="text-align:center;"> David Fincher </td>
   <td style="text-align:center;"> Morgan Freeman </td>
   <td style="text-align:center;"> Brad Pitt </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0114369/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_22) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Silence of the Lambs </td>
   <td style="text-align:center;"> 1991 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 1003525 </td>
   <td style="text-align:center;"> Jonathan Demme </td>
   <td style="text-align:center;"> Jodie Foster </td>
   <td style="text-align:center;"> Anthony Hopkins </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0102926/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_23) </td>
  </tr>
<tr>
<td style="text-align:center;"> It's a Wonderful Life </td>
   <td style="text-align:center;"> 1946 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 311571 </td>
   <td style="text-align:center;"> Frank Capra </td>
   <td style="text-align:center;"> James Stewart </td>
   <td style="text-align:center;"> Donna Reed </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0038650/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_24) </td>
  </tr>
<tr>
<td style="text-align:center;"> La vita è bella </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 483551 </td>
   <td style="text-align:center;"> Roberto Benigni </td>
   <td style="text-align:center;"> Roberto Benigni </td>
   <td style="text-align:center;"> Nicoletta Braschi </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0118799/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_25) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Usual Suspects </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 823900 </td>
   <td style="text-align:center;"> Bryan Singer </td>
   <td style="text-align:center;"> Kevin Spacey </td>
   <td style="text-align:center;"> Gabriel Byrne </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0114814/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_26) </td>
  </tr>
<tr>
<td style="text-align:center;"> Léon </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 817806 </td>
   <td style="text-align:center;"> Luc Besson </td>
   <td style="text-align:center;"> Jean Reno </td>
   <td style="text-align:center;"> Gary Oldman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0110413/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_27) </td>
  </tr>
<tr>
<td style="text-align:center;"> Saving Private Ryan </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 991624 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Matt Damon </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0120815/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_28) </td>
  </tr>
<tr>
<td style="text-align:center;"> Sen to Chihiro no kamikakushi </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 484260 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Daveigh Chase </td>
   <td style="text-align:center;"> Suzanne Pleshette </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0245429/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_29) </td>
  </tr>
<tr>
<td style="text-align:center;"> American History X </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 867293 </td>
   <td style="text-align:center;"> Tony Kaye </td>
   <td style="text-align:center;"> Edward Norton </td>
   <td style="text-align:center;"> Edward Furlong </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0120586/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_30) </td>
  </tr>
<tr>
<td style="text-align:center;"> Once Upon a Time in the West </td>
   <td style="text-align:center;"> 1968 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 242251 </td>
   <td style="text-align:center;"> Sergio Leone </td>
   <td style="text-align:center;"> Henry Fonda </td>
   <td style="text-align:center;"> Charles Bronson </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0064116/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_31) </td>
  </tr>
<tr>
<td style="text-align:center;"> Interstellar </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 1116154 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Matthew McConaughey </td>
   <td style="text-align:center;"> Anne Hathaway </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0816692/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_32) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Green Mile </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 892526 </td>
   <td style="text-align:center;"> Frank Darabont </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Michael Clarke Duncan </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0120689/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_33) </td>
  </tr>
<tr>
<td style="text-align:center;"> Psycho </td>
   <td style="text-align:center;"> 1960 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 475599 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> Anthony Perkins </td>
   <td style="text-align:center;"> Janet Leigh </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0054215/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_34) </td>
  </tr>
<tr>
<td style="text-align:center;"> Casablanca </td>
   <td style="text-align:center;"> 1942 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 429127 </td>
   <td style="text-align:center;"> Michael Curtiz </td>
   <td style="text-align:center;"> Humphrey Bogart </td>
   <td style="text-align:center;"> Ingrid Bergman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0034583/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_35) </td>
  </tr>
<tr>
<td style="text-align:center;"> City Lights </td>
   <td style="text-align:center;"> 1931 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 125370 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Virginia Cherrill </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0021749/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_36) </td>
  </tr>
<tr>
<td style="text-align:center;"> Coco </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 28902 </td>
   <td style="text-align:center;"> Lee Unkrich </td>
   <td style="text-align:center;"> Anthony Gonzalez </td>
   <td style="text-align:center;"> Gael García Bernal </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt2380307/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_37) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Intouchables </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 589157 </td>
   <td style="text-align:center;"> Olivier Nakache </td>
   <td style="text-align:center;"> François Cluzet </td>
   <td style="text-align:center;"> Omar Sy </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1675434/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_38) </td>
  </tr>
<tr>
<td style="text-align:center;"> Modern Times </td>
   <td style="text-align:center;"> 1936 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 164724 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Paulette Goddard </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0027977/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_39) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Pianist </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 566366 </td>
   <td style="text-align:center;"> Roman Polanski </td>
   <td style="text-align:center;"> Adrien Brody </td>
   <td style="text-align:center;"> Thomas Kretschmann </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0253474/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_40) </td>
  </tr>
<tr>
<td style="text-align:center;"> Raiders of the Lost Ark </td>
   <td style="text-align:center;"> 1981 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 731545 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> Karen Allen </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0082971/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_41) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Departed </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 973446 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Matt Damon </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0407887/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_42) </td>
  </tr>
<tr>
<td style="text-align:center;"> Rear Window </td>
   <td style="text-align:center;"> 1954 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 354712 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> James Stewart </td>
   <td style="text-align:center;"> Grace Kelly </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0047396/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_43) </td>
  </tr>
<tr>
<td style="text-align:center;"> Terminator 2: Judgment Day </td>
   <td style="text-align:center;"> 1991 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 822728 </td>
   <td style="text-align:center;"> James Cameron </td>
   <td style="text-align:center;"> Arnold Schwarzenegger </td>
   <td style="text-align:center;"> Linda Hamilton </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0103064/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_44) </td>
  </tr>
<tr>
<td style="text-align:center;"> Back to the Future </td>
   <td style="text-align:center;"> 1985 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 827647 </td>
   <td style="text-align:center;"> Robert Zemeckis </td>
   <td style="text-align:center;"> Michael J. Fox </td>
   <td style="text-align:center;"> Christopher Lloyd </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0088763/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_45) </td>
  </tr>
<tr>
<td style="text-align:center;"> Whiplash </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 515053 </td>
   <td style="text-align:center;"> Damien Chazelle </td>
   <td style="text-align:center;"> Miles Teller </td>
   <td style="text-align:center;"> J.K. Simmons </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt2582802/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_46) </td>
  </tr>
<tr>
<td style="text-align:center;"> Gladiator </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 1093374 </td>
   <td style="text-align:center;"> Ridley Scott </td>
   <td style="text-align:center;"> Russell Crowe </td>
   <td style="text-align:center;"> Joaquin Phoenix </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0172495/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_47) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Lion King </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 733709 </td>
   <td style="text-align:center;"> Roger Allers </td>
   <td style="text-align:center;"> Matthew Broderick </td>
   <td style="text-align:center;"> Jeremy Irons </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0110357/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_48) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Prestige </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 956746 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Christian Bale </td>
   <td style="text-align:center;"> Hugh Jackman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0482571/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_49) </td>
  </tr>
<tr>
<td style="text-align:center;"> Memento </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 940387 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Guy Pearce </td>
   <td style="text-align:center;"> Carrie-Anne Moss </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0209144/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_50) </td>
  </tr>
<tr>
<td style="text-align:center;"> Apocalypse Now </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 496694 </td>
   <td style="text-align:center;"> Francis Ford Coppola </td>
   <td style="text-align:center;"> Martin Sheen </td>
   <td style="text-align:center;"> Marlon Brando </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0078788/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_51) </td>
  </tr>
<tr>
<td style="text-align:center;"> Alien </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 641792 </td>
   <td style="text-align:center;"> Ridley Scott </td>
   <td style="text-align:center;"> Sigourney Weaver </td>
   <td style="text-align:center;"> Tom Skerritt </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0078748/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_52) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Great Dictator </td>
   <td style="text-align:center;"> 1940 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 157419 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Paulette Goddard </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0032553/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_53) </td>
  </tr>
<tr>
<td style="text-align:center;"> Sunset Blvd. </td>
   <td style="text-align:center;"> 1950 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 157134 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> William Holden </td>
   <td style="text-align:center;"> Gloria Swanson </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0043014/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_54) </td>
  </tr>
<tr>
<td style="text-align:center;"> Nuovo Cinema Paradiso </td>
   <td style="text-align:center;"> 1988 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 174296 </td>
   <td style="text-align:center;"> Giuseppe Tornatore </td>
   <td style="text-align:center;"> Philippe Noiret </td>
   <td style="text-align:center;"> Enzo Cannavale </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0095765/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_55) </td>
  </tr>
<tr>
<td style="text-align:center;"> Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb </td>
   <td style="text-align:center;"> 1964 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 378377 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Peter Sellers </td>
   <td style="text-align:center;"> George C. Scott </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0057012/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_56) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Lives of Others </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 289532 </td>
   <td style="text-align:center;"> Florian Henckel von Donnersmarck </td>
   <td style="text-align:center;"> Ulrich Mühe </td>
   <td style="text-align:center;"> Martina Gedeck </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0405094/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_57) </td>
  </tr>
<tr>
<td style="text-align:center;"> Hotaru no haka </td>
   <td style="text-align:center;"> 1988 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 163919 </td>
   <td style="text-align:center;"> Isao Takahata </td>
   <td style="text-align:center;"> Tsutomu Tatsumi </td>
   <td style="text-align:center;"> Ayano Shiraishi </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0095327/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_58) </td>
  </tr>
<tr>
<td style="text-align:center;"> Paths of Glory </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 136701 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Kirk Douglas </td>
   <td style="text-align:center;"> Ralph Meeker </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0050825/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_59) </td>
  </tr>
<tr>
<td style="text-align:center;"> Django Unchained </td>
   <td style="text-align:center;"> 2012 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 1084843 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> Jamie Foxx </td>
   <td style="text-align:center;"> Christoph Waltz </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1853728/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_60) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Shining </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 690516 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Jack Nicholson </td>
   <td style="text-align:center;"> Shelley Duvall </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0081505/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_61) </td>
  </tr>
<tr>
<td style="text-align:center;"> WALL·E </td>
   <td style="text-align:center;"> 2008 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 810239 </td>
   <td style="text-align:center;"> Andrew Stanton </td>
   <td style="text-align:center;"> Ben Burtt </td>
   <td style="text-align:center;"> Elissa Knight </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0910970/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_62) </td>
  </tr>
<tr>
<td style="text-align:center;"> American Beauty </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 909779 </td>
   <td style="text-align:center;"> Sam Mendes </td>
   <td style="text-align:center;"> Kevin Spacey </td>
   <td style="text-align:center;"> Annette Bening </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0169547/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_63) </td>
  </tr>
<tr>
<td style="text-align:center;"> Mononoke-hime </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 256436 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Yôji Matsuda </td>
   <td style="text-align:center;"> Yuriko Ishida </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0119698/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_64) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Dark Knight Rises </td>
   <td style="text-align:center;"> 2012 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 1267010 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Christian Bale </td>
   <td style="text-align:center;"> Tom Hardy </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1345836/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_65) </td>
  </tr>
<tr>
<td style="text-align:center;"> Blade Runner 2049 </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 156246 </td>
   <td style="text-align:center;"> Denis Villeneuve </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> Ryan Gosling </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1856101/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_66) </td>
  </tr>
<tr>
<td style="text-align:center;"> Oldeuboi </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 406363 </td>
   <td style="text-align:center;"> Chan-wook Park </td>
   <td style="text-align:center;"> Min-sik Choi </td>
   <td style="text-align:center;"> Ji-tae Yu </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0364569/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_67) </td>
  </tr>
<tr>
<td style="text-align:center;"> Aliens </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 546468 </td>
   <td style="text-align:center;"> James Cameron </td>
   <td style="text-align:center;"> Sigourney Weaver </td>
   <td style="text-align:center;"> Michael Biehn </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0090605/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_68) </td>
  </tr>
<tr>
<td style="text-align:center;"> Witness for the Prosecution </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 75463 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> Tyrone Power </td>
   <td style="text-align:center;"> Marlene Dietrich </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0051201/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_69) </td>
  </tr>
<tr>
<td style="text-align:center;"> Once Upon a Time in America </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 246915 </td>
   <td style="text-align:center;"> Sergio Leone </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> James Woods </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0087843/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_70) </td>
  </tr>
<tr>
<td style="text-align:center;"> Das Boot </td>
   <td style="text-align:center;"> 1981 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 186770 </td>
   <td style="text-align:center;"> Wolfgang Petersen </td>
   <td style="text-align:center;"> Jürgen Prochnow </td>
   <td style="text-align:center;"> Herbert Grönemeyer </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0082096/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_71) </td>
  </tr>
<tr>
<td style="text-align:center;"> Dangal </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 76868 </td>
   <td style="text-align:center;"> Nitesh Tiwari </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> Sakshi Tanwar </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt5074352/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_72) </td>
  </tr>
<tr>
<td style="text-align:center;"> Citizen Kane </td>
   <td style="text-align:center;"> 1941 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 328634 </td>
   <td style="text-align:center;"> Orson Welles </td>
   <td style="text-align:center;"> Orson Welles </td>
   <td style="text-align:center;"> Joseph Cotten </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0033467/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_73) </td>
  </tr>
<tr>
<td style="text-align:center;"> Vertigo </td>
   <td style="text-align:center;"> 1958 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 282189 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> James Stewart </td>
   <td style="text-align:center;"> Kim Novak </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0052357/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_74) </td>
  </tr>
<tr>
<td style="text-align:center;"> North by Northwest </td>
   <td style="text-align:center;"> 1959 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 243185 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> Cary Grant </td>
   <td style="text-align:center;"> Eva Marie Saint </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0053125/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_75) </td>
  </tr>
<tr>
<td style="text-align:center;"> Star Wars: Episode VI - Return of the Jedi </td>
   <td style="text-align:center;"> 1983 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 771304 </td>
   <td style="text-align:center;"> Richard Marquand </td>
   <td style="text-align:center;"> Mark Hamill </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0086190/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_76) </td>
  </tr>
<tr>
<td style="text-align:center;"> Braveheart </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 816291 </td>
   <td style="text-align:center;"> Mel Gibson </td>
   <td style="text-align:center;"> Mel Gibson </td>
   <td style="text-align:center;"> Sophie Marceau </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0112573/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_77) </td>
  </tr>
<tr>
<td style="text-align:center;"> Reservoir Dogs </td>
   <td style="text-align:center;"> 1992 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 744303 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> Harvey Keitel </td>
   <td style="text-align:center;"> Tim Roth </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0105236/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_78) </td>
  </tr>
<tr>
<td style="text-align:center;"> M </td>
   <td style="text-align:center;"> 1931 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 111516 </td>
   <td style="text-align:center;"> Fritz Lang </td>
   <td style="text-align:center;"> Peter Lorre </td>
   <td style="text-align:center;"> Ellen Widmann </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0022100/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_79) </td>
  </tr>
<tr>
<td style="text-align:center;"> Requiem for a Dream </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 638086 </td>
   <td style="text-align:center;"> Darren Aronofsky </td>
   <td style="text-align:center;"> Ellen Burstyn </td>
   <td style="text-align:center;"> Jared Leto </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0180093/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_80) </td>
  </tr>
<tr>
<td style="text-align:center;"> Taare Zameen Par </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 112795 </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> Darsheel Safary </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0986264/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_81) </td>
  </tr>
<tr>
<td style="text-align:center;"> Amélie </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 593779 </td>
   <td style="text-align:center;"> Jean-Pierre Jeunet </td>
   <td style="text-align:center;"> Audrey Tautou </td>
   <td style="text-align:center;"> Mathieu Kassovitz </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0211915/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_82) </td>
  </tr>
<tr>
<td style="text-align:center;"> Kimi no na wa. </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 64335 </td>
   <td style="text-align:center;"> Makoto Shinkai </td>
   <td style="text-align:center;"> Ryûnosuke Kamiki </td>
   <td style="text-align:center;"> Mone Kamishiraishi </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt5311514/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_83) </td>
  </tr>
<tr>
<td style="text-align:center;"> A Clockwork Orange </td>
   <td style="text-align:center;"> 1971 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 622401 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Malcolm McDowell </td>
   <td style="text-align:center;"> Patrick Magee </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0066921/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_84) </td>
  </tr>
<tr>
<td style="text-align:center;"> Lawrence of Arabia </td>
   <td style="text-align:center;"> 1962 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 215235 </td>
   <td style="text-align:center;"> David Lean </td>
   <td style="text-align:center;"> Peter O'Toole </td>
   <td style="text-align:center;"> Alec Guinness </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0056172/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_85) </td>
  </tr>
<tr>
<td style="text-align:center;"> Amadeus </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 302575 </td>
   <td style="text-align:center;"> Milos Forman </td>
   <td style="text-align:center;"> F. Murray Abraham </td>
   <td style="text-align:center;"> Tom Hulce </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0086879/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_86) </td>
  </tr>
<tr>
<td style="text-align:center;"> Double Indemnity </td>
   <td style="text-align:center;"> 1944 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 110579 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> Fred MacMurray </td>
   <td style="text-align:center;"> Barbara Stanwyck </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0036775/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_87) </td>
  </tr>
<tr>
<td style="text-align:center;"> Eternal Sunshine of the Spotless Mind </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 744913 </td>
   <td style="text-align:center;"> Michel Gondry </td>
   <td style="text-align:center;"> Jim Carrey </td>
   <td style="text-align:center;"> Kate Winslet </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0338013/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_88) </td>
  </tr>
<tr>
<td style="text-align:center;"> Taxi Driver </td>
   <td style="text-align:center;"> 1976 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 570178 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Jodie Foster </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0075314/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_89) </td>
  </tr>
<tr>
<td style="text-align:center;"> To Kill a Mockingbird </td>
   <td style="text-align:center;"> 1962 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 242474 </td>
   <td style="text-align:center;"> Robert Mulligan </td>
   <td style="text-align:center;"> Gregory Peck </td>
   <td style="text-align:center;"> John Megna </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0056592/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_90) </td>
  </tr>
<tr>
<td style="text-align:center;"> Full Metal Jacket </td>
   <td style="text-align:center;"> 1987 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 544670 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Matthew Modine </td>
   <td style="text-align:center;"> R. Lee Ermey </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0093058/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_91) </td>
  </tr>
<tr>
<td style="text-align:center;"> 2001: A Space Odyssey </td>
   <td style="text-align:center;"> 1968 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 480681 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Keir Dullea </td>
   <td style="text-align:center;"> Gary Lockwood </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0062622/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_92) </td>
  </tr>
<tr>
<td style="text-align:center;"> Singin' in the Rain </td>
   <td style="text-align:center;"> 1952 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 172379 </td>
   <td style="text-align:center;"> Stanley Donen </td>
   <td style="text-align:center;"> Gene Kelly </td>
   <td style="text-align:center;"> Donald O'Connor </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0045152/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_93) </td>
  </tr>
<tr>
<td style="text-align:center;"> Toy Story </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 703214 </td>
   <td style="text-align:center;"> John Lasseter </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Tim Allen </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0114709/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_94) </td>
  </tr>
<tr>
<td style="text-align:center;"> 3 Idiots </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 255782 </td>
   <td style="text-align:center;"> Rajkumar Hirani </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> Madhavan </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1187043/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_95) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Sting </td>
   <td style="text-align:center;"> 1973 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 195830 </td>
   <td style="text-align:center;"> George Roy Hill </td>
   <td style="text-align:center;"> Paul Newman </td>
   <td style="text-align:center;"> Robert Redford </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0070735/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_96) </td>
  </tr>
<tr>
<td style="text-align:center;"> Toy Story 3 </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 610740 </td>
   <td style="text-align:center;"> Lee Unkrich </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Tim Allen </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0435761/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_97) </td>
  </tr>
<tr>
<td style="text-align:center;"> Inglourious Basterds </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 1001806 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> Brad Pitt </td>
   <td style="text-align:center;"> Diane Kruger </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0361748/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_98) </td>
  </tr>
<tr>
<td style="text-align:center;"> Ladri di biciclette </td>
   <td style="text-align:center;"> 1948 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 108561 </td>
   <td style="text-align:center;"> Vittorio De Sica </td>
   <td style="text-align:center;"> Lamberto Maggiorani </td>
   <td style="text-align:center;"> Enzo Staiola </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0040522/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_99) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Kid </td>
   <td style="text-align:center;"> 1921 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 80461 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Edna Purviance </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0012349/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_100) </td>
  </tr>
<tr>
<td style="text-align:center;"> Snatch </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 661623 </td>
   <td style="text-align:center;"> Guy Ritchie </td>
   <td style="text-align:center;"> Jason Statham </td>
   <td style="text-align:center;"> Brad Pitt </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0208092/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_101) </td>
  </tr>
<tr>
<td style="text-align:center;"> Monty Python and the Holy Grail </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 418875 </td>
   <td style="text-align:center;"> Terry Gilliam </td>
   <td style="text-align:center;"> Graham Chapman </td>
   <td style="text-align:center;"> John Cleese </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0071853/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_102) </td>
  </tr>
<tr>
<td style="text-align:center;"> Good Will Hunting </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 685298 </td>
   <td style="text-align:center;"> Gus Van Sant </td>
   <td style="text-align:center;"> Robin Williams </td>
   <td style="text-align:center;"> Matt Damon </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0119217/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_103) </td>
  </tr>
<tr>
<td style="text-align:center;"> Jagten </td>
   <td style="text-align:center;"> 2012 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 205435 </td>
   <td style="text-align:center;"> Thomas Vinterberg </td>
   <td style="text-align:center;"> Mads Mikkelsen </td>
   <td style="text-align:center;"> Thomas Bo Larsen </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt2106476/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_104) </td>
  </tr>
<tr>
<td style="text-align:center;"> Per qualche dollaro in più </td>
   <td style="text-align:center;"> 1965 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 179387 </td>
   <td style="text-align:center;"> Sergio Leone </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Lee Van Cleef </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0059578/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_105) </td>
  </tr>
<tr>
<td style="text-align:center;"> L.A. Confidential </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 453246 </td>
   <td style="text-align:center;"> Curtis Hanson </td>
   <td style="text-align:center;"> Kevin Spacey </td>
   <td style="text-align:center;"> Russell Crowe </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0119488/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_106) </td>
  </tr>
<tr>
<td style="text-align:center;"> Scarface </td>
   <td style="text-align:center;"> 1983 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 598469 </td>
   <td style="text-align:center;"> Brian De Palma </td>
   <td style="text-align:center;"> Al Pacino </td>
   <td style="text-align:center;"> Michelle Pfeiffer </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0086250/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_107) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Apartment </td>
   <td style="text-align:center;"> 1960 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 124231 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> Jack Lemmon </td>
   <td style="text-align:center;"> Shirley MacLaine </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0053604/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_108) </td>
  </tr>
<tr>
<td style="text-align:center;"> Metropolis </td>
   <td style="text-align:center;"> 1927 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 125983 </td>
   <td style="text-align:center;"> Fritz Lang </td>
   <td style="text-align:center;"> Brigitte Helm </td>
   <td style="text-align:center;"> Alfred Abel </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0017136/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_109) </td>
  </tr>
<tr>
<td style="text-align:center;"> Jodaeiye Nader az Simin </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 172716 </td>
   <td style="text-align:center;"> Asghar Farhadi </td>
   <td style="text-align:center;"> Payman Maadi </td>
   <td style="text-align:center;"> Leila Hatami </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1832382/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_110) </td>
  </tr>
<tr>
<td style="text-align:center;"> Rashômon </td>
   <td style="text-align:center;"> 1950 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 116303 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Toshirô Mifune </td>
   <td style="text-align:center;"> Machiko Kyô </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0042876/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_111) </td>
  </tr>
<tr>
<td style="text-align:center;"> Indiana Jones and the Last Crusade </td>
   <td style="text-align:center;"> 1989 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 572962 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> Sean Connery </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0097576/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_112) </td>
  </tr>
<tr>
<td style="text-align:center;"> All About Eve </td>
   <td style="text-align:center;"> 1950 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 93502 </td>
   <td style="text-align:center;"> Joseph L. Mankiewicz </td>
   <td style="text-align:center;"> Bette Davis </td>
   <td style="text-align:center;"> Anne Baxter </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0042192/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_113) </td>
  </tr>
<tr>
<td style="text-align:center;"> Yôjinbô </td>
   <td style="text-align:center;"> 1961 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 83397 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Toshirô Mifune </td>
   <td style="text-align:center;"> Eijirô Tôno </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0055630/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_114) </td>
  </tr>
<tr>
<td style="text-align:center;"> Babam ve Oglum </td>
   <td style="text-align:center;"> 2005 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 51502 </td>
   <td style="text-align:center;"> Çagan Irmak </td>
   <td style="text-align:center;"> Resit Kurt </td>
   <td style="text-align:center;"> Fikret Kuskan </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0476735/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_115) </td>
  </tr>
<tr>
<td style="text-align:center;"> Dunkirk </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 250083 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Fionn Whitehead </td>
   <td style="text-align:center;"> Barry Keoghan </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt5013056/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_116) </td>
  </tr>
<tr>
<td style="text-align:center;"> Up </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 753071 </td>
   <td style="text-align:center;"> Pete Docter </td>
   <td style="text-align:center;"> Edward Asner </td>
   <td style="text-align:center;"> Jordan Nagai </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1049413/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_117) </td>
  </tr>
<tr>
<td style="text-align:center;"> Batman Begins </td>
   <td style="text-align:center;"> 2005 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 1087757 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Christian Bale </td>
   <td style="text-align:center;"> Michael Caine </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0372784/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_118) </td>
  </tr>
<tr>
<td style="text-align:center;"> Some Like It Hot </td>
   <td style="text-align:center;"> 1959 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 195660 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> Marilyn Monroe </td>
   <td style="text-align:center;"> Tony Curtis </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0053291/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_119) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Treasure of the Sierra Madre </td>
   <td style="text-align:center;"> 1948 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 88617 </td>
   <td style="text-align:center;"> John Huston </td>
   <td style="text-align:center;"> Humphrey Bogart </td>
   <td style="text-align:center;"> Walter Huston </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0040897/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_120) </td>
  </tr>
<tr>
<td style="text-align:center;"> Unforgiven </td>
   <td style="text-align:center;"> 1992 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 307863 </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Gene Hackman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0105695/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_121) </td>
  </tr>
<tr>
<td style="text-align:center;"> Der Untergang </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 275551 </td>
   <td style="text-align:center;"> Oliver Hirschbiegel </td>
   <td style="text-align:center;"> Bruno Ganz </td>
   <td style="text-align:center;"> Alexandra Maria Lara </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0363163/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_122) </td>
  </tr>
<tr>
<td style="text-align:center;"> Die Hard </td>
   <td style="text-align:center;"> 1988 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 653971 </td>
   <td style="text-align:center;"> John McTiernan </td>
   <td style="text-align:center;"> Bruce Willis </td>
   <td style="text-align:center;"> Alan Rickman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0095016/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_123) </td>
  </tr>
<tr>
<td style="text-align:center;"> Raging Bull </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 259617 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Cathy Moriarty </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0081398/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_124) </td>
  </tr>
<tr>
<td style="text-align:center;"> Heat </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 475439 </td>
   <td style="text-align:center;"> Michael Mann </td>
   <td style="text-align:center;"> Al Pacino </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0113277/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_125) </td>
  </tr>
<tr>
<td style="text-align:center;"> Bacheha-Ye aseman </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 38783 </td>
   <td style="text-align:center;"> Majid Majidi </td>
   <td style="text-align:center;"> Mohammad Amir Naji </td>
   <td style="text-align:center;"> Amir Farrokh Hashemian </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0118849/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_126) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Third Man </td>
   <td style="text-align:center;"> 1949 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 127204 </td>
   <td style="text-align:center;"> Carol Reed </td>
   <td style="text-align:center;"> Orson Welles </td>
   <td style="text-align:center;"> Joseph Cotten </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0041959/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_127) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Great Escape </td>
   <td style="text-align:center;"> 1963 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 183800 </td>
   <td style="text-align:center;"> John Sturges </td>
   <td style="text-align:center;"> Steve McQueen </td>
   <td style="text-align:center;"> James Garner </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0057115/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_128) </td>
  </tr>
<tr>
<td style="text-align:center;"> Ikiru </td>
   <td style="text-align:center;"> 1952 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 48424 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Takashi Shimura </td>
   <td style="text-align:center;"> Nobuo Kaneko </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0044741/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_129) </td>
  </tr>
<tr>
<td style="text-align:center;"> Chinatown </td>
   <td style="text-align:center;"> 1974 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 240072 </td>
   <td style="text-align:center;"> Roman Polanski </td>
   <td style="text-align:center;"> Jack Nicholson </td>
   <td style="text-align:center;"> Faye Dunaway </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0071315/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_130) </td>
  </tr>
<tr>
<td style="text-align:center;"> Pan's Labyrinth </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 518015 </td>
   <td style="text-align:center;"> Guillermo del Toro </td>
   <td style="text-align:center;"> Ivana Baquero </td>
   <td style="text-align:center;"> Ariadna Gil </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0457430/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_131) </td>
  </tr>
<tr>
<td style="text-align:center;"> Tonari no Totoro </td>
   <td style="text-align:center;"> 1988 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 203604 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Hitoshi Takagi </td>
   <td style="text-align:center;"> Noriko Hidaka </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0096283/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_132) </td>
  </tr>
<tr>
<td style="text-align:center;"> Incendies </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 100940 </td>
   <td style="text-align:center;"> Denis Villeneuve </td>
   <td style="text-align:center;"> Lubna Azabal </td>
   <td style="text-align:center;"> Mélissa Désormeaux-Poulin </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1255953/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_133) </td>
  </tr>
<tr>
<td style="text-align:center;"> Ran </td>
   <td style="text-align:center;"> 1985 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 86751 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Tatsuya Nakadai </td>
   <td style="text-align:center;"> Akira Terao </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0089881/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_134) </td>
  </tr>
<tr>
<td style="text-align:center;"> Judgment at Nuremberg </td>
   <td style="text-align:center;"> 1961 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 51586 </td>
   <td style="text-align:center;"> Stanley Kramer </td>
   <td style="text-align:center;"> Spencer Tracy </td>
   <td style="text-align:center;"> Burt Lancaster </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0055031/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_135) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Gold Rush </td>
   <td style="text-align:center;"> 1925 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 77129 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Mack Swain </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0015864/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_136) </td>
  </tr>
<tr>
<td style="text-align:center;"> El secreto de sus ojos </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 152005 </td>
   <td style="text-align:center;"> Juan José Campanella </td>
   <td style="text-align:center;"> Ricardo Darín </td>
   <td style="text-align:center;"> Soledad Villamil </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1305806/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_137) </td>
  </tr>
<tr>
<td style="text-align:center;"> Hauru no ugoku shiro </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 246485 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Chieko Baishô </td>
   <td style="text-align:center;"> Takuya Kimura </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0347149/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_138) </td>
  </tr>
<tr>
<td style="text-align:center;"> Inside Out </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 449528 </td>
   <td style="text-align:center;"> Pete Docter </td>
   <td style="text-align:center;"> Amy Poehler </td>
   <td style="text-align:center;"> Bill Hader </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt2096673/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_139) </td>
  </tr>
<tr>
<td style="text-align:center;"> On the Waterfront </td>
   <td style="text-align:center;"> 1954 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 113124 </td>
   <td style="text-align:center;"> Elia Kazan </td>
   <td style="text-align:center;"> Marlon Brando </td>
   <td style="text-align:center;"> Karl Malden </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0047296/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_140) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Bridge on the River Kwai </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 166261 </td>
   <td style="text-align:center;"> David Lean </td>
   <td style="text-align:center;"> William Holden </td>
   <td style="text-align:center;"> Alec Guinness </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0050212/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_141) </td>
  </tr>
<tr>
<td style="text-align:center;"> Det sjunde inseglet </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 125530 </td>
   <td style="text-align:center;"> Ingmar Bergman </td>
   <td style="text-align:center;"> Max von Sydow </td>
   <td style="text-align:center;"> Gunnar Björnstrand </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0050976/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_142) </td>
  </tr>
<tr>
<td style="text-align:center;"> Room </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 249516 </td>
   <td style="text-align:center;"> Lenny Abrahamson </td>
   <td style="text-align:center;"> Brie Larson </td>
   <td style="text-align:center;"> Jacob Tremblay </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt3170832/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_143) </td>
  </tr>
<tr>
<td style="text-align:center;"> Lock, Stock and Two Smoking Barrels </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 454792 </td>
   <td style="text-align:center;"> Guy Ritchie </td>
   <td style="text-align:center;"> Jason Flemyng </td>
   <td style="text-align:center;"> Dexter Fletcher </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0120735/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_144) </td>
  </tr>
<tr>
<td style="text-align:center;"> Mr. Smith Goes to Washington </td>
   <td style="text-align:center;"> 1939 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 85718 </td>
   <td style="text-align:center;"> Frank Capra </td>
   <td style="text-align:center;"> James Stewart </td>
   <td style="text-align:center;"> Jean Arthur </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0031679/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_145) </td>
  </tr>
<tr>
<td style="text-align:center;"> A Beautiful Mind </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 690837 </td>
   <td style="text-align:center;"> Ron Howard </td>
   <td style="text-align:center;"> Russell Crowe </td>
   <td style="text-align:center;"> Ed Harris </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0268978/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_146) </td>
  </tr>
<tr>
<td style="text-align:center;"> Casino </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 372146 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Sharon Stone </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0112641/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_147) </td>
  </tr>
<tr>
<td style="text-align:center;"> Blade Runner </td>
   <td style="text-align:center;"> 1982 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 547396 </td>
   <td style="text-align:center;"> Ridley Scott </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> Rutger Hauer </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0083658/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_148) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Elephant Man </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 180421 </td>
   <td style="text-align:center;"> David Lynch </td>
   <td style="text-align:center;"> Anthony Hopkins </td>
   <td style="text-align:center;"> John Hurt </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0080678/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_149) </td>
  </tr>
<tr>
<td style="text-align:center;"> V for Vendetta </td>
   <td style="text-align:center;"> 2005 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 876396 </td>
   <td style="text-align:center;"> James McTeigue </td>
   <td style="text-align:center;"> Hugo Weaving </td>
   <td style="text-align:center;"> Natalie Portman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0434409/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_150) </td>
  </tr>
<tr>
<td style="text-align:center;"> Smultronstället </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 71294 </td>
   <td style="text-align:center;"> Ingmar Bergman </td>
   <td style="text-align:center;"> Victor Sjöström </td>
   <td style="text-align:center;"> Bibi Andersson </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0050986/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_151) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Wolf of Wall Street </td>
   <td style="text-align:center;"> 2013 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 909516 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Jonah Hill </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0993846/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_152) </td>
  </tr>
<tr>
<td style="text-align:center;"> The General </td>
   <td style="text-align:center;"> 1926 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 60660 </td>
   <td style="text-align:center;"> Clyde Bruckman </td>
   <td style="text-align:center;"> Buster Keaton </td>
   <td style="text-align:center;"> Marion Mack </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0017925/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_153) </td>
  </tr>
<tr>
<td style="text-align:center;"> Warrior </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 369137 </td>
   <td style="text-align:center;"> Gavin O'Connor </td>
   <td style="text-align:center;"> Tom Hardy </td>
   <td style="text-align:center;"> Nick Nolte </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1291584/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_154) </td>
  </tr>
<tr>
<td style="text-align:center;"> Dial M for Murder </td>
   <td style="text-align:center;"> 1954 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 121929 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> Ray Milland </td>
   <td style="text-align:center;"> Grace Kelly </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0046912/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_155) </td>
  </tr>
<tr>
<td style="text-align:center;"> Trainspotting </td>
   <td style="text-align:center;"> 1996 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 537214 </td>
   <td style="text-align:center;"> Danny Boyle </td>
   <td style="text-align:center;"> Ewan McGregor </td>
   <td style="text-align:center;"> Ewen Bremner </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0117951/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_156) </td>
  </tr>
<tr>
<td style="text-align:center;"> Gran Torino </td>
   <td style="text-align:center;"> 2008 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 616227 </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Bee Vang </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1205489/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_157) </td>
  </tr>
<tr>
<td style="text-align:center;"> Gone with the Wind </td>
   <td style="text-align:center;"> 1939 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 238118 </td>
   <td style="text-align:center;"> Victor Fleming </td>
   <td style="text-align:center;"> Clark Gable </td>
   <td style="text-align:center;"> Vivien Leigh </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0031381/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_158) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Deer Hunter </td>
   <td style="text-align:center;"> 1978 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 257352 </td>
   <td style="text-align:center;"> Michael Cimino </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Christopher Walken </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0077416/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_159) </td>
  </tr>
<tr>
<td style="text-align:center;"> Sunrise: A Song of Two Humans </td>
   <td style="text-align:center;"> 1927 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 34454 </td>
   <td style="text-align:center;"> F.W. Murnau </td>
   <td style="text-align:center;"> George O'Brien </td>
   <td style="text-align:center;"> Janet Gaynor </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0018455/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_160) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Sixth Sense </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 774771 </td>
   <td style="text-align:center;"> M. Night Shyamalan </td>
   <td style="text-align:center;"> Bruce Willis </td>
   <td style="text-align:center;"> Haley Joel Osment </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0167404/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_161) </td>
  </tr>
<tr>
<td style="text-align:center;"> Fargo </td>
   <td style="text-align:center;"> 1996 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 506778 </td>
   <td style="text-align:center;"> Joel Coen </td>
   <td style="text-align:center;"> William H. Macy </td>
   <td style="text-align:center;"> Frances McDormand </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0116282/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_162) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Thing </td>
   <td style="text-align:center;"> 1982 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 292633 </td>
   <td style="text-align:center;"> John Carpenter </td>
   <td style="text-align:center;"> Kurt Russell </td>
   <td style="text-align:center;"> Wilford Brimley </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0084787/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_163) </td>
  </tr>
<tr>
<td style="text-align:center;"> No Country for Old Men </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 688043 </td>
   <td style="text-align:center;"> Ethan Coen </td>
   <td style="text-align:center;"> Tommy Lee Jones </td>
   <td style="text-align:center;"> Javier Bardem </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0477348/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_164) </td>
  </tr>
<tr>
<td style="text-align:center;"> Andrei Rublev </td>
   <td style="text-align:center;"> 1966 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 28907 </td>
   <td style="text-align:center;"> Andrei Tarkovsky </td>
   <td style="text-align:center;"> Anatoliy Solonitsyn </td>
   <td style="text-align:center;"> Ivan Lapikov </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0060107/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_165) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Big Lebowski </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 599849 </td>
   <td style="text-align:center;"> Joel Coen </td>
   <td style="text-align:center;"> Jeff Bridges </td>
   <td style="text-align:center;"> John Goodman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0118715/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_166) </td>
  </tr>
<tr>
<td style="text-align:center;"> Finding Nemo </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 781227 </td>
   <td style="text-align:center;"> Andrew Stanton </td>
   <td style="text-align:center;"> Albert Brooks </td>
   <td style="text-align:center;"> Ellen DeGeneres </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0266543/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_167) </td>
  </tr>
<tr>
<td style="text-align:center;"> Eskiya </td>
   <td style="text-align:center;"> 1996 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 44571 </td>
   <td style="text-align:center;"> Yavuz Turgul </td>
   <td style="text-align:center;"> Sener Sen </td>
   <td style="text-align:center;"> Ugur Yücel </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0116231/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_168) </td>
  </tr>
<tr>
<td style="text-align:center;"> Tôkyô monogatari </td>
   <td style="text-align:center;"> 1953 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 33372 </td>
   <td style="text-align:center;"> Yasujirô Ozu </td>
   <td style="text-align:center;"> Chishû Ryû </td>
   <td style="text-align:center;"> Chieko Higashiyama </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0046438/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_169) </td>
  </tr>
<tr>
<td style="text-align:center;"> There Will Be Blood </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 417750 </td>
   <td style="text-align:center;"> Paul Thomas Anderson </td>
   <td style="text-align:center;"> Daniel Day-Lewis </td>
   <td style="text-align:center;"> Paul Dano </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0469494/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_170) </td>
  </tr>
<tr>
<td style="text-align:center;"> Cool Hand Luke </td>
   <td style="text-align:center;"> 1967 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 132061 </td>
   <td style="text-align:center;"> Stuart Rosenberg </td>
   <td style="text-align:center;"> Paul Newman </td>
   <td style="text-align:center;"> George Kennedy </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0061512/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_171) </td>
  </tr>
<tr>
<td style="text-align:center;"> Idi i smotri </td>
   <td style="text-align:center;"> 1985 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 32926 </td>
   <td style="text-align:center;"> Elem Klimov </td>
   <td style="text-align:center;"> Aleksey Kravchenko </td>
   <td style="text-align:center;"> Olga Mironova </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0091251/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_172) </td>
  </tr>
<tr>
<td style="text-align:center;"> Rebecca </td>
   <td style="text-align:center;"> 1940 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 97698 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> Laurence Olivier </td>
   <td style="text-align:center;"> Joan Fontaine </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0032976/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_173) </td>
  </tr>
<tr>
<td style="text-align:center;"> Hacksaw Ridge </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 279990 </td>
   <td style="text-align:center;"> Mel Gibson </td>
   <td style="text-align:center;"> Andrew Garfield </td>
   <td style="text-align:center;"> Sam Worthington </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt2119532/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_174) </td>
  </tr>
<tr>
<td style="text-align:center;"> Kill Bill: Vol. 1 </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 817037 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> Uma Thurman </td>
   <td style="text-align:center;"> David Carradine </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0266697/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_175) </td>
  </tr>
<tr>
<td style="text-align:center;"> How to Train Your Dragon </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 544952 </td>
   <td style="text-align:center;"> Dean DeBlois </td>
   <td style="text-align:center;"> Jay Baruchel </td>
   <td style="text-align:center;"> Gerard Butler </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0892769/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_176) </td>
  </tr>
<tr>
<td style="text-align:center;"> Rang De Basanti </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 85739 </td>
   <td style="text-align:center;"> Rakeysh Omprakash Mehra </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> Soha Ali Khan </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0405508/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_177) </td>
  </tr>
<tr>
<td style="text-align:center;"> La passion de Jeanne d'Arc </td>
   <td style="text-align:center;"> 1928 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 31196 </td>
   <td style="text-align:center;"> Carl Theodor Dreyer </td>
   <td style="text-align:center;"> Maria Falconetti </td>
   <td style="text-align:center;"> Eugene Silvain </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0019254/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_178) </td>
  </tr>
<tr>
<td style="text-align:center;"> Mary and Max </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 134629 </td>
   <td style="text-align:center;"> Adam Elliot </td>
   <td style="text-align:center;"> Toni Collette </td>
   <td style="text-align:center;"> Philip Seymour Hoffman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0978762/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_179) </td>
  </tr>
<tr>
<td style="text-align:center;"> Gone Girl </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 671307 </td>
   <td style="text-align:center;"> David Fincher </td>
   <td style="text-align:center;"> Ben Affleck </td>
   <td style="text-align:center;"> Rosamund Pike </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt2267998/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_180) </td>
  </tr>
<tr>
<td style="text-align:center;"> Shutter Island </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 896410 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Emily Mortimer </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1130884/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_181) </td>
  </tr>
<tr>
<td style="text-align:center;"> Into the Wild </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 477859 </td>
   <td style="text-align:center;"> Sean Penn </td>
   <td style="text-align:center;"> Emile Hirsch </td>
   <td style="text-align:center;"> Vince Vaughn </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0758758/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_182) </td>
  </tr>
<tr>
<td style="text-align:center;"> La La Land </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 327163 </td>
   <td style="text-align:center;"> Damien Chazelle </td>
   <td style="text-align:center;"> Ryan Gosling </td>
   <td style="text-align:center;"> Emma Stone </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt3783958/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_183) </td>
  </tr>
<tr>
<td style="text-align:center;"> Life of Brian </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 299764 </td>
   <td style="text-align:center;"> Terry Jones </td>
   <td style="text-align:center;"> Graham Chapman </td>
   <td style="text-align:center;"> John Cleese </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0079470/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_184) </td>
  </tr>
<tr>
<td style="text-align:center;"> It Happened One Night </td>
   <td style="text-align:center;"> 1934 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 73331 </td>
   <td style="text-align:center;"> Frank Capra </td>
   <td style="text-align:center;"> Clark Gable </td>
   <td style="text-align:center;"> Claudette Colbert </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0025316/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_185) </td>
  </tr>
<tr>
<td style="text-align:center;"> Relatos salvajes </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 121995 </td>
   <td style="text-align:center;"> Damián Szifron </td>
   <td style="text-align:center;"> Darío Grandinetti </td>
   <td style="text-align:center;"> María Marull </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt3011894/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_186) </td>
  </tr>
<tr>
<td style="text-align:center;"> Logan </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 413045 </td>
   <td style="text-align:center;"> James Mangold </td>
   <td style="text-align:center;"> Hugh Jackman </td>
   <td style="text-align:center;"> Patrick Stewart </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt3315342/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_187) </td>
  </tr>
<tr>
<td style="text-align:center;"> Platoon </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 320832 </td>
   <td style="text-align:center;"> Oliver Stone </td>
   <td style="text-align:center;"> Charlie Sheen </td>
   <td style="text-align:center;"> Tom Berenger </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0091763/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_188) </td>
  </tr>
<tr>
<td style="text-align:center;"> Le salaire de la peur </td>
   <td style="text-align:center;"> 1953 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 40237 </td>
   <td style="text-align:center;"> Henri-Georges Clouzot </td>
   <td style="text-align:center;"> Yves Montand </td>
   <td style="text-align:center;"> Charles Vanel </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0046268/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_189) </td>
  </tr>
<tr>
<td style="text-align:center;"> Hotel Rwanda </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 289257 </td>
   <td style="text-align:center;"> Terry George </td>
   <td style="text-align:center;"> Don Cheadle </td>
   <td style="text-align:center;"> Sophie Okonedo </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0395169/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_190) </td>
  </tr>
<tr>
<td style="text-align:center;"> Network </td>
   <td style="text-align:center;"> 1976 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 116019 </td>
   <td style="text-align:center;"> Sidney Lumet </td>
   <td style="text-align:center;"> Faye Dunaway </td>
   <td style="text-align:center;"> William Holden </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0074958/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_191) </td>
  </tr>
<tr>
<td style="text-align:center;"> In the Name of the Father </td>
   <td style="text-align:center;"> 1993 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 124772 </td>
   <td style="text-align:center;"> Jim Sheridan </td>
   <td style="text-align:center;"> Daniel Day-Lewis </td>
   <td style="text-align:center;"> Pete Postlethwaite </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0107207/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_192) </td>
  </tr>
<tr>
<td style="text-align:center;"> Stand by Me </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 302911 </td>
   <td style="text-align:center;"> Rob Reiner </td>
   <td style="text-align:center;"> Wil Wheaton </td>
   <td style="text-align:center;"> River Phoenix </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0092005/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_193) </td>
  </tr>
<tr>
<td style="text-align:center;"> Rush </td>
   <td style="text-align:center;"> 2013 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 354749 </td>
   <td style="text-align:center;"> Ron Howard </td>
   <td style="text-align:center;"> Daniel Brühl </td>
   <td style="text-align:center;"> Chris Hemsworth </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1979320/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_194) </td>
  </tr>
<tr>
<td style="text-align:center;"> A Wednesday </td>
   <td style="text-align:center;"> 2008 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 55979 </td>
   <td style="text-align:center;"> Neeraj Pandey </td>
   <td style="text-align:center;"> Anupam Kher </td>
   <td style="text-align:center;"> Naseeruddin Shah </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1280558/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_195) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Grand Budapest Hotel </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 559544 </td>
   <td style="text-align:center;"> Wes Anderson </td>
   <td style="text-align:center;"> Ralph Fiennes </td>
   <td style="text-align:center;"> F. Murray Abraham </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt2278388/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_196) </td>
  </tr>
<tr>
<td style="text-align:center;"> Ben-Hur </td>
   <td style="text-align:center;"> 1959 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 180395 </td>
   <td style="text-align:center;"> William Wyler </td>
   <td style="text-align:center;"> Charlton Heston </td>
   <td style="text-align:center;"> Jack Hawkins </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0052618/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_197) </td>
  </tr>
<tr>
<td style="text-align:center;"> Persona </td>
   <td style="text-align:center;"> 1966 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 72114 </td>
   <td style="text-align:center;"> Ingmar Bergman </td>
   <td style="text-align:center;"> Bibi Andersson </td>
   <td style="text-align:center;"> Liv Ullmann </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0060827/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_198) </td>
  </tr>
<tr>
<td style="text-align:center;"> Thor: Ragnarok </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 161371 </td>
   <td style="text-align:center;"> Taika Waititi </td>
   <td style="text-align:center;"> Chris Hemsworth </td>
   <td style="text-align:center;"> Tom Hiddleston </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt3501632/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_199) </td>
  </tr>
<tr>
<td style="text-align:center;"> Les quatre cents coups </td>
   <td style="text-align:center;"> 1959 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 79561 </td>
   <td style="text-align:center;"> François Truffaut </td>
   <td style="text-align:center;"> Jean-Pierre Léaud </td>
   <td style="text-align:center;"> Albert Rémy </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0053198/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_200) </td>
  </tr>
<tr>
<td style="text-align:center;"> Jurassic Park </td>
   <td style="text-align:center;"> 1993 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 694340 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Sam Neill </td>
   <td style="text-align:center;"> Laura Dern </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0107290/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_201) </td>
  </tr>
<tr>
<td style="text-align:center;"> Salinui chueok </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 82135 </td>
   <td style="text-align:center;"> Joon-ho Bong </td>
   <td style="text-align:center;"> Kang-ho Song </td>
   <td style="text-align:center;"> Sang-kyung Kim </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0353969/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_202) </td>
  </tr>
<tr>
<td style="text-align:center;"> 12 Years a Slave </td>
   <td style="text-align:center;"> 2013 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 511727 </td>
   <td style="text-align:center;"> Steve McQueen </td>
   <td style="text-align:center;"> Chiwetel Ejiofor </td>
   <td style="text-align:center;"> Michael Kenneth Williams </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt2024544/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_203) </td>
  </tr>
<tr>
<td style="text-align:center;"> Mad Max: Fury Road </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 674670 </td>
   <td style="text-align:center;"> George Miller </td>
   <td style="text-align:center;"> Tom Hardy </td>
   <td style="text-align:center;"> Charlize Theron </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1392190/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_204) </td>
  </tr>
<tr>
<td style="text-align:center;"> Million Dollar Baby </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 534738 </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Hilary Swank </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0405159/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_205) </td>
  </tr>
<tr>
<td style="text-align:center;"> Spotlight </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 295912 </td>
   <td style="text-align:center;"> Tom McCarthy </td>
   <td style="text-align:center;"> Mark Ruffalo </td>
   <td style="text-align:center;"> Michael Keaton </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1895587/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_206) </td>
  </tr>
<tr>
<td style="text-align:center;"> Stalker </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 80744 </td>
   <td style="text-align:center;"> Andrei Tarkovsky </td>
   <td style="text-align:center;"> Alisa Freyndlikh </td>
   <td style="text-align:center;"> Aleksandr Kaydanovskiy </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0079944/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_207) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Truman Show </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 750764 </td>
   <td style="text-align:center;"> Peter Weir </td>
   <td style="text-align:center;"> Jim Carrey </td>
   <td style="text-align:center;"> Ed Harris </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0120382/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_208) </td>
  </tr>
<tr>
<td style="text-align:center;"> Amores perros </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 189755 </td>
   <td style="text-align:center;"> Alejandro González Iñárritu </td>
   <td style="text-align:center;"> Emilio Echevarría </td>
   <td style="text-align:center;"> Gael García Bernal </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0245712/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_209) </td>
  </tr>
<tr>
<td style="text-align:center;"> Butch Cassidy and the Sundance Kid </td>
   <td style="text-align:center;"> 1969 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 168488 </td>
   <td style="text-align:center;"> George Roy Hill </td>
   <td style="text-align:center;"> Paul Newman </td>
   <td style="text-align:center;"> Robert Redford </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0064115/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_210) </td>
  </tr>
<tr>
<td style="text-align:center;"> Hachi: A Dog's Tale </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 190159 </td>
   <td style="text-align:center;"> Lasse Hallström </td>
   <td style="text-align:center;"> Richard Gere </td>
   <td style="text-align:center;"> Joan Allen </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1028532/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_211) </td>
  </tr>
<tr>
<td style="text-align:center;"> Kaze no tani no Naushika </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 110814 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Sumi Shimamoto </td>
   <td style="text-align:center;"> Mahito Tsujimura </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0087544/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_212) </td>
  </tr>
<tr>
<td style="text-align:center;"> Before Sunrise </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 210246 </td>
   <td style="text-align:center;"> Richard Linklater </td>
   <td style="text-align:center;"> Ethan Hawke </td>
   <td style="text-align:center;"> Julie Delpy </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0112471/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_213) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Princess Bride </td>
   <td style="text-align:center;"> 1987 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 324850 </td>
   <td style="text-align:center;"> Rob Reiner </td>
   <td style="text-align:center;"> Cary Elwes </td>
   <td style="text-align:center;"> Mandy Patinkin </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0093779/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_214) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Maltese Falcon </td>
   <td style="text-align:center;"> 1941 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 125499 </td>
   <td style="text-align:center;"> John Huston </td>
   <td style="text-align:center;"> Humphrey Bogart </td>
   <td style="text-align:center;"> Mary Astor </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0033870/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_215) </td>
  </tr>
<tr>
<td style="text-align:center;"> Paper Moon </td>
   <td style="text-align:center;"> 1973 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 27608 </td>
   <td style="text-align:center;"> Peter Bogdanovich </td>
   <td style="text-align:center;"> Ryan O'Neal </td>
   <td style="text-align:center;"> Tatum O'Neal </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0070510/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_216) </td>
  </tr>
<tr>
<td style="text-align:center;"> Prisoners </td>
   <td style="text-align:center;"> 2013 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 459178 </td>
   <td style="text-align:center;"> Denis Villeneuve </td>
   <td style="text-align:center;"> Hugh Jackman </td>
   <td style="text-align:center;"> Jake Gyllenhaal </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1392214/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_217) </td>
  </tr>
<tr>
<td style="text-align:center;"> Le notti di Cabiria </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 30795 </td>
   <td style="text-align:center;"> Federico Fellini </td>
   <td style="text-align:center;"> Giulietta Masina </td>
   <td style="text-align:center;"> François Périer </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0050783/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_218) </td>
  </tr>
<tr>
<td style="text-align:center;"> Harry Potter and the Deathly Hallows: Part 2 </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 617139 </td>
   <td style="text-align:center;"> David Yates </td>
   <td style="text-align:center;"> Daniel Radcliffe </td>
   <td style="text-align:center;"> Emma Watson </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1201607/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_219) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Grapes of Wrath </td>
   <td style="text-align:center;"> 1940 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 70497 </td>
   <td style="text-align:center;"> John Ford </td>
   <td style="text-align:center;"> Henry Fonda </td>
   <td style="text-align:center;"> Jane Darwell </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0032551/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_220) </td>
  </tr>
<tr>
<td style="text-align:center;"> Catch Me If You Can </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 622618 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0264464/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_221) </td>
  </tr>
<tr>
<td style="text-align:center;"> Rocky </td>
   <td style="text-align:center;"> 1976 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 423369 </td>
   <td style="text-align:center;"> John G. Avildsen </td>
   <td style="text-align:center;"> Sylvester Stallone </td>
   <td style="text-align:center;"> Talia Shire </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0075148/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_222) </td>
  </tr>
<tr>
<td style="text-align:center;"> Les diaboliques </td>
   <td style="text-align:center;"> 1955 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 47797 </td>
   <td style="text-align:center;"> Henri-Georges Clouzot </td>
   <td style="text-align:center;"> Simone Signoret </td>
   <td style="text-align:center;"> Véra Clouzot </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0046911/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_223) </td>
  </tr>
<tr>
<td style="text-align:center;"> Touch of Evil </td>
   <td style="text-align:center;"> 1958 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 80653 </td>
   <td style="text-align:center;"> Orson Welles </td>
   <td style="text-align:center;"> Charlton Heston </td>
   <td style="text-align:center;"> Orson Welles </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0052311/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_224) </td>
  </tr>
<tr>
<td style="text-align:center;"> Monsters, Inc. </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 660446 </td>
   <td style="text-align:center;"> Pete Docter </td>
   <td style="text-align:center;"> Billy Crystal </td>
   <td style="text-align:center;"> John Goodman </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0198781/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_225) </td>
  </tr>
<tr>
<td style="text-align:center;"> Gandhi </td>
   <td style="text-align:center;"> 1982 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 189292 </td>
   <td style="text-align:center;"> Richard Attenborough </td>
   <td style="text-align:center;"> Ben Kingsley </td>
   <td style="text-align:center;"> John Gielgud </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0083987/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_226) </td>
  </tr>
<tr>
<td style="text-align:center;"> Donnie Darko </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 642856 </td>
   <td style="text-align:center;"> Richard Kelly </td>
   <td style="text-align:center;"> Jake Gyllenhaal </td>
   <td style="text-align:center;"> Jena Malone </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0246578/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_227) </td>
  </tr>
<tr>
<td style="text-align:center;"> Barry Lyndon </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 114451 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Ryan O'Neal </td>
   <td style="text-align:center;"> Marisa Berenson </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0072684/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_228) </td>
  </tr>
<tr>
<td style="text-align:center;"> Annie Hall </td>
   <td style="text-align:center;"> 1977 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 216749 </td>
   <td style="text-align:center;"> Woody Allen </td>
   <td style="text-align:center;"> Woody Allen </td>
   <td style="text-align:center;"> Diane Keaton </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0075686/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_229) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Terminator </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 664489 </td>
   <td style="text-align:center;"> James Cameron </td>
   <td style="text-align:center;"> Arnold Schwarzenegger </td>
   <td style="text-align:center;"> Linda Hamilton </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0088247/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_230) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Bourne Ultimatum </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 542478 </td>
   <td style="text-align:center;"> Paul Greengrass </td>
   <td style="text-align:center;"> Matt Damon </td>
   <td style="text-align:center;"> Edgar Ramírez </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0440963/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_231) </td>
  </tr>
<tr>
<td style="text-align:center;"> Star Wars: Episode VII - The Force Awakens </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 699766 </td>
   <td style="text-align:center;"> J.J. Abrams </td>
   <td style="text-align:center;"> Daisy Ridley </td>
   <td style="text-align:center;"> John Boyega </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt2488496/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_232) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Wizard of Oz </td>
   <td style="text-align:center;"> 1939 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 320502 </td>
   <td style="text-align:center;"> Victor Fleming </td>
   <td style="text-align:center;"> Judy Garland </td>
   <td style="text-align:center;"> Frank Morgan </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0032138/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_233) </td>
  </tr>
<tr>
<td style="text-align:center;"> Groundhog Day </td>
   <td style="text-align:center;"> 1993 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 489669 </td>
   <td style="text-align:center;"> Harold Ramis </td>
   <td style="text-align:center;"> Bill Murray </td>
   <td style="text-align:center;"> Andie MacDowell </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0107048/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_234) </td>
  </tr>
<tr>
<td style="text-align:center;"> La haine </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 117063 </td>
   <td style="text-align:center;"> Mathieu Kassovitz </td>
   <td style="text-align:center;"> Vincent Cassel </td>
   <td style="text-align:center;"> Hubert Koundé </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0113247/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_235) </td>
  </tr>
<tr>
<td style="text-align:center;"> 8½ </td>
   <td style="text-align:center;"> 1963 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 87867 </td>
   <td style="text-align:center;"> Federico Fellini </td>
   <td style="text-align:center;"> Marcello Mastroianni </td>
   <td style="text-align:center;"> Anouk Aimée </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0056801/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_236) </td>
  </tr>
<tr>
<td style="text-align:center;"> Munna Bhai M.B.B.S. </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 56083 </td>
   <td style="text-align:center;"> Rajkumar Hirani </td>
   <td style="text-align:center;"> Sunil Dutt </td>
   <td style="text-align:center;"> Sanjay Dutt </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0374887/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_237) </td>
  </tr>
<tr>
<td style="text-align:center;"> Jaws </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 460601 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Roy Scheider </td>
   <td style="text-align:center;"> Robert Shaw </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0073195/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_238) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Best Years of Our Lives </td>
   <td style="text-align:center;"> 1946 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 45103 </td>
   <td style="text-align:center;"> William Wyler </td>
   <td style="text-align:center;"> Myrna Loy </td>
   <td style="text-align:center;"> Dana Andrews </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0036868/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_239) </td>
  </tr>
<tr>
<td style="text-align:center;"> Twelve Monkeys </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 505252 </td>
   <td style="text-align:center;"> Terry Gilliam </td>
   <td style="text-align:center;"> Bruce Willis </td>
   <td style="text-align:center;"> Madeleine Stowe </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0114746/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_240) </td>
  </tr>
<tr>
<td style="text-align:center;"> Mou gaan dou </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 101489 </td>
   <td style="text-align:center;"> Wai-Keung Lau </td>
   <td style="text-align:center;"> Andy Lau </td>
   <td style="text-align:center;"> Tony Chiu-Wai Leung </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0338564/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_241) </td>
  </tr>
<tr>
<td style="text-align:center;"> Faa yeung nin wa </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 88649 </td>
   <td style="text-align:center;"> Kar-Wai Wong </td>
   <td style="text-align:center;"> Tony Chiu-Wai Leung </td>
   <td style="text-align:center;"> Maggie Cheung </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0118694/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_242) </td>
  </tr>
<tr>
<td style="text-align:center;"> Paris, Texas </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 59315 </td>
   <td style="text-align:center;"> Wim Wenders </td>
   <td style="text-align:center;"> Harry Dean Stanton </td>
   <td style="text-align:center;"> Nastassja Kinski </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0087884/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_243) </td>
  </tr>
<tr>
<td style="text-align:center;"> The Help </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 355110 </td>
   <td style="text-align:center;"> Tate Taylor </td>
   <td style="text-align:center;"> Emma Stone </td>
   <td style="text-align:center;"> Viola Davis </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt1454029/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_244) </td>
  </tr>
<tr>
<td style="text-align:center;"> Dead Poets Society </td>
   <td style="text-align:center;"> 1989 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 309589 </td>
   <td style="text-align:center;"> Peter Weir </td>
   <td style="text-align:center;"> Robin Williams </td>
   <td style="text-align:center;"> Robert Sean Leonard </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0097165/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_245) </td>
  </tr>
<tr>
<td style="text-align:center;"> Beauty and the Beast </td>
   <td style="text-align:center;"> 1991 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 349959 </td>
   <td style="text-align:center;"> Gary Trousdale </td>
   <td style="text-align:center;"> Paige O'Hara </td>
   <td style="text-align:center;"> Robby Benson </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0101414/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_246) </td>
  </tr>
<tr>
<td style="text-align:center;"> Ah-ga-ssi </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 48572 </td>
   <td style="text-align:center;"> Chan-wook Park </td>
   <td style="text-align:center;"> Min-hee Kim </td>
   <td style="text-align:center;"> Jung-woo Ha </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt4016934/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_247) </td>
  </tr>
<tr>
<td style="text-align:center;"> La battaglia di Algeri </td>
   <td style="text-align:center;"> 1966 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 42866 </td>
   <td style="text-align:center;"> Gillo Pontecorvo </td>
   <td style="text-align:center;"> Brahim Hadjadj </td>
   <td style="text-align:center;"> Jean Martin </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0058946/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_248) </td>
  </tr>
<tr>
<td style="text-align:center;"> Pirates of the Caribbean: The Curse of the Black Pearl </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 895466 </td>
   <td style="text-align:center;"> Gore Verbinski </td>
   <td style="text-align:center;"> Johnny Depp </td>
   <td style="text-align:center;"> Geoffrey Rush </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0325980/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_249) </td>
  </tr>
<tr>
<td style="text-align:center;"> Dog Day Afternoon </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 201501 </td>
   <td style="text-align:center;"> Sidney Lumet </td>
   <td style="text-align:center;"> Al Pacino </td>
   <td style="text-align:center;"> John Cazale </td>
   <td style="text-align:center;"> [Movie URL](http://www.imdb.com/title/tt0072890/?pf_rd_m=A2FGELUUNOQJNL&amp;pf_rd_p=3376940102&amp;pf_rd_r=0NHEA45RAJ2SN6RB7A72&amp;pf_rd_s=center-1&amp;pf_rd_t=15506&amp;pf_rd_i=top&amp;ref_=chttp_tt_250) </td>
  </tr>
</tbody>
<tfoot>
<tr>
<td style = 'padding: 0; border:0;' colspan='100%'><sup>a</sup> no.Votes = Number of imdb user ratings</td>
</tr>
<tr>
<td style = 'padding: 0; border:0;' colspan='100%'><sup>b</sup> movieURL = Hyperlink to imdb movie homepage</td>
</tr>
</tfoot>
</table></div>

```r
## Save data
write.table(imdb_df2, "./data/imdb_top250movies_summary.tsv",
            quote = FALSE, sep = "\t", row.names = FALSE)
```

### Analyze datase

*Quick look at the correlation between release year and rating.*

<img src="media/yearRelease_hist.png" align = "middle">

<p>
<img src="media/yearRelease_rating.png" width="50%" height="50%" align = "left">
<img src="media/rating_noVotes.png" width="50%" height="50%" align = "right">
</p>


### Get data from links
Creating dataframe 2 to look at:

 - Duration
 
 - Genre
 
 - Plot summary
 
 - Credit summary??


```r
suppressMessages(source('rScripts/02_scrapeData.r'))
```


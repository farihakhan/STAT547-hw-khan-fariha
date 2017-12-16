HW10 Scraping data - IMDb Top 250 Rate Movies
================
Fariha Khan
2017-12-07

``` r
## Load packages
suppressPackageStartupMessages(library(tidyverse)) 
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(kableExtra))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(rvest))
```

### Get data from web

I wrote my code in an R script to make the markdown cleaner to view. The rScript for the first part is found [here]()

``` r
suppressMessages(source('rScripts/01_scrapeData.r'))
```

#### View data structure

###### View [html\_structure](https://github.com/farihakhan/STAT547-hw-khan-fariha/blob/master/hw_10/html_structure.md)

``` r
imdb
```

    ## {xml_document}
    ## <html xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml">
    ## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset= ...
    ## [2] <body id="styleguide-v2" class="fixed">\n<script>\n    if (typeof ue ...

``` r
imdb %>%
      html_nodes(".titleColumn") %>% 
      html_text() %>%
      head()
```

    ## [1] "\n      1.\n      The Shawshank Redemption\n        (1994)\n    "
    ## [2] "\n      2.\n      The Godfather\n        (1972)\n    "           
    ## [3] "\n      3.\n      The Godfather: Part II\n        (1974)\n    "  
    ## [4] "\n      4.\n      The Dark Knight\n        (2008)\n    "         
    ## [5] "\n      5.\n      12 Angry Men\n        (1957)\n    "            
    ## [6] "\n      6.\n      Schindler's List\n        (1993)\n    "

### Extract and structure data:

I stored each column variable into character lists. I changed some of the data types of the variables to allow analysis.

The extracted variables are:

-   Title

-   Year released

-   Rating

-   Number of IMDb user votes

-   Brief cast info

-   Link associated with each movie

### Create summary dataframe

``` r
imdb_df <- extractFields(imdb)
imdb_df %>% glimpse()
```

    ## Observations: 250
    ## Variables: 6
    ## $ Title       <fctr> The Shawshank Redemption, The Godfather, The Godf...
    ## $ yearRelease <dbl> 1994, 1972, 1974, 2008, 1957, 1993, 1994, 2003, 19...
    ## $ Rating      <dbl> 9.2, 9.2, 9.0, 9.0, 8.9, 8.9, 8.9, 8.9, 8.8, 8.8, ...
    ## $ Cast        <fctr> Frank Darabont (dir.), Tim Robbins, Morgan Freema...
    ## $ Votes       <fctr> 9.2 based on 1,886,841 user ratings, 9.2 based on...
    ## $ Link        <chr> "http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FG...

### Clean dataset

> See rScript for more

``` r
imdb_df2 %>% 
      select(Title, yearRelease, Rating,
             no.Votes, Director, Cast1,
             Cast2, Link) %>% 
      head(25) %>% 
      kable("html", align = "c", padding = 1,
            caption = "imdb Top 250 Rated movies") %>% 
      kable_styling(bootstrap_options = c("striped", "condensed"), 
                    full_width = F, font_size = 9)
```

<table class="table table-striped table-condensed" style="font-size: 9px; width: auto !important; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">
imdb Top 250 Rated movies
</caption>
<thead>
<tr>
<th style="text-align:center;">
Title
</th>
<th style="text-align:center;">
yearRelease
</th>
<th style="text-align:center;">
Rating
</th>
<th style="text-align:center;">
no.Votes
</th>
<th style="text-align:center;">
Director
</th>
<th style="text-align:center;">
Cast1
</th>
<th style="text-align:center;">
Cast2
</th>
<th style="text-align:center;">
Link
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
The Shawshank Redemption
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
9.2
</td>
<td style="text-align:center;">
1886841
</td>
<td style="text-align:center;">
Frank Darabont
</td>
<td style="text-align:center;">
Tim Robbins
</td>
<td style="text-align:center;">
Morgan Freeman
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_1>
</td>
</tr>
<tr>
<td style="text-align:center;">
The Godfather
</td>
<td style="text-align:center;">
1972
</td>
<td style="text-align:center;">
9.2
</td>
<td style="text-align:center;">
1288277
</td>
<td style="text-align:center;">
Francis Ford Coppola
</td>
<td style="text-align:center;">
Marlon Brando
</td>
<td style="text-align:center;">
Al Pacino
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0068646/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_2>
</td>
</tr>
<tr>
<td style="text-align:center;">
The Godfather: Part II
</td>
<td style="text-align:center;">
1974
</td>
<td style="text-align:center;">
9.0
</td>
<td style="text-align:center;">
888732
</td>
<td style="text-align:center;">
Francis Ford Coppola
</td>
<td style="text-align:center;">
Al Pacino
</td>
<td style="text-align:center;">
Robert De Niro
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0071562/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_3>
</td>
</tr>
<tr>
<td style="text-align:center;">
The Dark Knight
</td>
<td style="text-align:center;">
2008
</td>
<td style="text-align:center;">
9.0
</td>
<td style="text-align:center;">
1862637
</td>
<td style="text-align:center;">
Christopher Nolan
</td>
<td style="text-align:center;">
Christian Bale
</td>
<td style="text-align:center;">
Heath Ledger
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0468569/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_4>
</td>
</tr>
<tr>
<td style="text-align:center;">
12 Angry Men
</td>
<td style="text-align:center;">
1957
</td>
<td style="text-align:center;">
8.9
</td>
<td style="text-align:center;">
517893
</td>
<td style="text-align:center;">
Sidney Lumet
</td>
<td style="text-align:center;">
Henry Fonda
</td>
<td style="text-align:center;">
Lee J. Cobb
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0050083/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_5>
</td>
</tr>
<tr>
<td style="text-align:center;">
Schindler's List
</td>
<td style="text-align:center;">
1993
</td>
<td style="text-align:center;">
8.9
</td>
<td style="text-align:center;">
970201
</td>
<td style="text-align:center;">
Steven Spielberg
</td>
<td style="text-align:center;">
Liam Neeson
</td>
<td style="text-align:center;">
Ralph Fiennes
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0108052/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_6>
</td>
</tr>
<tr>
<td style="text-align:center;">
Pulp Fiction
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
8.9
</td>
<td style="text-align:center;">
1475884
</td>
<td style="text-align:center;">
Quentin Tarantino
</td>
<td style="text-align:center;">
John Travolta
</td>
<td style="text-align:center;">
Uma Thurman
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0110912/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_7>
</td>
</tr>
<tr>
<td style="text-align:center;">
The Lord of the Rings: The Return of the King
</td>
<td style="text-align:center;">
2003
</td>
<td style="text-align:center;">
8.9
</td>
<td style="text-align:center;">
1348236
</td>
<td style="text-align:center;">
Peter Jackson
</td>
<td style="text-align:center;">
Elijah Wood
</td>
<td style="text-align:center;">
Viggo Mortensen
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0167260/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_8>
</td>
</tr>
<tr>
<td style="text-align:center;">
Il buono, il brutto, il cattivo
</td>
<td style="text-align:center;">
1966
</td>
<td style="text-align:center;">
8.8
</td>
<td style="text-align:center;">
558964
</td>
<td style="text-align:center;">
Sergio Leone
</td>
<td style="text-align:center;">
Clint Eastwood
</td>
<td style="text-align:center;">
Eli Wallach
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0060196/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_9>
</td>
</tr>
<tr>
<td style="text-align:center;">
Fight Club
</td>
<td style="text-align:center;">
1999
</td>
<td style="text-align:center;">
8.8
</td>
<td style="text-align:center;">
1512266
</td>
<td style="text-align:center;">
David Fincher
</td>
<td style="text-align:center;">
Brad Pitt
</td>
<td style="text-align:center;">
Edward Norton
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0137523/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_10>
</td>
</tr>
<tr>
<td style="text-align:center;">
The Lord of the Rings: The Fellowship of the Ring
</td>
<td style="text-align:center;">
2001
</td>
<td style="text-align:center;">
8.8
</td>
<td style="text-align:center;">
1368396
</td>
<td style="text-align:center;">
Peter Jackson
</td>
<td style="text-align:center;">
Elijah Wood
</td>
<td style="text-align:center;">
Ian McKellen
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0120737/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_11>
</td>
</tr>
<tr>
<td style="text-align:center;">
Forrest Gump
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
1424034
</td>
<td style="text-align:center;">
Robert Zemeckis
</td>
<td style="text-align:center;">
Tom Hanks
</td>
<td style="text-align:center;">
Robin Wright
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0109830/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_12>
</td>
</tr>
<tr>
<td style="text-align:center;">
Star Wars: Episode V - The Empire Strikes Back
</td>
<td style="text-align:center;">
1980
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
942645
</td>
<td style="text-align:center;">
Irvin Kershner
</td>
<td style="text-align:center;">
Mark Hamill
</td>
<td style="text-align:center;">
Harrison Ford
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0080684/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_13>
</td>
</tr>
<tr>
<td style="text-align:center;">
Inception
</td>
<td style="text-align:center;">
2010
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
1651480
</td>
<td style="text-align:center;">
Christopher Nolan
</td>
<td style="text-align:center;">
Leonardo DiCaprio
</td>
<td style="text-align:center;">
Joseph Gordon-Levitt
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt1375666/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_14>
</td>
</tr>
<tr>
<td style="text-align:center;">
The Lord of the Rings: The Two Towers
</td>
<td style="text-align:center;">
2002
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
1220325
</td>
<td style="text-align:center;">
Peter Jackson
</td>
<td style="text-align:center;">
Elijah Wood
</td>
<td style="text-align:center;">
Ian McKellen
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0167261/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_15>
</td>
</tr>
<tr>
<td style="text-align:center;">
One Flew Over the Cuckoo's Nest
</td>
<td style="text-align:center;">
1975
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
753245
</td>
<td style="text-align:center;">
Milos Forman
</td>
<td style="text-align:center;">
Jack Nicholson
</td>
<td style="text-align:center;">
Louise Fletcher
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0073486/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_16>
</td>
</tr>
<tr>
<td style="text-align:center;">
Goodfellas
</td>
<td style="text-align:center;">
1990
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
813028
</td>
<td style="text-align:center;">
Martin Scorsese
</td>
<td style="text-align:center;">
Robert De Niro
</td>
<td style="text-align:center;">
Ray Liotta
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0099685/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_17>
</td>
</tr>
<tr>
<td style="text-align:center;">
The Matrix
</td>
<td style="text-align:center;">
1999
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
1357321
</td>
<td style="text-align:center;">
Lana Wachowski
</td>
<td style="text-align:center;">
Keanu Reeves
</td>
<td style="text-align:center;">
Laurence Fishburne
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0133093/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_18>
</td>
</tr>
<tr>
<td style="text-align:center;">
Shichinin no samurai
</td>
<td style="text-align:center;">
1954
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
254243
</td>
<td style="text-align:center;">
Akira Kurosawa
</td>
<td style="text-align:center;">
Toshirô Mifune
</td>
<td style="text-align:center;">
Takashi Shimura
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0047478/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_19>
</td>
</tr>
<tr>
<td style="text-align:center;">
Star Wars
</td>
<td style="text-align:center;">
1977
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
1014901
</td>
<td style="text-align:center;">
George Lucas
</td>
<td style="text-align:center;">
Mark Hamill
</td>
<td style="text-align:center;">
Harrison Ford
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0076759/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_20>
</td>
</tr>
<tr>
<td style="text-align:center;">
Cidade de Deus
</td>
<td style="text-align:center;">
2002
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
587273
</td>
<td style="text-align:center;">
Fernando Meirelles
</td>
<td style="text-align:center;">
Alexandre Rodrigues
</td>
<td style="text-align:center;">
Leandro Firmino
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0317248/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_21>
</td>
</tr>
<tr>
<td style="text-align:center;">
Se7en
</td>
<td style="text-align:center;">
1995
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
1150670
</td>
<td style="text-align:center;">
David Fincher
</td>
<td style="text-align:center;">
Morgan Freeman
</td>
<td style="text-align:center;">
Brad Pitt
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0114369/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_22>
</td>
</tr>
<tr>
<td style="text-align:center;">
The Silence of the Lambs
</td>
<td style="text-align:center;">
1991
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
1004835
</td>
<td style="text-align:center;">
Jonathan Demme
</td>
<td style="text-align:center;">
Jodie Foster
</td>
<td style="text-align:center;">
Anthony Hopkins
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0102926/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_23>
</td>
</tr>
<tr>
<td style="text-align:center;">
It's a Wonderful Life
</td>
<td style="text-align:center;">
1946
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
312318
</td>
<td style="text-align:center;">
Frank Capra
</td>
<td style="text-align:center;">
James Stewart
</td>
<td style="text-align:center;">
Donna Reed
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0038650/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_24>
</td>
</tr>
<tr>
<td style="text-align:center;">
La vita è bella
</td>
<td style="text-align:center;">
1997
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
484303
</td>
<td style="text-align:center;">
Roberto Benigni
</td>
<td style="text-align:center;">
Roberto Benigni
</td>
<td style="text-align:center;">
Nicoletta Braschi
</td>
<td style="text-align:center;">
<http://www.imdb.com/title/tt0118799/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0C7PX6YBWCF8VTETGHHA&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_25>
</td>
</tr>
</tbody>
</table>
``` r
## Look at cast members
imdb_df2 %>% 
      select(Title:Rating, no.Votes:Cast2) %>% 
      head(25) %>% 
      kable("html", align = "c", padding = 1,
            caption = "IMDb Top 250 Rated") %>% 
      kable_styling(bootstrap_options = c("striped", "condensed"), 
                    full_width = F, font_size = 9)
```

<table class="table table-striped table-condensed" style="font-size: 9px; width: auto !important; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">
IMDb Top 250 Rated
</caption>
<thead>
<tr>
<th style="text-align:center;">
Title
</th>
<th style="text-align:center;">
yearRelease
</th>
<th style="text-align:center;">
Rating
</th>
<th style="text-align:center;">
no.Votes
</th>
<th style="text-align:center;">
Director
</th>
<th style="text-align:center;">
Cast1
</th>
<th style="text-align:center;">
Cast2
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
The Shawshank Redemption
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
9.2
</td>
<td style="text-align:center;">
1886841
</td>
<td style="text-align:center;">
Frank Darabont
</td>
<td style="text-align:center;">
Tim Robbins
</td>
<td style="text-align:center;">
Morgan Freeman
</td>
</tr>
<tr>
<td style="text-align:center;">
The Godfather
</td>
<td style="text-align:center;">
1972
</td>
<td style="text-align:center;">
9.2
</td>
<td style="text-align:center;">
1288277
</td>
<td style="text-align:center;">
Francis Ford Coppola
</td>
<td style="text-align:center;">
Marlon Brando
</td>
<td style="text-align:center;">
Al Pacino
</td>
</tr>
<tr>
<td style="text-align:center;">
The Godfather: Part II
</td>
<td style="text-align:center;">
1974
</td>
<td style="text-align:center;">
9.0
</td>
<td style="text-align:center;">
888732
</td>
<td style="text-align:center;">
Francis Ford Coppola
</td>
<td style="text-align:center;">
Al Pacino
</td>
<td style="text-align:center;">
Robert De Niro
</td>
</tr>
<tr>
<td style="text-align:center;">
The Dark Knight
</td>
<td style="text-align:center;">
2008
</td>
<td style="text-align:center;">
9.0
</td>
<td style="text-align:center;">
1862637
</td>
<td style="text-align:center;">
Christopher Nolan
</td>
<td style="text-align:center;">
Christian Bale
</td>
<td style="text-align:center;">
Heath Ledger
</td>
</tr>
<tr>
<td style="text-align:center;">
12 Angry Men
</td>
<td style="text-align:center;">
1957
</td>
<td style="text-align:center;">
8.9
</td>
<td style="text-align:center;">
517893
</td>
<td style="text-align:center;">
Sidney Lumet
</td>
<td style="text-align:center;">
Henry Fonda
</td>
<td style="text-align:center;">
Lee J. Cobb
</td>
</tr>
<tr>
<td style="text-align:center;">
Schindler's List
</td>
<td style="text-align:center;">
1993
</td>
<td style="text-align:center;">
8.9
</td>
<td style="text-align:center;">
970201
</td>
<td style="text-align:center;">
Steven Spielberg
</td>
<td style="text-align:center;">
Liam Neeson
</td>
<td style="text-align:center;">
Ralph Fiennes
</td>
</tr>
<tr>
<td style="text-align:center;">
Pulp Fiction
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
8.9
</td>
<td style="text-align:center;">
1475884
</td>
<td style="text-align:center;">
Quentin Tarantino
</td>
<td style="text-align:center;">
John Travolta
</td>
<td style="text-align:center;">
Uma Thurman
</td>
</tr>
<tr>
<td style="text-align:center;">
The Lord of the Rings: The Return of the King
</td>
<td style="text-align:center;">
2003
</td>
<td style="text-align:center;">
8.9
</td>
<td style="text-align:center;">
1348236
</td>
<td style="text-align:center;">
Peter Jackson
</td>
<td style="text-align:center;">
Elijah Wood
</td>
<td style="text-align:center;">
Viggo Mortensen
</td>
</tr>
<tr>
<td style="text-align:center;">
Il buono, il brutto, il cattivo
</td>
<td style="text-align:center;">
1966
</td>
<td style="text-align:center;">
8.8
</td>
<td style="text-align:center;">
558964
</td>
<td style="text-align:center;">
Sergio Leone
</td>
<td style="text-align:center;">
Clint Eastwood
</td>
<td style="text-align:center;">
Eli Wallach
</td>
</tr>
<tr>
<td style="text-align:center;">
Fight Club
</td>
<td style="text-align:center;">
1999
</td>
<td style="text-align:center;">
8.8
</td>
<td style="text-align:center;">
1512266
</td>
<td style="text-align:center;">
David Fincher
</td>
<td style="text-align:center;">
Brad Pitt
</td>
<td style="text-align:center;">
Edward Norton
</td>
</tr>
<tr>
<td style="text-align:center;">
The Lord of the Rings: The Fellowship of the Ring
</td>
<td style="text-align:center;">
2001
</td>
<td style="text-align:center;">
8.8
</td>
<td style="text-align:center;">
1368396
</td>
<td style="text-align:center;">
Peter Jackson
</td>
<td style="text-align:center;">
Elijah Wood
</td>
<td style="text-align:center;">
Ian McKellen
</td>
</tr>
<tr>
<td style="text-align:center;">
Forrest Gump
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
1424034
</td>
<td style="text-align:center;">
Robert Zemeckis
</td>
<td style="text-align:center;">
Tom Hanks
</td>
<td style="text-align:center;">
Robin Wright
</td>
</tr>
<tr>
<td style="text-align:center;">
Star Wars: Episode V - The Empire Strikes Back
</td>
<td style="text-align:center;">
1980
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
942645
</td>
<td style="text-align:center;">
Irvin Kershner
</td>
<td style="text-align:center;">
Mark Hamill
</td>
<td style="text-align:center;">
Harrison Ford
</td>
</tr>
<tr>
<td style="text-align:center;">
Inception
</td>
<td style="text-align:center;">
2010
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
1651480
</td>
<td style="text-align:center;">
Christopher Nolan
</td>
<td style="text-align:center;">
Leonardo DiCaprio
</td>
<td style="text-align:center;">
Joseph Gordon-Levitt
</td>
</tr>
<tr>
<td style="text-align:center;">
The Lord of the Rings: The Two Towers
</td>
<td style="text-align:center;">
2002
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
1220325
</td>
<td style="text-align:center;">
Peter Jackson
</td>
<td style="text-align:center;">
Elijah Wood
</td>
<td style="text-align:center;">
Ian McKellen
</td>
</tr>
<tr>
<td style="text-align:center;">
One Flew Over the Cuckoo's Nest
</td>
<td style="text-align:center;">
1975
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
753245
</td>
<td style="text-align:center;">
Milos Forman
</td>
<td style="text-align:center;">
Jack Nicholson
</td>
<td style="text-align:center;">
Louise Fletcher
</td>
</tr>
<tr>
<td style="text-align:center;">
Goodfellas
</td>
<td style="text-align:center;">
1990
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
813028
</td>
<td style="text-align:center;">
Martin Scorsese
</td>
<td style="text-align:center;">
Robert De Niro
</td>
<td style="text-align:center;">
Ray Liotta
</td>
</tr>
<tr>
<td style="text-align:center;">
The Matrix
</td>
<td style="text-align:center;">
1999
</td>
<td style="text-align:center;">
8.7
</td>
<td style="text-align:center;">
1357321
</td>
<td style="text-align:center;">
Lana Wachowski
</td>
<td style="text-align:center;">
Keanu Reeves
</td>
<td style="text-align:center;">
Laurence Fishburne
</td>
</tr>
<tr>
<td style="text-align:center;">
Shichinin no samurai
</td>
<td style="text-align:center;">
1954
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
254243
</td>
<td style="text-align:center;">
Akira Kurosawa
</td>
<td style="text-align:center;">
Toshirô Mifune
</td>
<td style="text-align:center;">
Takashi Shimura
</td>
</tr>
<tr>
<td style="text-align:center;">
Star Wars
</td>
<td style="text-align:center;">
1977
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
1014901
</td>
<td style="text-align:center;">
George Lucas
</td>
<td style="text-align:center;">
Mark Hamill
</td>
<td style="text-align:center;">
Harrison Ford
</td>
</tr>
<tr>
<td style="text-align:center;">
Cidade de Deus
</td>
<td style="text-align:center;">
2002
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
587273
</td>
<td style="text-align:center;">
Fernando Meirelles
</td>
<td style="text-align:center;">
Alexandre Rodrigues
</td>
<td style="text-align:center;">
Leandro Firmino
</td>
</tr>
<tr>
<td style="text-align:center;">
Se7en
</td>
<td style="text-align:center;">
1995
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
1150670
</td>
<td style="text-align:center;">
David Fincher
</td>
<td style="text-align:center;">
Morgan Freeman
</td>
<td style="text-align:center;">
Brad Pitt
</td>
</tr>
<tr>
<td style="text-align:center;">
The Silence of the Lambs
</td>
<td style="text-align:center;">
1991
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
1004835
</td>
<td style="text-align:center;">
Jonathan Demme
</td>
<td style="text-align:center;">
Jodie Foster
</td>
<td style="text-align:center;">
Anthony Hopkins
</td>
</tr>
<tr>
<td style="text-align:center;">
It's a Wonderful Life
</td>
<td style="text-align:center;">
1946
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
312318
</td>
<td style="text-align:center;">
Frank Capra
</td>
<td style="text-align:center;">
James Stewart
</td>
<td style="text-align:center;">
Donna Reed
</td>
</tr>
<tr>
<td style="text-align:center;">
La vita è bella
</td>
<td style="text-align:center;">
1997
</td>
<td style="text-align:center;">
8.6
</td>
<td style="text-align:center;">
484303
</td>
<td style="text-align:center;">
Roberto Benigni
</td>
<td style="text-align:center;">
Roberto Benigni
</td>
<td style="text-align:center;">
Nicoletta Braschi
</td>
</tr>
</tbody>
</table>
``` r
## Save data
## write.table(imdb_df2, "./data/imdb_top250movies_summary.tsv",
##             quote = FALSE, sep = "\t", row.names = FALSE)
```

### Analyze prelim data

*Quick look at the correlation between release year and rating.*

<img src="media/yearRelease_hist.png" align="middle">
<img src=media/yearRelease_rating.png align="left" height="50%" width="50%"> <img src=media/rating_noVotes.png align="right" height="50%" width="50%>

<p>
</p>
#### Get data from links

Creating more detailed dataset, which include:

-   Duration

-   Genre

-   Plot summary

The extraction of these fields is done via for loops that points to each indexed link and pulls desired node. Due to memory and lag time, the script is not scources into this rmd; the resulting data was saved, and read back into this rmd as a different dataset.

##### The script that produced the data set is found [here](https://github.com/farihakhan/STAT547-hw-khan-fariha/blob/master/hw_10/rScripts/02_scrapeData.r)

I did some data wrangling to clean the data for a more tidy dataset. I saved the data before wrangling to prevent addition possible errors.

``` r
imdb_full <- readRDS("./data/imdb_extractedInfo.rds")
glimpse(imdb_full)
```

    ## Observations: 250
    ## Variables: 10
    ## $ Title       <fctr> The Shawshank Redemption, The Godfather, The Godf...
    ## $ yearRelease <dbl> 1994, 1972, 1974, 2008, 1957, 1993, 1994, 2003, 19...
    ## $ Rating      <dbl> 9.2, 9.2, 9.0, 9.0, 8.9, 8.9, 8.9, 8.9, 8.8, 8.8, ...
    ## $ no.Votes    <dbl> 1886797, 1288241, 888707, 1862579, 517875, 970161,...
    ## $ Director    <fctr> Frank Darabont, Francis Ford Coppola, Francis For...
    ## $ Cast1       <fctr> Tim Robbins, Marlon Brando, Al Pacino, Christian ...
    ## $ Cast2       <fctr> Morgan Freeman, Al Pacino, Robert De Niro, Heath ...
    ## $ Genre       <chr> "\n            Genres:\n Crime |\n Drama\n        ...
    ## $ Duration    <chr> "142 min", "175 min", "202 min", "152 min", "96 mi...
    ## $ plotSummary <chr> "\nChronicles the experiences of a formerly succes...

### More analysis

``` r
suppressMessages(source('rScripts/03_scrapeData.r'))
movieDF <- cleanfinalData(imdb_full)

movieDF %>% 
      select(Title, Genre, plotSummary) %>% 
      head() %>% 
      kable("html")
```

<table>
<thead>
<tr>
<th style="text-align:left;">
Title
</th>
<th style="text-align:left;">
Genre
</th>
<th style="text-align:left;">
plotSummary
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
The Shawshank Redemption
</td>
<td style="text-align:left;">
Crime, Drama
</td>
<td style="text-align:left;">
Chronicles the experiences of a formerly successful banker as a prisoner in the gloomy jailhouse of Shawshank after being found guilty of a crime he did not commit. The film portrays the man's unique way of dealing with his new, torturous life; along the way he befriends a number of fellow prisoners, most notably a wise long-term inmate named Red.
</td>
</tr>
<tr>
<td style="text-align:left;">
The Godfather
</td>
<td style="text-align:left;">
Crime, Drama
</td>
<td style="text-align:left;">
When the aging head of a famous crime family decides to transfer his position to one of his subalterns, a series of unfortunate events start happening to the family, and a war begins between all the well-known families leading to insolence, deportation, murder and revenge, and ends with the favorable successor being finally chosen.
</td>
</tr>
<tr>
<td style="text-align:left;">
The Godfather: Part II
</td>
<td style="text-align:left;">
Crime, Drama
</td>
<td style="text-align:left;">
The continuing saga of the Corleone crime family tells the story of a young Vito Corleone growing up in Sicily and in 1910s New York; and follows Michael Corleone in the 1950s as he attempts to expand the family business into Las Vegas, Hollywood and Cuba.
</td>
</tr>
<tr>
<td style="text-align:left;">
The Dark Knight
</td>
<td style="text-align:left;">
Action, Crime, Drama, Thriller
</td>
<td style="text-align:left;">
Set within a year after the events of Batman Begins, Batman, Lieutenant James Gordon, and new district attorney Harvey Dent successfully begin to round up the criminals that plague Gotham City until a mysterious and sadistic criminal mastermind known only as the Joker appears in Gotham, creating a new wave of chaos. Batman's struggle against the Joker becomes deeply personal, forcing him to "confront everything he believes" and improve his technology to stop him. A love triangle develops between Bruce Wayne, Dent and Rachel Dawes.
</td>
</tr>
<tr>
<td style="text-align:left;">
12 Angry Men
</td>
<td style="text-align:left;">
Crime, Drama
</td>
<td style="text-align:left;">
The defense and the prosecution have rested and the jury is filing into the jury room to decide if a young man is guilty or innocent of murdering his father. What begins as an open-and-shut case of murder soon becomes a detective story that presents a succession of clues creating doubt, and a mini-drama of each of the jurors' prejudices and preconceptions about the trial, the accused, and each other. Based on the play, all of the action takes place on the stage of the jury room.
</td>
</tr>
<tr>
<td style="text-align:left;">
Schindler's List
</td>
<td style="text-align:left;">
Biography, Drama, History
</td>
<td style="text-align:left;">
Oskar Schindler is a vainglorious and greedy German businessman who becomes an unlikely humanitarian amid the barbaric German Nazi reign when he feels compelled to turn his factory into a refuge for Jews. Based on the true story of Oskar Schindler who managed to save about 1100 Jews from being gassed at the Auschwitz concentration camp, it is a testament to the good in all of us.
</td>
</tr>
</tbody>
</table>

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

#### Get data from web

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

#### Extract and structure data:

I stored each column variable into character lists. I changed some of the data types of the variables to allow analysis.

The extracted variables are:

-   Title

-   Year released

-   Rating

-   Number of IMDb user votes

-   Brief cast info

-   Link associated with each movie

#### Create summary dataframe

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

#### Clean dataset

> See rScript for more

``` r
imdb_df2 %>% 
      select(Title, yearRelease, Rating,
             no.Votes, Director, Cast1,
             Cast2, Link) %>% 
      head(25) %>% 
      kable(align = "c", padding = 1,
            caption = "imdb Top 250 Rated movies") %>% 
      kable_styling(bootstrap_options = c("striped", "condensed"), 
                    full_width = F, font_size = 9)
```

    ## Currently generic markdown table using pandoc is not supported.

|                       Title                       | yearRelease | Rating | no.Votes |       Director       |        Cast1        |         Cast2        |                                                                                    Link                                                                                   |
|:-------------------------------------------------:|:-----------:|:------:|:--------:|:--------------------:|:-------------------:|:--------------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|              The Shawshank Redemption             |     1994    |   9.2  |  1886841 |    Frank Darabont    |     Tim Robbins     |    Morgan Freeman    |  <http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_1> |
|                   The Godfather                   |     1972    |   9.2  |  1288277 | Francis Ford Coppola |    Marlon Brando    |       Al Pacino      |  <http://www.imdb.com/title/tt0068646/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_2> |
|               The Godfather: Part II              |     1974    |   9.0  |  888732  | Francis Ford Coppola |      Al Pacino      |    Robert De Niro    |  <http://www.imdb.com/title/tt0071562/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_3> |
|                  The Dark Knight                  |     2008    |   9.0  |  1862637 |   Christopher Nolan  |    Christian Bale   |     Heath Ledger     |  <http://www.imdb.com/title/tt0468569/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_4> |
|                    12 Angry Men                   |     1957    |   8.9  |  517893  |     Sidney Lumet     |     Henry Fonda     |      Lee J. Cobb     |  <http://www.imdb.com/title/tt0050083/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_5> |
|                  Schindler's List                 |     1993    |   8.9  |  970201  |   Steven Spielberg   |     Liam Neeson     |     Ralph Fiennes    |  <http://www.imdb.com/title/tt0108052/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_6> |
|                    Pulp Fiction                   |     1994    |   8.9  |  1475884 |   Quentin Tarantino  |    John Travolta    |      Uma Thurman     |  <http://www.imdb.com/title/tt0110912/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_7> |
|   The Lord of the Rings: The Return of the King   |     2003    |   8.9  |  1348236 |     Peter Jackson    |     Elijah Wood     |    Viggo Mortensen   |  <http://www.imdb.com/title/tt0167260/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_8> |
|          Il buono, il brutto, il cattivo          |     1966    |   8.8  |  558964  |     Sergio Leone     |    Clint Eastwood   |      Eli Wallach     |  <http://www.imdb.com/title/tt0060196/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_9> |
|                     Fight Club                    |     1999    |   8.8  |  1512266 |     David Fincher    |      Brad Pitt      |     Edward Norton    | <http://www.imdb.com/title/tt0137523/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_10> |
| The Lord of the Rings: The Fellowship of the Ring |     2001    |   8.8  |  1368396 |     Peter Jackson    |     Elijah Wood     |     Ian McKellen     | <http://www.imdb.com/title/tt0120737/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_11> |
|                    Forrest Gump                   |     1994    |   8.7  |  1424034 |    Robert Zemeckis   |      Tom Hanks      |     Robin Wright     | <http://www.imdb.com/title/tt0109830/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_12> |
|   Star Wars: Episode V - The Empire Strikes Back  |     1980    |   8.7  |  942645  |    Irvin Kershner    |     Mark Hamill     |     Harrison Ford    | <http://www.imdb.com/title/tt0080684/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_13> |
|                     Inception                     |     2010    |   8.7  |  1651480 |   Christopher Nolan  |  Leonardo DiCaprio  | Joseph Gordon-Levitt | <http://www.imdb.com/title/tt1375666/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_14> |
|       The Lord of the Rings: The Two Towers       |     2002    |   8.7  |  1220325 |     Peter Jackson    |     Elijah Wood     |     Ian McKellen     | <http://www.imdb.com/title/tt0167261/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_15> |
|          One Flew Over the Cuckoo's Nest          |     1975    |   8.7  |  753245  |     Milos Forman     |    Jack Nicholson   |    Louise Fletcher   | <http://www.imdb.com/title/tt0073486/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_16> |
|                     Goodfellas                    |     1990    |   8.7  |  813028  |    Martin Scorsese   |    Robert De Niro   |      Ray Liotta      | <http://www.imdb.com/title/tt0099685/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_17> |
|                     The Matrix                    |     1999    |   8.7  |  1357321 |    Lana Wachowski    |     Keanu Reeves    |  Laurence Fishburne  | <http://www.imdb.com/title/tt0133093/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_18> |
|                Shichinin no samurai               |     1954    |   8.6  |  254243  |    Akira Kurosawa    |    Toshirô Mifune   |    Takashi Shimura   | <http://www.imdb.com/title/tt0047478/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_19> |
|                     Star Wars                     |     1977    |   8.6  |  1014901 |     George Lucas     |     Mark Hamill     |     Harrison Ford    | <http://www.imdb.com/title/tt0076759/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_20> |
|                   Cidade de Deus                  |     2002    |   8.6  |  587273  |  Fernando Meirelles  | Alexandre Rodrigues |    Leandro Firmino   | <http://www.imdb.com/title/tt0317248/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_21> |
|                       Se7en                       |     1995    |   8.6  |  1150670 |     David Fincher    |    Morgan Freeman   |       Brad Pitt      | <http://www.imdb.com/title/tt0114369/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_22> |
|              The Silence of the Lambs             |     1991    |   8.6  |  1004835 |    Jonathan Demme    |     Jodie Foster    |    Anthony Hopkins   | <http://www.imdb.com/title/tt0102926/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_23> |
|               It's a Wonderful Life               |     1946    |   8.6  |  312318  |      Frank Capra     |    James Stewart    |      Donna Reed      | <http://www.imdb.com/title/tt0038650/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_24> |
|                  La vita è bella                  |     1997    |   8.6  |  484303  |    Roberto Benigni   |   Roberto Benigni   |   Nicoletta Braschi  | <http://www.imdb.com/title/tt0118799/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=3376940102&pf_rd_r=0WCJZ4872ES8Q9F0K8AC&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_25> |

``` r
## Look at cast members
imdb_df2 %>% 
      select(Title:Rating, no.Votes:Cast2) %>% 
      head(25) %>% 
      kable(align = "c", padding = 1,
            caption = "IMDb Top 250 Rated") %>% 
      kable_styling(bootstrap_options = c("striped", "condensed"), 
                    full_width = F, font_size = 9)
```

    ## Currently generic markdown table using pandoc is not supported.

|                       Title                       | yearRelease | Rating | no.Votes |       Director       |        Cast1        |         Cast2        |
|:-------------------------------------------------:|:-----------:|:------:|:--------:|:--------------------:|:-------------------:|:--------------------:|
|              The Shawshank Redemption             |     1994    |   9.2  |  1886841 |    Frank Darabont    |     Tim Robbins     |    Morgan Freeman    |
|                   The Godfather                   |     1972    |   9.2  |  1288277 | Francis Ford Coppola |    Marlon Brando    |       Al Pacino      |
|               The Godfather: Part II              |     1974    |   9.0  |  888732  | Francis Ford Coppola |      Al Pacino      |    Robert De Niro    |
|                  The Dark Knight                  |     2008    |   9.0  |  1862637 |   Christopher Nolan  |    Christian Bale   |     Heath Ledger     |
|                    12 Angry Men                   |     1957    |   8.9  |  517893  |     Sidney Lumet     |     Henry Fonda     |      Lee J. Cobb     |
|                  Schindler's List                 |     1993    |   8.9  |  970201  |   Steven Spielberg   |     Liam Neeson     |     Ralph Fiennes    |
|                    Pulp Fiction                   |     1994    |   8.9  |  1475884 |   Quentin Tarantino  |    John Travolta    |      Uma Thurman     |
|   The Lord of the Rings: The Return of the King   |     2003    |   8.9  |  1348236 |     Peter Jackson    |     Elijah Wood     |    Viggo Mortensen   |
|          Il buono, il brutto, il cattivo          |     1966    |   8.8  |  558964  |     Sergio Leone     |    Clint Eastwood   |      Eli Wallach     |
|                     Fight Club                    |     1999    |   8.8  |  1512266 |     David Fincher    |      Brad Pitt      |     Edward Norton    |
| The Lord of the Rings: The Fellowship of the Ring |     2001    |   8.8  |  1368396 |     Peter Jackson    |     Elijah Wood     |     Ian McKellen     |
|                    Forrest Gump                   |     1994    |   8.7  |  1424034 |    Robert Zemeckis   |      Tom Hanks      |     Robin Wright     |
|   Star Wars: Episode V - The Empire Strikes Back  |     1980    |   8.7  |  942645  |    Irvin Kershner    |     Mark Hamill     |     Harrison Ford    |
|                     Inception                     |     2010    |   8.7  |  1651480 |   Christopher Nolan  |  Leonardo DiCaprio  | Joseph Gordon-Levitt |
|       The Lord of the Rings: The Two Towers       |     2002    |   8.7  |  1220325 |     Peter Jackson    |     Elijah Wood     |     Ian McKellen     |
|          One Flew Over the Cuckoo's Nest          |     1975    |   8.7  |  753245  |     Milos Forman     |    Jack Nicholson   |    Louise Fletcher   |
|                     Goodfellas                    |     1990    |   8.7  |  813028  |    Martin Scorsese   |    Robert De Niro   |      Ray Liotta      |
|                     The Matrix                    |     1999    |   8.7  |  1357321 |    Lana Wachowski    |     Keanu Reeves    |  Laurence Fishburne  |
|                Shichinin no samurai               |     1954    |   8.6  |  254243  |    Akira Kurosawa    |    Toshirô Mifune   |    Takashi Shimura   |
|                     Star Wars                     |     1977    |   8.6  |  1014901 |     George Lucas     |     Mark Hamill     |     Harrison Ford    |
|                   Cidade de Deus                  |     2002    |   8.6  |  587273  |  Fernando Meirelles  | Alexandre Rodrigues |    Leandro Firmino   |
|                       Se7en                       |     1995    |   8.6  |  1150670 |     David Fincher    |    Morgan Freeman   |       Brad Pitt      |
|              The Silence of the Lambs             |     1991    |   8.6  |  1004835 |    Jonathan Demme    |     Jodie Foster    |    Anthony Hopkins   |
|               It's a Wonderful Life               |     1946    |   8.6  |  312318  |      Frank Capra     |    James Stewart    |      Donna Reed      |
|                  La vita è bella                  |     1997    |   8.6  |  484303  |    Roberto Benigni   |   Roberto Benigni   |   Nicoletta Braschi  |

``` r
## Save data
## write.table(imdb_df2, "./data/imdb_top250movies_summary.tsv",
##             quote = FALSE, sep = "\t", row.names = FALSE)
```

#### Analyze datase

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

###### The script that produced the data set is found [here](https://github.com/farihakhan/STAT547-hw-khan-fariha/blob/master/hw_10/rScripts/02_scrapeData.r)

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

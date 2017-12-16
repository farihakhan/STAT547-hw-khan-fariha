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
    ## $ Votes       <fctr> 9.2 based on 1,886,881 user ratings, 9.2 based on...
    ## $ Link        <chr> "http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FG...

### Clean dataset

> See rScript for more

``` r
imdb_df2 %>% 
      select(Title, yearRelease, Rating,
             no.Votes, Director, Cast1,
             Cast2) %>% 
      head(15) %>% 
      kable("html", align = "c", padding = 1,
            caption = "imdb Top 250 Rated movies") %>% 
      kable_styling(bootstrap_options = c("striped", "condensed"), 
                    full_width = F, font_size = 11)
```

<table class="table table-striped table-condensed" style="font-size: 11px; width: auto !important; margin-left: auto; margin-right: auto;">
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
1886881
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
1288297
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
888752
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
1862674
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
517905
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
970226
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
1475914
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
1348257
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
558975
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
1512291
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
1368431
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
1424063
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
942724
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
1651512
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
1220352
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
</tbody>
</table>
#### Look at cast members

``` r
imdb_df2 %>% 
      select(Title:Rating, no.Votes:Cast2) %>% 
      head(15) %>% 
      kable("html", align = "c", padding = 1,
            caption = "IMDb Top 250 Rated") %>% 
      kable_styling(bootstrap_options = c("striped", "condensed"), 
                    full_width = F, font_size = 11)
```

<table class="table table-striped table-condensed" style="font-size: 11px; width: auto !important; margin-left: auto; margin-right: auto;">
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
1886881
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
1288297
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
888752
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
1862674
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
517905
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
970226
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
1475914
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
1348257
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
558975
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
1512291
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
1368431
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
1424063
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
942724
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
1651512
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
1220352
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
</tbody>
</table>
### Analyze prelim data

*Quick look at the correlation between release year and rating.*

<img src="media/yearRelease_hist.png" align="middle">
<img src=media/yearRelease_rating.png height="50%" width="50%"> <img src=media/rating_noVotes.png height="50%" width="50%">

### 

### Get data from links

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
```

Looking briefly at the plot summaries and genres of the top 10 movies...

``` r
movieDF %>% 
      select(Title, Genre, plotSummary) %>% 
      head(10) %>% 
      kable("html", align = "c", padding = 1,
            caption = "Genres and Plots") %>% 
      kable_styling(bootstrap_options = c("striped", "condensed"), 
                    font_size = 12) %>% 
      column_spec(1, bold = T, width = "20em") %>%
      column_spec(2, width = "10em") %>%
      column_spec(3, width = "60em")
```

<table class="table table-striped table-condensed" style="font-size: 12px; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">
Genres and Plots
</caption>
<thead>
<tr>
<th style="text-align:center;">
Title
</th>
<th style="text-align:center;">
Genre
</th>
<th style="text-align:center;">
plotSummary
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
The Shawshank Redemption
</td>
<td style="text-align:center;width: 10em; ">
Crime, Drama
</td>
<td style="text-align:center;width: 60em; ">
Chronicles the experiences of a formerly successful banker as a prisoner in the gloomy jailhouse of Shawshank after being found guilty of a crime he did not commit. The film portrays the man's unique way of dealing with his new, torturous life; along the way he befriends a number of fellow prisoners, most notably a wise long-term inmate named Red.
</td>
</tr>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
The Godfather
</td>
<td style="text-align:center;width: 10em; ">
Crime, Drama
</td>
<td style="text-align:center;width: 60em; ">
When the aging head of a famous crime family decides to transfer his position to one of his subalterns, a series of unfortunate events start happening to the family, and a war begins between all the well-known families leading to insolence, deportation, murder and revenge, and ends with the favorable successor being finally chosen.
</td>
</tr>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
The Godfather: Part II
</td>
<td style="text-align:center;width: 10em; ">
Crime, Drama
</td>
<td style="text-align:center;width: 60em; ">
The continuing saga of the Corleone crime family tells the story of a young Vito Corleone growing up in Sicily and in 1910s New York; and follows Michael Corleone in the 1950s as he attempts to expand the family business into Las Vegas, Hollywood and Cuba.
</td>
</tr>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
The Dark Knight
</td>
<td style="text-align:center;width: 10em; ">
Action, Crime, Drama, Thriller
</td>
<td style="text-align:center;width: 60em; ">
Set within a year after the events of Batman Begins, Batman, Lieutenant James Gordon, and new district attorney Harvey Dent successfully begin to round up the criminals that plague Gotham City until a mysterious and sadistic criminal mastermind known only as the Joker appears in Gotham, creating a new wave of chaos. Batman's struggle against the Joker becomes deeply personal, forcing him to "confront everything he believes" and improve his technology to stop him. A love triangle develops between Bruce Wayne, Dent and Rachel Dawes.
</td>
</tr>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
12 Angry Men
</td>
<td style="text-align:center;width: 10em; ">
Crime, Drama
</td>
<td style="text-align:center;width: 60em; ">
The defense and the prosecution have rested and the jury is filing into the jury room to decide if a young man is guilty or innocent of murdering his father. What begins as an open-and-shut case of murder soon becomes a detective story that presents a succession of clues creating doubt, and a mini-drama of each of the jurors' prejudices and preconceptions about the trial, the accused, and each other. Based on the play, all of the action takes place on the stage of the jury room.
</td>
</tr>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
Schindler's List
</td>
<td style="text-align:center;width: 10em; ">
Biography, Drama, History
</td>
<td style="text-align:center;width: 60em; ">
Oskar Schindler is a vainglorious and greedy German businessman who becomes an unlikely humanitarian amid the barbaric German Nazi reign when he feels compelled to turn his factory into a refuge for Jews. Based on the true story of Oskar Schindler who managed to save about 1100 Jews from being gassed at the Auschwitz concentration camp, it is a testament to the good in all of us.
</td>
</tr>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
Pulp Fiction
</td>
<td style="text-align:center;width: 10em; ">
Crime, Drama
</td>
<td style="text-align:center;width: 60em; ">
Jules Winnfield (Samuel L. Jackson) and Vincent Vega (John Travolta) are two hit men who are out to retrieve a suitcase stolen from their employer, mob boss Marsellus Wallace (Ving Rhames). Wallace has also asked Vincent to take his wife Mia (Uma Thurman) out a few days later when Wallace himself will be out of town. Butch Coolidge (Bruce Willis) is an aging boxer who is paid by Wallace to lose his fight. The lives of these seemingly unrelated people are woven together comprising of a series of funny, bizarre and uncalled-for incidents.
</td>
</tr>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
The Lord of the Rings: The Return of the King
</td>
<td style="text-align:center;width: 10em; ">
Adventure, Drama, Fantasy
</td>
<td style="text-align:center;width: 60em; ">
The final confrontation between the forces of good and evil fighting for control of the future of Middle-earth. Hobbits: Frodo and Sam reach Mordor in their quest to destroy the "one ring", while Aragorn leads the forces of good against Sauron's evil army at the stone city of Minas Tirith.
</td>
</tr>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
Il buono, il brutto, il cattivo
</td>
<td style="text-align:center;width: 10em; ">
Western
</td>
<td style="text-align:center;width: 60em; ">
Blondie (The Good) is a professional gunslinger who is out trying to earn a few dollars. Angel Eyes (The Bad) is a hit man who always commits to a task and sees it through, as long as he is paid to do so. And Tuco (The Ugly) is a wanted outlaw trying to take care of his own hide. Tuco and Blondie share a partnership together making money off Tuco's bounty, but when Blondie unties the partnership, Tuco tries to hunt down Blondie. When Blondie and Tuco come across a horse carriage loaded with dead bodies, they soon learn from the only survivor (Bill Carson) that he and a few other men have buried a stash of gold in a cemetery. Unfortunately Carson dies and Tuco only finds out the name of the cemetery, while Blondie finds out the name on the grave. Now the two must keep each other alive in order to find the gold. Angel Eyes (who had been looking for Bill Carson) discovers that Tuco and Blondie met with Carson and knows they know the location of the gold. All he needs is for the two to ...
</td>
</tr>
<tr>
<td style="text-align:center;width: 20em; font-weight: bold;">
Fight Club
</td>
<td style="text-align:center;width: 10em; ">
Drama
</td>
<td style="text-align:center;width: 60em; ">
A nameless first person narrator (Edward Norton) attends support groups in attempt to subdue his emotional state and relieve his insomniac state. When he meets Marla (Helena Bonham Carter), another fake attendee of support groups, his life seems to become a little more bearable. However when he associates himself with Tyler (Brad Pitt) he is dragged into an underground fight club and soap making scheme. Together the two men spiral out of control and engage in competitive rivalry for love and power. When the narrator is exposed to the hidden agenda of Tyler's fight club, he must accept the awful truth that Tyler may not be who he says he is.
</td>
</tr>
</tbody>
</table>
##### Most popular directors

``` r
movieDF %>% 
      group_by(Director) %>% 
      tally() %>% 
      arrange(desc(n)) %>% 
      filter(n>4) %>% 
      kable()
```

| Director          |    n|
|:------------------|----:|
| Christopher Nolan |    8|
| Martin Scorsese   |    7|
| Stanley Kubrick   |    7|
| Steven Spielberg  |    7|
| Alfred Hitchcock  |    6|
| Akira Kurosawa    |    5|
| Billy Wilder      |    5|
| Charles Chaplin   |    5|
| Hayao Miyazaki    |    5|
| Quentin Tarantino |    5|

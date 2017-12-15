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


#### Get data from web
I wrote my code in an R script to make the markdown cleaner to view.
The rScript for the first part is found [here]()

```r
suppressMessages(source('rScripts/01_scrapeData.r'))
```


#### View data structure

###### View [html_structure](https://github.com/farihakhan/STAT547-hw-khan-fariha/blob/master/hw_10/html_structure.md)


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


#### Extract and structure data:

I stored each column variable into character lists. I changed some of the data types of the variables to allow analysis.

The extracted variables are:

 - Title
 
 - Year released
 
 - Rating 
 
 - Number of IMDb user votes
 
 - Brief cast info
 
 - Link associated with each movie



#### Create summary dataframe


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
## $ Votes       <fctr> 9.2 based on 1,886,752 user ratings, 9.2 based on...
## $ Link        <chr> "http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FG...
```

#### Clean dataset

Parse out names of the cast memebers for analysis

```r
imdb_df2 %>% 
      select(Title:Rating, no.Votes:Cast2) %>% 
      kable("html", align = "c", padding = 1,
            caption = "IMDb Top 250 Rated") %>% 
      kableExtra::scroll_box(height = "400px")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-y: scroll; height:400px; "><table>
<caption>IMDb Top 250 Rated</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> Title </th>
   <th style="text-align:center;"> yearRelease </th>
   <th style="text-align:center;"> Rating </th>
   <th style="text-align:center;"> no.Votes </th>
   <th style="text-align:center;"> Director </th>
   <th style="text-align:center;"> Cast1 </th>
   <th style="text-align:center;"> Cast2 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> The Shawshank Redemption </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 9.2 </td>
   <td style="text-align:center;"> 1886752 </td>
   <td style="text-align:center;"> Frank Darabont </td>
   <td style="text-align:center;"> Tim Robbins </td>
   <td style="text-align:center;"> Morgan Freeman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Godfather </td>
   <td style="text-align:center;"> 1972 </td>
   <td style="text-align:center;"> 9.2 </td>
   <td style="text-align:center;"> 1288202 </td>
   <td style="text-align:center;"> Francis Ford Coppola </td>
   <td style="text-align:center;"> Marlon Brando </td>
   <td style="text-align:center;"> Al Pacino </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Godfather: Part II </td>
   <td style="text-align:center;"> 1974 </td>
   <td style="text-align:center;"> 9.0 </td>
   <td style="text-align:center;"> 888683 </td>
   <td style="text-align:center;"> Francis Ford Coppola </td>
   <td style="text-align:center;"> Al Pacino </td>
   <td style="text-align:center;"> Robert De Niro </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Dark Knight </td>
   <td style="text-align:center;"> 2008 </td>
   <td style="text-align:center;"> 9.0 </td>
   <td style="text-align:center;"> 1862539 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Christian Bale </td>
   <td style="text-align:center;"> Heath Ledger </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 12 Angry Men </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.9 </td>
   <td style="text-align:center;"> 517853 </td>
   <td style="text-align:center;"> Sidney Lumet </td>
   <td style="text-align:center;"> Henry Fonda </td>
   <td style="text-align:center;"> Lee J. Cobb </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Schindler's List </td>
   <td style="text-align:center;"> 1993 </td>
   <td style="text-align:center;"> 8.9 </td>
   <td style="text-align:center;"> 970125 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Liam Neeson </td>
   <td style="text-align:center;"> Ralph Fiennes </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Pulp Fiction </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 8.9 </td>
   <td style="text-align:center;"> 1475808 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> John Travolta </td>
   <td style="text-align:center;"> Uma Thurman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Lord of the Rings: The Return of the King </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.9 </td>
   <td style="text-align:center;"> 1348158 </td>
   <td style="text-align:center;"> Peter Jackson </td>
   <td style="text-align:center;"> Elijah Wood </td>
   <td style="text-align:center;"> Viggo Mortensen </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Il buono, il brutto, il cattivo </td>
   <td style="text-align:center;"> 1966 </td>
   <td style="text-align:center;"> 8.8 </td>
   <td style="text-align:center;"> 558930 </td>
   <td style="text-align:center;"> Sergio Leone </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Eli Wallach </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Fight Club </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.8 </td>
   <td style="text-align:center;"> 1512168 </td>
   <td style="text-align:center;"> David Fincher </td>
   <td style="text-align:center;"> Brad Pitt </td>
   <td style="text-align:center;"> Edward Norton </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Lord of the Rings: The Fellowship of the Ring </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.8 </td>
   <td style="text-align:center;"> 1368320 </td>
   <td style="text-align:center;"> Peter Jackson </td>
   <td style="text-align:center;"> Elijah Wood </td>
   <td style="text-align:center;"> Ian McKellen </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Forrest Gump </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 1423935 </td>
   <td style="text-align:center;"> Robert Zemeckis </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Robin Wright </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Star Wars: Episode V - The Empire Strikes Back </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 942430 </td>
   <td style="text-align:center;"> Irvin Kershner </td>
   <td style="text-align:center;"> Mark Hamill </td>
   <td style="text-align:center;"> Harrison Ford </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Inception </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 1651386 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Joseph Gordon-Levitt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Lord of the Rings: The Two Towers </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 1220246 </td>
   <td style="text-align:center;"> Peter Jackson </td>
   <td style="text-align:center;"> Elijah Wood </td>
   <td style="text-align:center;"> Ian McKellen </td>
  </tr>
  <tr>
   <td style="text-align:center;"> One Flew Over the Cuckoo's Nest </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 753196 </td>
   <td style="text-align:center;"> Milos Forman </td>
   <td style="text-align:center;"> Jack Nicholson </td>
   <td style="text-align:center;"> Louise Fletcher </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Goodfellas </td>
   <td style="text-align:center;"> 1990 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 812981 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Ray Liotta </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Matrix </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.7 </td>
   <td style="text-align:center;"> 1357233 </td>
   <td style="text-align:center;"> Lana Wachowski </td>
   <td style="text-align:center;"> Keanu Reeves </td>
   <td style="text-align:center;"> Laurence Fishburne </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Shichinin no samurai </td>
   <td style="text-align:center;"> 1954 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 254223 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Toshirô Mifune </td>
   <td style="text-align:center;"> Takashi Shimura </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Star Wars </td>
   <td style="text-align:center;"> 1977 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 1014678 </td>
   <td style="text-align:center;"> George Lucas </td>
   <td style="text-align:center;"> Mark Hamill </td>
   <td style="text-align:center;"> Harrison Ford </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Cidade de Deus </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 587230 </td>
   <td style="text-align:center;"> Fernando Meirelles </td>
   <td style="text-align:center;"> Alexandre Rodrigues </td>
   <td style="text-align:center;"> Leandro Firmino </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Se7en </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 1150599 </td>
   <td style="text-align:center;"> David Fincher </td>
   <td style="text-align:center;"> Morgan Freeman </td>
   <td style="text-align:center;"> Brad Pitt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Silence of the Lambs </td>
   <td style="text-align:center;"> 1991 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 1004754 </td>
   <td style="text-align:center;"> Jonathan Demme </td>
   <td style="text-align:center;"> Jodie Foster </td>
   <td style="text-align:center;"> Anthony Hopkins </td>
  </tr>
  <tr>
   <td style="text-align:center;"> It's a Wonderful Life </td>
   <td style="text-align:center;"> 1946 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 312275 </td>
   <td style="text-align:center;"> Frank Capra </td>
   <td style="text-align:center;"> James Stewart </td>
   <td style="text-align:center;"> Donna Reed </td>
  </tr>
  <tr>
   <td style="text-align:center;"> La vita è bella </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 484260 </td>
   <td style="text-align:center;"> Roberto Benigni </td>
   <td style="text-align:center;"> Roberto Benigni </td>
   <td style="text-align:center;"> Nicoletta Braschi </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Usual Suspects </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.6 </td>
   <td style="text-align:center;"> 824720 </td>
   <td style="text-align:center;"> Bryan Singer </td>
   <td style="text-align:center;"> Kevin Spacey </td>
   <td style="text-align:center;"> Gabriel Byrne </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Léon </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 818933 </td>
   <td style="text-align:center;"> Luc Besson </td>
   <td style="text-align:center;"> Jean Reno </td>
   <td style="text-align:center;"> Gary Oldman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Saving Private Ryan </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 992805 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Matt Damon </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Sen to Chihiro no kamikakushi </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 484937 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Daveigh Chase </td>
   <td style="text-align:center;"> Suzanne Pleshette </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Coco </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 35310 </td>
   <td style="text-align:center;"> Lee Unkrich </td>
   <td style="text-align:center;"> Anthony Gonzalez </td>
   <td style="text-align:center;"> Gael García Bernal </td>
  </tr>
  <tr>
   <td style="text-align:center;"> American History X </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 868190 </td>
   <td style="text-align:center;"> Tony Kaye </td>
   <td style="text-align:center;"> Edward Norton </td>
   <td style="text-align:center;"> Edward Furlong </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Once Upon a Time in the West </td>
   <td style="text-align:center;"> 1968 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 242553 </td>
   <td style="text-align:center;"> Sergio Leone </td>
   <td style="text-align:center;"> Henry Fonda </td>
   <td style="text-align:center;"> Charles Bronson </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Interstellar </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 1118093 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Matthew McConaughey </td>
   <td style="text-align:center;"> Anne Hathaway </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Green Mile </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 893685 </td>
   <td style="text-align:center;"> Frank Darabont </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Michael Clarke Duncan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Psycho </td>
   <td style="text-align:center;"> 1960 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 476191 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> Anthony Perkins </td>
   <td style="text-align:center;"> Janet Leigh </td>
  </tr>
  <tr>
   <td style="text-align:center;"> City Lights </td>
   <td style="text-align:center;"> 1931 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 125564 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Virginia Cherrill </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Casablanca </td>
   <td style="text-align:center;"> 1942 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 429624 </td>
   <td style="text-align:center;"> Michael Curtiz </td>
   <td style="text-align:center;"> Humphrey Bogart </td>
   <td style="text-align:center;"> Ingrid Bergman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Intouchables </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 590033 </td>
   <td style="text-align:center;"> Olivier Nakache </td>
   <td style="text-align:center;"> François Cluzet </td>
   <td style="text-align:center;"> Omar Sy </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Modern Times </td>
   <td style="text-align:center;"> 1936 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 164944 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Paulette Goddard </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Pianist </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 567077 </td>
   <td style="text-align:center;"> Roman Polanski </td>
   <td style="text-align:center;"> Adrien Brody </td>
   <td style="text-align:center;"> Thomas Kretschmann </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Raiders of the Lost Ark </td>
   <td style="text-align:center;"> 1981 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 732274 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> Karen Allen </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Departed </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 974424 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Matt Damon </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Rear Window </td>
   <td style="text-align:center;"> 1954 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 355108 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> James Stewart </td>
   <td style="text-align:center;"> Grace Kelly </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Terminator 2: Judgment Day </td>
   <td style="text-align:center;"> 1991 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 823586 </td>
   <td style="text-align:center;"> James Cameron </td>
   <td style="text-align:center;"> Arnold Schwarzenegger </td>
   <td style="text-align:center;"> Linda Hamilton </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Back to the Future </td>
   <td style="text-align:center;"> 1985 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 828685 </td>
   <td style="text-align:center;"> Robert Zemeckis </td>
   <td style="text-align:center;"> Michael J. Fox </td>
   <td style="text-align:center;"> Christopher Lloyd </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Whiplash </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 516181 </td>
   <td style="text-align:center;"> Damien Chazelle </td>
   <td style="text-align:center;"> Miles Teller </td>
   <td style="text-align:center;"> J.K. Simmons </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Gladiator </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 1094529 </td>
   <td style="text-align:center;"> Ridley Scott </td>
   <td style="text-align:center;"> Russell Crowe </td>
   <td style="text-align:center;"> Joaquin Phoenix </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Lion King </td>
   <td style="text-align:center;"> 1994 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 734651 </td>
   <td style="text-align:center;"> Roger Allers </td>
   <td style="text-align:center;"> Matthew Broderick </td>
   <td style="text-align:center;"> Jeremy Irons </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Prestige </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 957965 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Christian Bale </td>
   <td style="text-align:center;"> Hugh Jackman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Memento </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 941372 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Guy Pearce </td>
   <td style="text-align:center;"> Carrie-Anne Moss </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Apocalypse Now </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:center;"> 8.5 </td>
   <td style="text-align:center;"> 497209 </td>
   <td style="text-align:center;"> Francis Ford Coppola </td>
   <td style="text-align:center;"> Martin Sheen </td>
   <td style="text-align:center;"> Marlon Brando </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Alien </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 642528 </td>
   <td style="text-align:center;"> Ridley Scott </td>
   <td style="text-align:center;"> Sigourney Weaver </td>
   <td style="text-align:center;"> Tom Skerritt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Great Dictator </td>
   <td style="text-align:center;"> 1940 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 157630 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Paulette Goddard </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Sunset Blvd. </td>
   <td style="text-align:center;"> 1950 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 157317 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> William Holden </td>
   <td style="text-align:center;"> Gloria Swanson </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Nuovo Cinema Paradiso </td>
   <td style="text-align:center;"> 1988 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 174553 </td>
   <td style="text-align:center;"> Giuseppe Tornatore </td>
   <td style="text-align:center;"> Philippe Noiret </td>
   <td style="text-align:center;"> Enzo Cannavale </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb </td>
   <td style="text-align:center;"> 1964 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 378773 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Peter Sellers </td>
   <td style="text-align:center;"> George C. Scott </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Lives of Others </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 289877 </td>
   <td style="text-align:center;"> Florian Henckel von Donnersmarck </td>
   <td style="text-align:center;"> Ulrich Mühe </td>
   <td style="text-align:center;"> Martina Gedeck </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Hotaru no haka </td>
   <td style="text-align:center;"> 1988 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 164218 </td>
   <td style="text-align:center;"> Isao Takahata </td>
   <td style="text-align:center;"> Tsutomu Tatsumi </td>
   <td style="text-align:center;"> Ayano Shiraishi </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Paths of Glory </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 136849 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Kirk Douglas </td>
   <td style="text-align:center;"> Ralph Meeker </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Django Unchained </td>
   <td style="text-align:center;"> 2012 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 1086249 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> Jamie Foxx </td>
   <td style="text-align:center;"> Christoph Waltz </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Shining </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 691335 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Jack Nicholson </td>
   <td style="text-align:center;"> Shelley Duvall </td>
  </tr>
  <tr>
   <td style="text-align:center;"> WALL·E </td>
   <td style="text-align:center;"> 2008 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 811220 </td>
   <td style="text-align:center;"> Andrew Stanton </td>
   <td style="text-align:center;"> Ben Burtt </td>
   <td style="text-align:center;"> Elissa Knight </td>
  </tr>
  <tr>
   <td style="text-align:center;"> American Beauty </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 910692 </td>
   <td style="text-align:center;"> Sam Mendes </td>
   <td style="text-align:center;"> Kevin Spacey </td>
   <td style="text-align:center;"> Annette Bening </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Mononoke-hime </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 256827 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Yôji Matsuda </td>
   <td style="text-align:center;"> Yuriko Ishida </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Dark Knight Rises </td>
   <td style="text-align:center;"> 2012 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 1268225 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Christian Bale </td>
   <td style="text-align:center;"> Tom Hardy </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Blade Runner 2049 </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 158161 </td>
   <td style="text-align:center;"> Denis Villeneuve </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> Ryan Gosling </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Oldeuboi </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 406939 </td>
   <td style="text-align:center;"> Chan-wook Park </td>
   <td style="text-align:center;"> Min-sik Choi </td>
   <td style="text-align:center;"> Ji-tae Yu </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Witness for the Prosecution </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 75595 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> Tyrone Power </td>
   <td style="text-align:center;"> Marlene Dietrich </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Aliens </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 546985 </td>
   <td style="text-align:center;"> James Cameron </td>
   <td style="text-align:center;"> Sigourney Weaver </td>
   <td style="text-align:center;"> Michael Biehn </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Once Upon a Time in America </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.4 </td>
   <td style="text-align:center;"> 247175 </td>
   <td style="text-align:center;"> Sergio Leone </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> James Woods </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Das Boot </td>
   <td style="text-align:center;"> 1981 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 186993 </td>
   <td style="text-align:center;"> Wolfgang Petersen </td>
   <td style="text-align:center;"> Jürgen Prochnow </td>
   <td style="text-align:center;"> Herbert Grönemeyer </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Dangal </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 77485 </td>
   <td style="text-align:center;"> Nitesh Tiwari </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> Sakshi Tanwar </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Citizen Kane </td>
   <td style="text-align:center;"> 1941 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 328955 </td>
   <td style="text-align:center;"> Orson Welles </td>
   <td style="text-align:center;"> Orson Welles </td>
   <td style="text-align:center;"> Joseph Cotten </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Vertigo </td>
   <td style="text-align:center;"> 1958 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 282552 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> James Stewart </td>
   <td style="text-align:center;"> Kim Novak </td>
  </tr>
  <tr>
   <td style="text-align:center;"> North by Northwest </td>
   <td style="text-align:center;"> 1959 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 243439 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> Cary Grant </td>
   <td style="text-align:center;"> Eva Marie Saint </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Star Wars: Episode VI - Return of the Jedi </td>
   <td style="text-align:center;"> 1983 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 773041 </td>
   <td style="text-align:center;"> Richard Marquand </td>
   <td style="text-align:center;"> Mark Hamill </td>
   <td style="text-align:center;"> Harrison Ford </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Braveheart </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 817202 </td>
   <td style="text-align:center;"> Mel Gibson </td>
   <td style="text-align:center;"> Mel Gibson </td>
   <td style="text-align:center;"> Sophie Marceau </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Reservoir Dogs </td>
   <td style="text-align:center;"> 1992 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 745149 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> Harvey Keitel </td>
   <td style="text-align:center;"> Tim Roth </td>
  </tr>
  <tr>
   <td style="text-align:center;"> M </td>
   <td style="text-align:center;"> 1931 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 111646 </td>
   <td style="text-align:center;"> Fritz Lang </td>
   <td style="text-align:center;"> Peter Lorre </td>
   <td style="text-align:center;"> Ellen Widmann </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Requiem for a Dream </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 638894 </td>
   <td style="text-align:center;"> Darren Aronofsky </td>
   <td style="text-align:center;"> Ellen Burstyn </td>
   <td style="text-align:center;"> Jared Leto </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Kimi no na wa. </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 65530 </td>
   <td style="text-align:center;"> Makoto Shinkai </td>
   <td style="text-align:center;"> Ryûnosuke Kamiki </td>
   <td style="text-align:center;"> Mone Kamishiraishi </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Taare Zameen Par </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 113087 </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> Darsheel Safary </td>
   <td style="text-align:center;"> Aamir Khan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Amélie </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 594437 </td>
   <td style="text-align:center;"> Jean-Pierre Jeunet </td>
   <td style="text-align:center;"> Audrey Tautou </td>
   <td style="text-align:center;"> Mathieu Kassovitz </td>
  </tr>
  <tr>
   <td style="text-align:center;"> A Clockwork Orange </td>
   <td style="text-align:center;"> 1971 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 623091 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Malcolm McDowell </td>
   <td style="text-align:center;"> Patrick Magee </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Lawrence of Arabia </td>
   <td style="text-align:center;"> 1962 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 215489 </td>
   <td style="text-align:center;"> David Lean </td>
   <td style="text-align:center;"> Peter O'Toole </td>
   <td style="text-align:center;"> Alec Guinness </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Amadeus </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 302914 </td>
   <td style="text-align:center;"> Milos Forman </td>
   <td style="text-align:center;"> F. Murray Abraham </td>
   <td style="text-align:center;"> Tom Hulce </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Double Indemnity </td>
   <td style="text-align:center;"> 1944 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 110707 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> Fred MacMurray </td>
   <td style="text-align:center;"> Barbara Stanwyck </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Eternal Sunshine of the Spotless Mind </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 745685 </td>
   <td style="text-align:center;"> Michel Gondry </td>
   <td style="text-align:center;"> Jim Carrey </td>
   <td style="text-align:center;"> Kate Winslet </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Taxi Driver </td>
   <td style="text-align:center;"> 1976 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 570845 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Jodie Foster </td>
  </tr>
  <tr>
   <td style="text-align:center;"> To Kill a Mockingbird </td>
   <td style="text-align:center;"> 1962 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 242781 </td>
   <td style="text-align:center;"> Robert Mulligan </td>
   <td style="text-align:center;"> Gregory Peck </td>
   <td style="text-align:center;"> John Megna </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Full Metal Jacket </td>
   <td style="text-align:center;"> 1987 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 545346 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Matthew Modine </td>
   <td style="text-align:center;"> R. Lee Ermey </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2001: A Space Odyssey </td>
   <td style="text-align:center;"> 1968 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 481302 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Keir Dullea </td>
   <td style="text-align:center;"> Gary Lockwood </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Singin' in the Rain </td>
   <td style="text-align:center;"> 1952 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 172640 </td>
   <td style="text-align:center;"> Stanley Donen </td>
   <td style="text-align:center;"> Gene Kelly </td>
   <td style="text-align:center;"> Donald O'Connor </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Toy Story </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 704078 </td>
   <td style="text-align:center;"> John Lasseter </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Tim Allen </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 Idiots </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 256279 </td>
   <td style="text-align:center;"> Rajkumar Hirani </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> Madhavan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Sting </td>
   <td style="text-align:center;"> 1973 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 196044 </td>
   <td style="text-align:center;"> George Roy Hill </td>
   <td style="text-align:center;"> Paul Newman </td>
   <td style="text-align:center;"> Robert Redford </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Toy Story 3 </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 611432 </td>
   <td style="text-align:center;"> Lee Unkrich </td>
   <td style="text-align:center;"> Tom Hanks </td>
   <td style="text-align:center;"> Tim Allen </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Inglourious Basterds </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 1003134 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> Brad Pitt </td>
   <td style="text-align:center;"> Diane Kruger </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Ladri di biciclette </td>
   <td style="text-align:center;"> 1948 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 108698 </td>
   <td style="text-align:center;"> Vittorio De Sica </td>
   <td style="text-align:center;"> Lamberto Maggiorani </td>
   <td style="text-align:center;"> Enzo Staiola </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Kid </td>
   <td style="text-align:center;"> 1921 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 80588 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Edna Purviance </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Snatch </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 662226 </td>
   <td style="text-align:center;"> Guy Ritchie </td>
   <td style="text-align:center;"> Jason Statham </td>
   <td style="text-align:center;"> Brad Pitt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Monty Python and the Holy Grail </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 419261 </td>
   <td style="text-align:center;"> Terry Gilliam </td>
   <td style="text-align:center;"> Graham Chapman </td>
   <td style="text-align:center;"> John Cleese </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Good Will Hunting </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 686180 </td>
   <td style="text-align:center;"> Gus Van Sant </td>
   <td style="text-align:center;"> Robin Williams </td>
   <td style="text-align:center;"> Matt Damon </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Jagten </td>
   <td style="text-align:center;"> 2012 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 205762 </td>
   <td style="text-align:center;"> Thomas Vinterberg </td>
   <td style="text-align:center;"> Mads Mikkelsen </td>
   <td style="text-align:center;"> Thomas Bo Larsen </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Per qualche dollaro in più </td>
   <td style="text-align:center;"> 1965 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 179638 </td>
   <td style="text-align:center;"> Sergio Leone </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Lee Van Cleef </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Scarface </td>
   <td style="text-align:center;"> 1983 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 599075 </td>
   <td style="text-align:center;"> Brian De Palma </td>
   <td style="text-align:center;"> Al Pacino </td>
   <td style="text-align:center;"> Michelle Pfeiffer </td>
  </tr>
  <tr>
   <td style="text-align:center;"> L.A. Confidential </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.3 </td>
   <td style="text-align:center;"> 453665 </td>
   <td style="text-align:center;"> Curtis Hanson </td>
   <td style="text-align:center;"> Kevin Spacey </td>
   <td style="text-align:center;"> Russell Crowe </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Apartment </td>
   <td style="text-align:center;"> 1960 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 124419 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> Jack Lemmon </td>
   <td style="text-align:center;"> Shirley MacLaine </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Metropolis </td>
   <td style="text-align:center;"> 1927 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 126114 </td>
   <td style="text-align:center;"> Fritz Lang </td>
   <td style="text-align:center;"> Brigitte Helm </td>
   <td style="text-align:center;"> Alfred Abel </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Jodaeiye Nader az Simin </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 172936 </td>
   <td style="text-align:center;"> Asghar Farhadi </td>
   <td style="text-align:center;"> Payman Maadi </td>
   <td style="text-align:center;"> Leila Hatami </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Rashômon </td>
   <td style="text-align:center;"> 1950 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 116461 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Toshirô Mifune </td>
   <td style="text-align:center;"> Machiko Kyô </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Indiana Jones and the Last Crusade </td>
   <td style="text-align:center;"> 1989 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 573571 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> Sean Connery </td>
  </tr>
  <tr>
   <td style="text-align:center;"> All About Eve </td>
   <td style="text-align:center;"> 1950 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 93609 </td>
   <td style="text-align:center;"> Joseph L. Mankiewicz </td>
   <td style="text-align:center;"> Bette Davis </td>
   <td style="text-align:center;"> Anne Baxter </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Yôjinbô </td>
   <td style="text-align:center;"> 1961 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 83504 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Toshirô Mifune </td>
   <td style="text-align:center;"> Eijirô Tôno </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Babam ve Oglum </td>
   <td style="text-align:center;"> 2005 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 51661 </td>
   <td style="text-align:center;"> Çagan Irmak </td>
   <td style="text-align:center;"> Resit Kurt </td>
   <td style="text-align:center;"> Fikret Kuskan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Up </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 753975 </td>
   <td style="text-align:center;"> Pete Docter </td>
   <td style="text-align:center;"> Edward Asner </td>
   <td style="text-align:center;"> Jordan Nagai </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Batman Begins </td>
   <td style="text-align:center;"> 2005 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 1088840 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Christian Bale </td>
   <td style="text-align:center;"> Michael Caine </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Some Like It Hot </td>
   <td style="text-align:center;"> 1959 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 195886 </td>
   <td style="text-align:center;"> Billy Wilder </td>
   <td style="text-align:center;"> Marilyn Monroe </td>
   <td style="text-align:center;"> Tony Curtis </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Treasure of the Sierra Madre </td>
   <td style="text-align:center;"> 1948 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 88728 </td>
   <td style="text-align:center;"> John Huston </td>
   <td style="text-align:center;"> Humphrey Bogart </td>
   <td style="text-align:center;"> Walter Huston </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Unforgiven </td>
   <td style="text-align:center;"> 1992 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 308213 </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Gene Hackman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Der Untergang </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 275883 </td>
   <td style="text-align:center;"> Oliver Hirschbiegel </td>
   <td style="text-align:center;"> Bruno Ganz </td>
   <td style="text-align:center;"> Alexandra Maria Lara </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Die Hard </td>
   <td style="text-align:center;"> 1988 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 654806 </td>
   <td style="text-align:center;"> John McTiernan </td>
   <td style="text-align:center;"> Bruce Willis </td>
   <td style="text-align:center;"> Alan Rickman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Raging Bull </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 259886 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Cathy Moriarty </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Heat </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 475915 </td>
   <td style="text-align:center;"> Michael Mann </td>
   <td style="text-align:center;"> Al Pacino </td>
   <td style="text-align:center;"> Robert De Niro </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Third Man </td>
   <td style="text-align:center;"> 1949 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 127338 </td>
   <td style="text-align:center;"> Carol Reed </td>
   <td style="text-align:center;"> Orson Welles </td>
   <td style="text-align:center;"> Joseph Cotten </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Bacheha-Ye aseman </td>
   <td style="text-align:center;"> 1997 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 38894 </td>
   <td style="text-align:center;"> Majid Majidi </td>
   <td style="text-align:center;"> Mohammad Amir Naji </td>
   <td style="text-align:center;"> Amir Farrokh Hashemian </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Great Escape </td>
   <td style="text-align:center;"> 1963 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 184020 </td>
   <td style="text-align:center;"> John Sturges </td>
   <td style="text-align:center;"> Steve McQueen </td>
   <td style="text-align:center;"> James Garner </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Ikiru </td>
   <td style="text-align:center;"> 1952 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 48491 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Takashi Shimura </td>
   <td style="text-align:center;"> Nobuo Kaneko </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Chinatown </td>
   <td style="text-align:center;"> 1974 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 240336 </td>
   <td style="text-align:center;"> Roman Polanski </td>
   <td style="text-align:center;"> Jack Nicholson </td>
   <td style="text-align:center;"> Faye Dunaway </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Pan's Labyrinth </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 518658 </td>
   <td style="text-align:center;"> Guillermo del Toro </td>
   <td style="text-align:center;"> Ivana Baquero </td>
   <td style="text-align:center;"> Ariadna Gil </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Tonari no Totoro </td>
   <td style="text-align:center;"> 1988 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 203913 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Hitoshi Takagi </td>
   <td style="text-align:center;"> Noriko Hidaka </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Incendies </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 101157 </td>
   <td style="text-align:center;"> Denis Villeneuve </td>
   <td style="text-align:center;"> Lubna Azabal </td>
   <td style="text-align:center;"> Mélissa Désormeaux-Poulin </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Ran </td>
   <td style="text-align:center;"> 1985 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 86843 </td>
   <td style="text-align:center;"> Akira Kurosawa </td>
   <td style="text-align:center;"> Tatsuya Nakadai </td>
   <td style="text-align:center;"> Akira Terao </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Dunkirk </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 265533 </td>
   <td style="text-align:center;"> Christopher Nolan </td>
   <td style="text-align:center;"> Fionn Whitehead </td>
   <td style="text-align:center;"> Barry Keoghan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Judgment at Nuremberg </td>
   <td style="text-align:center;"> 1961 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 51665 </td>
   <td style="text-align:center;"> Stanley Kramer </td>
   <td style="text-align:center;"> Spencer Tracy </td>
   <td style="text-align:center;"> Burt Lancaster </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Gold Rush </td>
   <td style="text-align:center;"> 1925 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 77234 </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Charles Chaplin </td>
   <td style="text-align:center;"> Mack Swain </td>
  </tr>
  <tr>
   <td style="text-align:center;"> El secreto de sus ojos </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 152203 </td>
   <td style="text-align:center;"> Juan José Campanella </td>
   <td style="text-align:center;"> Ricardo Darín </td>
   <td style="text-align:center;"> Soledad Villamil </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Hauru no ugoku shiro </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 246830 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Chieko Baishô </td>
   <td style="text-align:center;"> Takuya Kimura </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Inside Out </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 450462 </td>
   <td style="text-align:center;"> Pete Docter </td>
   <td style="text-align:center;"> Amy Poehler </td>
   <td style="text-align:center;"> Bill Hader </td>
  </tr>
  <tr>
   <td style="text-align:center;"> On the Waterfront </td>
   <td style="text-align:center;"> 1954 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 113282 </td>
   <td style="text-align:center;"> Elia Kazan </td>
   <td style="text-align:center;"> Marlon Brando </td>
   <td style="text-align:center;"> Karl Malden </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Bridge on the River Kwai </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 166437 </td>
   <td style="text-align:center;"> David Lean </td>
   <td style="text-align:center;"> William Holden </td>
   <td style="text-align:center;"> Alec Guinness </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Det sjunde inseglet </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 125686 </td>
   <td style="text-align:center;"> Ingmar Bergman </td>
   <td style="text-align:center;"> Max von Sydow </td>
   <td style="text-align:center;"> Gunnar Björnstrand </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Room </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 250429 </td>
   <td style="text-align:center;"> Lenny Abrahamson </td>
   <td style="text-align:center;"> Brie Larson </td>
   <td style="text-align:center;"> Jacob Tremblay </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Lock, Stock and Two Smoking Barrels </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 455243 </td>
   <td style="text-align:center;"> Guy Ritchie </td>
   <td style="text-align:center;"> Jason Flemyng </td>
   <td style="text-align:center;"> Dexter Fletcher </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Mr. Smith Goes to Washington </td>
   <td style="text-align:center;"> 1939 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 85824 </td>
   <td style="text-align:center;"> Frank Capra </td>
   <td style="text-align:center;"> James Stewart </td>
   <td style="text-align:center;"> Jean Arthur </td>
  </tr>
  <tr>
   <td style="text-align:center;"> A Beautiful Mind </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 691679 </td>
   <td style="text-align:center;"> Ron Howard </td>
   <td style="text-align:center;"> Russell Crowe </td>
   <td style="text-align:center;"> Ed Harris </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Casino </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 372587 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Sharon Stone </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Blade Runner </td>
   <td style="text-align:center;"> 1982 </td>
   <td style="text-align:center;"> 8.2 </td>
   <td style="text-align:center;"> 548402 </td>
   <td style="text-align:center;"> Ridley Scott </td>
   <td style="text-align:center;"> Harrison Ford </td>
   <td style="text-align:center;"> Rutger Hauer </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Elephant Man </td>
   <td style="text-align:center;"> 1980 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 180611 </td>
   <td style="text-align:center;"> David Lynch </td>
   <td style="text-align:center;"> Anthony Hopkins </td>
   <td style="text-align:center;"> John Hurt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> V for Vendetta </td>
   <td style="text-align:center;"> 2005 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 877310 </td>
   <td style="text-align:center;"> James McTeigue </td>
   <td style="text-align:center;"> Hugo Weaving </td>
   <td style="text-align:center;"> Natalie Portman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Wolf of Wall Street </td>
   <td style="text-align:center;"> 2013 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 910804 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Jonah Hill </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Smultronstället </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 71386 </td>
   <td style="text-align:center;"> Ingmar Bergman </td>
   <td style="text-align:center;"> Victor Sjöström </td>
   <td style="text-align:center;"> Bibi Andersson </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The General </td>
   <td style="text-align:center;"> 1926 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 60756 </td>
   <td style="text-align:center;"> Clyde Bruckman </td>
   <td style="text-align:center;"> Buster Keaton </td>
   <td style="text-align:center;"> Marion Mack </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Warrior </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 369490 </td>
   <td style="text-align:center;"> Gavin O'Connor </td>
   <td style="text-align:center;"> Tom Hardy </td>
   <td style="text-align:center;"> Nick Nolte </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Dial M for Murder </td>
   <td style="text-align:center;"> 1954 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 122086 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> Ray Milland </td>
   <td style="text-align:center;"> Grace Kelly </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Trainspotting </td>
   <td style="text-align:center;"> 1996 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 537775 </td>
   <td style="text-align:center;"> Danny Boyle </td>
   <td style="text-align:center;"> Ewan McGregor </td>
   <td style="text-align:center;"> Ewen Bremner </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Gran Torino </td>
   <td style="text-align:center;"> 2008 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 616855 </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Bee Vang </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Gone with the Wind </td>
   <td style="text-align:center;"> 1939 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 238381 </td>
   <td style="text-align:center;"> Victor Fleming </td>
   <td style="text-align:center;"> Clark Gable </td>
   <td style="text-align:center;"> Vivien Leigh </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Deer Hunter </td>
   <td style="text-align:center;"> 1978 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 257653 </td>
   <td style="text-align:center;"> Michael Cimino </td>
   <td style="text-align:center;"> Robert De Niro </td>
   <td style="text-align:center;"> Christopher Walken </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Sunrise: A Song of Two Humans </td>
   <td style="text-align:center;"> 1927 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 34527 </td>
   <td style="text-align:center;"> F.W. Murnau </td>
   <td style="text-align:center;"> George O'Brien </td>
   <td style="text-align:center;"> Janet Gaynor </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Sixth Sense </td>
   <td style="text-align:center;"> 1999 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 775471 </td>
   <td style="text-align:center;"> M. Night Shyamalan </td>
   <td style="text-align:center;"> Bruce Willis </td>
   <td style="text-align:center;"> Haley Joel Osment </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Fargo </td>
   <td style="text-align:center;"> 1996 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 507347 </td>
   <td style="text-align:center;"> Joel Coen </td>
   <td style="text-align:center;"> William H. Macy </td>
   <td style="text-align:center;"> Frances McDormand </td>
  </tr>
  <tr>
   <td style="text-align:center;"> No Country for Old Men </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 688912 </td>
   <td style="text-align:center;"> Ethan Coen </td>
   <td style="text-align:center;"> Tommy Lee Jones </td>
   <td style="text-align:center;"> Javier Bardem </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Thing </td>
   <td style="text-align:center;"> 1982 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 293112 </td>
   <td style="text-align:center;"> John Carpenter </td>
   <td style="text-align:center;"> Kurt Russell </td>
   <td style="text-align:center;"> Wilford Brimley </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Andrei Rublev </td>
   <td style="text-align:center;"> 1966 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 28992 </td>
   <td style="text-align:center;"> Andrei Tarkovsky </td>
   <td style="text-align:center;"> Anatoliy Solonitsyn </td>
   <td style="text-align:center;"> Ivan Lapikov </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Big Lebowski </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 600508 </td>
   <td style="text-align:center;"> Joel Coen </td>
   <td style="text-align:center;"> Jeff Bridges </td>
   <td style="text-align:center;"> John Goodman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Finding Nemo </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 782089 </td>
   <td style="text-align:center;"> Andrew Stanton </td>
   <td style="text-align:center;"> Albert Brooks </td>
   <td style="text-align:center;"> Ellen DeGeneres </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Tôkyô monogatari </td>
   <td style="text-align:center;"> 1953 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 33452 </td>
   <td style="text-align:center;"> Yasujirô Ozu </td>
   <td style="text-align:center;"> Chishû Ryû </td>
   <td style="text-align:center;"> Chieko Higashiyama </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Eskiya </td>
   <td style="text-align:center;"> 1996 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 44677 </td>
   <td style="text-align:center;"> Yavuz Turgul </td>
   <td style="text-align:center;"> Sener Sen </td>
   <td style="text-align:center;"> Ugur Yücel </td>
  </tr>
  <tr>
   <td style="text-align:center;"> There Will Be Blood </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 418258 </td>
   <td style="text-align:center;"> Paul Thomas Anderson </td>
   <td style="text-align:center;"> Daniel Day-Lewis </td>
   <td style="text-align:center;"> Paul Dano </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Cool Hand Luke </td>
   <td style="text-align:center;"> 1967 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 132232 </td>
   <td style="text-align:center;"> Stuart Rosenberg </td>
   <td style="text-align:center;"> Paul Newman </td>
   <td style="text-align:center;"> George Kennedy </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Idi i smotri </td>
   <td style="text-align:center;"> 1985 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 33017 </td>
   <td style="text-align:center;"> Elem Klimov </td>
   <td style="text-align:center;"> Aleksey Kravchenko </td>
   <td style="text-align:center;"> Olga Mironova </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Rebecca </td>
   <td style="text-align:center;"> 1940 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 97794 </td>
   <td style="text-align:center;"> Alfred Hitchcock </td>
   <td style="text-align:center;"> Laurence Olivier </td>
   <td style="text-align:center;"> Joan Fontaine </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Hacksaw Ridge </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 281532 </td>
   <td style="text-align:center;"> Mel Gibson </td>
   <td style="text-align:center;"> Andrew Garfield </td>
   <td style="text-align:center;"> Sam Worthington </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Kill Bill: Vol. 1 </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 817916 </td>
   <td style="text-align:center;"> Quentin Tarantino </td>
   <td style="text-align:center;"> Uma Thurman </td>
   <td style="text-align:center;"> David Carradine </td>
  </tr>
  <tr>
   <td style="text-align:center;"> How to Train Your Dragon </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 545667 </td>
   <td style="text-align:center;"> Dean DeBlois </td>
   <td style="text-align:center;"> Jay Baruchel </td>
   <td style="text-align:center;"> Gerard Butler </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Rang De Basanti </td>
   <td style="text-align:center;"> 2006 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 85883 </td>
   <td style="text-align:center;"> Rakeysh Omprakash Mehra </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> Soha Ali Khan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Mary and Max </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 134786 </td>
   <td style="text-align:center;"> Adam Elliot </td>
   <td style="text-align:center;"> Toni Collette </td>
   <td style="text-align:center;"> Philip Seymour Hoffman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Gone Girl </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 672279 </td>
   <td style="text-align:center;"> David Fincher </td>
   <td style="text-align:center;"> Ben Affleck </td>
   <td style="text-align:center;"> Rosamund Pike </td>
  </tr>
  <tr>
   <td style="text-align:center;"> La passion de Jeanne d'Arc </td>
   <td style="text-align:center;"> 1928 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 31254 </td>
   <td style="text-align:center;"> Carl Theodor Dreyer </td>
   <td style="text-align:center;"> Maria Falconetti </td>
   <td style="text-align:center;"> Eugene Silvain </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Shutter Island </td>
   <td style="text-align:center;"> 2010 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 897498 </td>
   <td style="text-align:center;"> Martin Scorsese </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Emily Mortimer </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Into the Wild </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 478408 </td>
   <td style="text-align:center;"> Sean Penn </td>
   <td style="text-align:center;"> Emile Hirsch </td>
   <td style="text-align:center;"> Vince Vaughn </td>
  </tr>
  <tr>
   <td style="text-align:center;"> La La Land </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 328883 </td>
   <td style="text-align:center;"> Damien Chazelle </td>
   <td style="text-align:center;"> Ryan Gosling </td>
   <td style="text-align:center;"> Emma Stone </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Life of Brian </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 300046 </td>
   <td style="text-align:center;"> Terry Jones </td>
   <td style="text-align:center;"> Graham Chapman </td>
   <td style="text-align:center;"> John Cleese </td>
  </tr>
  <tr>
   <td style="text-align:center;"> It Happened One Night </td>
   <td style="text-align:center;"> 1934 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 73416 </td>
   <td style="text-align:center;"> Frank Capra </td>
   <td style="text-align:center;"> Clark Gable </td>
   <td style="text-align:center;"> Claudette Colbert </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Relatos salvajes </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 122295 </td>
   <td style="text-align:center;"> Damián Szifron </td>
   <td style="text-align:center;"> Darío Grandinetti </td>
   <td style="text-align:center;"> María Marull </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Logan </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 415632 </td>
   <td style="text-align:center;"> James Mangold </td>
   <td style="text-align:center;"> Hugh Jackman </td>
   <td style="text-align:center;"> Patrick Stewart </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Platoon </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 321138 </td>
   <td style="text-align:center;"> Oliver Stone </td>
   <td style="text-align:center;"> Charlie Sheen </td>
   <td style="text-align:center;"> Tom Berenger </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Hotel Rwanda </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 289527 </td>
   <td style="text-align:center;"> Terry George </td>
   <td style="text-align:center;"> Don Cheadle </td>
   <td style="text-align:center;"> Sophie Okonedo </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Le salaire de la peur </td>
   <td style="text-align:center;"> 1953 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 40298 </td>
   <td style="text-align:center;"> Henri-Georges Clouzot </td>
   <td style="text-align:center;"> Yves Montand </td>
   <td style="text-align:center;"> Charles Vanel </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Network </td>
   <td style="text-align:center;"> 1976 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 116164 </td>
   <td style="text-align:center;"> Sidney Lumet </td>
   <td style="text-align:center;"> Faye Dunaway </td>
   <td style="text-align:center;"> William Holden </td>
  </tr>
  <tr>
   <td style="text-align:center;"> In the Name of the Father </td>
   <td style="text-align:center;"> 1993 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 124923 </td>
   <td style="text-align:center;"> Jim Sheridan </td>
   <td style="text-align:center;"> Daniel Day-Lewis </td>
   <td style="text-align:center;"> Pete Postlethwaite </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Stand by Me </td>
   <td style="text-align:center;"> 1986 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 303251 </td>
   <td style="text-align:center;"> Rob Reiner </td>
   <td style="text-align:center;"> Wil Wheaton </td>
   <td style="text-align:center;"> River Phoenix </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Rush </td>
   <td style="text-align:center;"> 2013 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 355152 </td>
   <td style="text-align:center;"> Ron Howard </td>
   <td style="text-align:center;"> Daniel Brühl </td>
   <td style="text-align:center;"> Chris Hemsworth </td>
  </tr>
  <tr>
   <td style="text-align:center;"> A Wednesday </td>
   <td style="text-align:center;"> 2008 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 56112 </td>
   <td style="text-align:center;"> Neeraj Pandey </td>
   <td style="text-align:center;"> Anupam Kher </td>
   <td style="text-align:center;"> Naseeruddin Shah </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Ben-Hur </td>
   <td style="text-align:center;"> 1959 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 180615 </td>
   <td style="text-align:center;"> William Wyler </td>
   <td style="text-align:center;"> Charlton Heston </td>
   <td style="text-align:center;"> Jack Hawkins </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Grand Budapest Hotel </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 560420 </td>
   <td style="text-align:center;"> Wes Anderson </td>
   <td style="text-align:center;"> Ralph Fiennes </td>
   <td style="text-align:center;"> F. Murray Abraham </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Persona </td>
   <td style="text-align:center;"> 1966 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 72222 </td>
   <td style="text-align:center;"> Ingmar Bergman </td>
   <td style="text-align:center;"> Bibi Andersson </td>
   <td style="text-align:center;"> Liv Ullmann </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Les quatre cents coups </td>
   <td style="text-align:center;"> 1959 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 79662 </td>
   <td style="text-align:center;"> François Truffaut </td>
   <td style="text-align:center;"> Jean-Pierre Léaud </td>
   <td style="text-align:center;"> Albert Rémy </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Jurassic Park </td>
   <td style="text-align:center;"> 1993 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 695238 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Sam Neill </td>
   <td style="text-align:center;"> Laura Dern </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Salinui chueok </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 82295 </td>
   <td style="text-align:center;"> Joon-ho Bong </td>
   <td style="text-align:center;"> Kang-ho Song </td>
   <td style="text-align:center;"> Sang-kyung Kim </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 12 Years a Slave </td>
   <td style="text-align:center;"> 2013 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 512417 </td>
   <td style="text-align:center;"> Steve McQueen </td>
   <td style="text-align:center;"> Chiwetel Ejiofor </td>
   <td style="text-align:center;"> Michael Kenneth Williams </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Mad Max: Fury Road </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 675878 </td>
   <td style="text-align:center;"> George Miller </td>
   <td style="text-align:center;"> Tom Hardy </td>
   <td style="text-align:center;"> Charlize Theron </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Million Dollar Baby </td>
   <td style="text-align:center;"> 2004 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 535293 </td>
   <td style="text-align:center;"> Clint Eastwood </td>
   <td style="text-align:center;"> Hilary Swank </td>
   <td style="text-align:center;"> Clint Eastwood </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Thor: Ragnarok </td>
   <td style="text-align:center;"> 2017 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 166360 </td>
   <td style="text-align:center;"> Taika Waititi </td>
   <td style="text-align:center;"> Chris Hemsworth </td>
   <td style="text-align:center;"> Tom Hiddleston </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Spotlight </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 296752 </td>
   <td style="text-align:center;"> Tom McCarthy </td>
   <td style="text-align:center;"> Mark Ruffalo </td>
   <td style="text-align:center;"> Michael Keaton </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Stalker </td>
   <td style="text-align:center;"> 1979 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 80913 </td>
   <td style="text-align:center;"> Andrei Tarkovsky </td>
   <td style="text-align:center;"> Alisa Freyndlikh </td>
   <td style="text-align:center;"> Aleksandr Kaydanovskiy </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Truman Show </td>
   <td style="text-align:center;"> 1998 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 751708 </td>
   <td style="text-align:center;"> Peter Weir </td>
   <td style="text-align:center;"> Jim Carrey </td>
   <td style="text-align:center;"> Ed Harris </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Amores perros </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 189942 </td>
   <td style="text-align:center;"> Alejandro G. Iñárritu </td>
   <td style="text-align:center;"> Emilio Echevarría </td>
   <td style="text-align:center;"> Gael García Bernal </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Butch Cassidy and the Sundance Kid </td>
   <td style="text-align:center;"> 1969 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 168664 </td>
   <td style="text-align:center;"> George Roy Hill </td>
   <td style="text-align:center;"> Paul Newman </td>
   <td style="text-align:center;"> Robert Redford </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Hachi: A Dog's Tale </td>
   <td style="text-align:center;"> 2009 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 190522 </td>
   <td style="text-align:center;"> Lasse Hallström </td>
   <td style="text-align:center;"> Richard Gere </td>
   <td style="text-align:center;"> Joan Allen </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Kaze no tani no Naushika </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 110969 </td>
   <td style="text-align:center;"> Hayao Miyazaki </td>
   <td style="text-align:center;"> Sumi Shimamoto </td>
   <td style="text-align:center;"> Mahito Tsujimura </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Before Sunrise </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 210515 </td>
   <td style="text-align:center;"> Richard Linklater </td>
   <td style="text-align:center;"> Ethan Hawke </td>
   <td style="text-align:center;"> Julie Delpy </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Princess Bride </td>
   <td style="text-align:center;"> 1987 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 325192 </td>
   <td style="text-align:center;"> Rob Reiner </td>
   <td style="text-align:center;"> Cary Elwes </td>
   <td style="text-align:center;"> Mandy Patinkin </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Maltese Falcon </td>
   <td style="text-align:center;"> 1941 </td>
   <td style="text-align:center;"> 8.1 </td>
   <td style="text-align:center;"> 125646 </td>
   <td style="text-align:center;"> John Huston </td>
   <td style="text-align:center;"> Humphrey Bogart </td>
   <td style="text-align:center;"> Mary Astor </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Prisoners </td>
   <td style="text-align:center;"> 2013 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 459937 </td>
   <td style="text-align:center;"> Denis Villeneuve </td>
   <td style="text-align:center;"> Hugh Jackman </td>
   <td style="text-align:center;"> Jake Gyllenhaal </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Paper Moon </td>
   <td style="text-align:center;"> 1973 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 27723 </td>
   <td style="text-align:center;"> Peter Bogdanovich </td>
   <td style="text-align:center;"> Ryan O'Neal </td>
   <td style="text-align:center;"> Tatum O'Neal </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Le notti di Cabiria </td>
   <td style="text-align:center;"> 1957 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 30846 </td>
   <td style="text-align:center;"> Federico Fellini </td>
   <td style="text-align:center;"> Giulietta Masina </td>
   <td style="text-align:center;"> François Périer </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Harry Potter and the Deathly Hallows: Part 2 </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 617897 </td>
   <td style="text-align:center;"> David Yates </td>
   <td style="text-align:center;"> Daniel Radcliffe </td>
   <td style="text-align:center;"> Emma Watson </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Catch Me If You Can </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 623593 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Leonardo DiCaprio </td>
   <td style="text-align:center;"> Tom Hanks </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Rocky </td>
   <td style="text-align:center;"> 1976 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 423896 </td>
   <td style="text-align:center;"> John G. Avildsen </td>
   <td style="text-align:center;"> Sylvester Stallone </td>
   <td style="text-align:center;"> Talia Shire </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Grapes of Wrath </td>
   <td style="text-align:center;"> 1940 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 70583 </td>
   <td style="text-align:center;"> John Ford </td>
   <td style="text-align:center;"> Henry Fonda </td>
   <td style="text-align:center;"> Jane Darwell </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Les diaboliques </td>
   <td style="text-align:center;"> 1955 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 47860 </td>
   <td style="text-align:center;"> Henri-Georges Clouzot </td>
   <td style="text-align:center;"> Simone Signoret </td>
   <td style="text-align:center;"> Véra Clouzot </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Touch of Evil </td>
   <td style="text-align:center;"> 1958 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 80741 </td>
   <td style="text-align:center;"> Orson Welles </td>
   <td style="text-align:center;"> Charlton Heston </td>
   <td style="text-align:center;"> Orson Welles </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Monsters, Inc. </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 661155 </td>
   <td style="text-align:center;"> Pete Docter </td>
   <td style="text-align:center;"> Billy Crystal </td>
   <td style="text-align:center;"> John Goodman </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Gandhi </td>
   <td style="text-align:center;"> 1982 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 189478 </td>
   <td style="text-align:center;"> Richard Attenborough </td>
   <td style="text-align:center;"> Ben Kingsley </td>
   <td style="text-align:center;"> John Gielgud </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Donnie Darko </td>
   <td style="text-align:center;"> 2001 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 643554 </td>
   <td style="text-align:center;"> Richard Kelly </td>
   <td style="text-align:center;"> Jake Gyllenhaal </td>
   <td style="text-align:center;"> Jena Malone </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Barry Lyndon </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 114575 </td>
   <td style="text-align:center;"> Stanley Kubrick </td>
   <td style="text-align:center;"> Ryan O'Neal </td>
   <td style="text-align:center;"> Marisa Berenson </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Annie Hall </td>
   <td style="text-align:center;"> 1977 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 217016 </td>
   <td style="text-align:center;"> Woody Allen </td>
   <td style="text-align:center;"> Woody Allen </td>
   <td style="text-align:center;"> Diane Keaton </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Terminator </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 665142 </td>
   <td style="text-align:center;"> James Cameron </td>
   <td style="text-align:center;"> Arnold Schwarzenegger </td>
   <td style="text-align:center;"> Linda Hamilton </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Bourne Ultimatum </td>
   <td style="text-align:center;"> 2007 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 542952 </td>
   <td style="text-align:center;"> Paul Greengrass </td>
   <td style="text-align:center;"> Matt Damon </td>
   <td style="text-align:center;"> Edgar Ramírez </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Groundhog Day </td>
   <td style="text-align:center;"> 1993 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 490261 </td>
   <td style="text-align:center;"> Harold Ramis </td>
   <td style="text-align:center;"> Bill Murray </td>
   <td style="text-align:center;"> Andie MacDowell </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Wizard of Oz </td>
   <td style="text-align:center;"> 1939 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 320827 </td>
   <td style="text-align:center;"> Victor Fleming </td>
   <td style="text-align:center;"> Judy Garland </td>
   <td style="text-align:center;"> Frank Morgan </td>
  </tr>
  <tr>
   <td style="text-align:center;"> La haine </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 117200 </td>
   <td style="text-align:center;"> Mathieu Kassovitz </td>
   <td style="text-align:center;"> Vincent Cassel </td>
   <td style="text-align:center;"> Hubert Koundé </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8½ </td>
   <td style="text-align:center;"> 1963 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 87988 </td>
   <td style="text-align:center;"> Federico Fellini </td>
   <td style="text-align:center;"> Marcello Mastroianni </td>
   <td style="text-align:center;"> Anouk Aimée </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Munna Bhai M.B.B.S. </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 56210 </td>
   <td style="text-align:center;"> Rajkumar Hirani </td>
   <td style="text-align:center;"> Sunil Dutt </td>
   <td style="text-align:center;"> Sanjay Dutt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Star Wars: Episode VII - The Force Awakens </td>
   <td style="text-align:center;"> 2015 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 702803 </td>
   <td style="text-align:center;"> J.J. Abrams </td>
   <td style="text-align:center;"> Daisy Ridley </td>
   <td style="text-align:center;"> John Boyega </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Jaws </td>
   <td style="text-align:center;"> 1975 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 461132 </td>
   <td style="text-align:center;"> Steven Spielberg </td>
   <td style="text-align:center;"> Roy Scheider </td>
   <td style="text-align:center;"> Robert Shaw </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Best Years of Our Lives </td>
   <td style="text-align:center;"> 1946 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 45160 </td>
   <td style="text-align:center;"> William Wyler </td>
   <td style="text-align:center;"> Myrna Loy </td>
   <td style="text-align:center;"> Dana Andrews </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Twelve Monkeys </td>
   <td style="text-align:center;"> 1995 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 505682 </td>
   <td style="text-align:center;"> Terry Gilliam </td>
   <td style="text-align:center;"> Bruce Willis </td>
   <td style="text-align:center;"> Madeleine Stowe </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Mou gaan dou </td>
   <td style="text-align:center;"> 2002 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 101598 </td>
   <td style="text-align:center;"> Wai-Keung Lau </td>
   <td style="text-align:center;"> Andy Lau </td>
   <td style="text-align:center;"> Tony Chiu-Wai Leung </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Faa yeung nin wa </td>
   <td style="text-align:center;"> 2000 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 88842 </td>
   <td style="text-align:center;"> Kar-Wai Wong </td>
   <td style="text-align:center;"> Tony Chiu-Wai Leung </td>
   <td style="text-align:center;"> Maggie Cheung </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Paris, Texas </td>
   <td style="text-align:center;"> 1984 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 59457 </td>
   <td style="text-align:center;"> Wim Wenders </td>
   <td style="text-align:center;"> Harry Dean Stanton </td>
   <td style="text-align:center;"> Nastassja Kinski </td>
  </tr>
  <tr>
   <td style="text-align:center;"> The Help </td>
   <td style="text-align:center;"> 2011 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 355544 </td>
   <td style="text-align:center;"> Tate Taylor </td>
   <td style="text-align:center;"> Emma Stone </td>
   <td style="text-align:center;"> Viola Davis </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Dead Poets Society </td>
   <td style="text-align:center;"> 1989 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 310297 </td>
   <td style="text-align:center;"> Peter Weir </td>
   <td style="text-align:center;"> Robin Williams </td>
   <td style="text-align:center;"> Robert Sean Leonard </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Beauty and the Beast </td>
   <td style="text-align:center;"> 1991 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 350451 </td>
   <td style="text-align:center;"> Gary Trousdale </td>
   <td style="text-align:center;"> Paige O'Hara </td>
   <td style="text-align:center;"> Robby Benson </td>
  </tr>
  <tr>
   <td style="text-align:center;"> PK </td>
   <td style="text-align:center;"> 2014 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 114497 </td>
   <td style="text-align:center;"> Rajkumar Hirani </td>
   <td style="text-align:center;"> Aamir Khan </td>
   <td style="text-align:center;"> Anushka Sharma Kohli </td>
  </tr>
  <tr>
   <td style="text-align:center;"> La battaglia di Algeri </td>
   <td style="text-align:center;"> 1966 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 42918 </td>
   <td style="text-align:center;"> Gillo Pontecorvo </td>
   <td style="text-align:center;"> Brahim Hadjadj </td>
   <td style="text-align:center;"> Jean Martin </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Pirates of the Caribbean: The Curse of the Black Pearl </td>
   <td style="text-align:center;"> 2003 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 896333 </td>
   <td style="text-align:center;"> Gore Verbinski </td>
   <td style="text-align:center;"> Johnny Depp </td>
   <td style="text-align:center;"> Geoffrey Rush </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Ah-ga-ssi </td>
   <td style="text-align:center;"> 2016 </td>
   <td style="text-align:center;"> 8.0 </td>
   <td style="text-align:center;"> 49012 </td>
   <td style="text-align:center;"> Chan-wook Park </td>
   <td style="text-align:center;"> Min-hee Kim </td>
   <td style="text-align:center;"> Jung-woo Ha </td>
  </tr>
</tbody>
</table></div>

```r
## Save data
## write.table(imdb_df2, "./data/imdb_top250movies_summary.tsv",
##             quote = FALSE, sep = "\t", row.names = FALSE)
```

#### Analyze datase

*Quick look at the correlation between release year and rating.*

<img src="media/yearRelease_hist.png" align = "middle">

<p>

<img src="media/yearRelease_rating.png" width="50%" height="50%" align = "left">

<img src="media/rating_noVotes.png" width="50%" height="50%" align = "right"><br>
</p>
<br>


#### Get data from links

Creating more detailed dataset, which include:

 - Duration
 
 - Genre
 
 - Plot summary

Due to issues with memory, the top 25 movies are subsetted. This work is done in the following rScript - to avoid long lagging time when rendering the rmarkdown.




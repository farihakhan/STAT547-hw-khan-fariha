## Homework 10: Data from the Web
##### Due date: December 8, 2017
##### Fariha Khan
#### 
#### 
## Assignment Overview
## 
##### There are three ways to get data from the internet into R:

 - Make API queries “by hand” using httr
 
 - Use an R package that wraps an API, such as the many from rOpenSci
 
 - *Scrape the web*

##### General requirements

 - Reproducibility
 
 - Security
 
 - Practicality
 
 - Reporting

## Scrape data - IMBD Top Rated Movies
## 
*Scrape a multi-record dataset off the web!*

Convert it into a clean and tidy data frame. Store that as a file ready for (hypothetical!) downstream analysis. Do just enough basic exploration of the resulting data, possibly including some plots, that you and a reader are convinced you’ve successfully downloaded and cleaned it. Also, make sure you not violating a site’s terms of service or your own ethical standards with your webscraping.

## Resources
## 

 - [Class notes](http://stat545.com/111Scraping_Workthrough.html)
 
 - [rOpenSci UseR! 2016 workshop](https://github.com/ropensci/user2016-tutorial#readme)
 
 - [Web scraping using rvest](https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/)
 
 - [Kable formatting](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html)
 


## Progress Report
## 
I had a lot of problems right of the bat with the data I had chosen on the IMBD website. The html format of this data was not as clean as the examples we had covered in class, but I still wanted to use it just for sheer interest of the data itself. 

I wasn't able to extract the components I wanted in a clean way - instead I was getting jumbled data, or I wasn't able to extract specific attributes and nodes. When I first tried to pull the movie titles I was getting the them back in a format similar to:
<img src="formatError.png" width="50%" height="50%">

I did a lot of data wrangling to get this data formatted properly in a dataframe. Use strsplit to parse the titleColumn node by ["\n"]:

```
rankInfo <- imbd %>% 
      html_nodes(".titleColumn") %>% 
      html_text() %>% 
      strsplit("[\n]") %>% 
      data.frame() %>% 
      t() 
      
rank_df <- as.data.frame(rankInfo, row.names = FALSE) %>% 
      select(V2:V4)
```
But I eventually figured out a way of specifying the nodes I wanted.


## This scrip is used to clean the summary dataframe and plot data

suppressPackageStartupMessages(library(tidyverse)) 
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(kableExtra))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(rvest))


# Access movie page --------------------------------------------------------------

imdb_full <- imdb_df2 %>% 
      select(Title:Rating, no.Votes, Director:Cast2) %>% 
      mutate(Director = as.factor(Director),
             Cast1 = as.factor(Cast1),
             Cast2 = as.factor(Cast2),
             Genre = "",
             Duration = "",
             plotSummary = "") %>% 
      head(25)


# Genre --------------------------------------------------------------

for(i in 1:25){
      genre <- imdb_df$Link[i] %>%
            read_html() %>%
            html_nodes(".see-more.inline.canwrap") %>%
            .[[2]] %>%
            html_text()

      imdb_full$Genre[i] <- genre
}


# Duration -------------------------------------------------------------------------------


for(i in 1:25){
      time <- imdb_df$Link[i] %>%
            read_html() %>%
            html_nodes(".txt-block") %>%
            html_nodes("time") %>% 
            html_text()

      imdb_full$Duration[i] <- time
}

# Plot summary ---------------------------------------------------------------------------


for(i in 1:25){
      txt <- imdb_df$Link[i] %>%
            read_html() %>%
            html_nodes("#titleStoryLine , div.inline.canwrap") %>%
            html_nodes("p, #text") %>%
            html_text()

      imdb_full$plotSummary[i] <- txt
}



# Clean and add ----------------------------------------------------------------------------------
finalData <- function(imdb_full){
      
      genre <- word(imdb_full$Genre, 2, sep = fixed('Genres:'))
      genre <- as.factor(gsub("Sci-Fi", "SciFi", genre))
      genre <- str_extract_all(genre, boundary("word"))
      
      df <-  imdb_full %>% 
            mutate(plotSummary = word(imdb_full$plotSummary,
                                      1, sep = fixed('Written'))) %>% 
            mutate(plotSummary = trimws(plotSummary, which = "right")) %>% 
            mutate(Genre = genre)
      
      return(df)
}


write.table(imdb, './hw_10/data/.tsv', 
            quote = FALSE, sep = "\t", row.names = FALSE)

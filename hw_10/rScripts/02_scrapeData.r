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
             plotSummary = "")



# Genre --------------------------------------------------------------

for(i in 1:nrow(imdb_full)){
      genre <- imdb_df$Link[i] %>% 
            read_html() %>%
            html_nodes(".see-more.inline.canwrap") %>% 
            .[[2]] %>% 
            html_text()
      
      imdb_full$Genre[i] <- genre
}


# Duration -------------------------------------------------------------------------------


for(i in 1:nrow(imdb_full)){
      time <- imdb_df$Link[i] %>% 
            read_html() %>%
            html_node(".txt-block, time, .inline") %>% 
            html_text()
      
      imdb_full$Duration[i] <- time
}

# Plot summary ---------------------------------------------------------------------------


for(i in 1:nrow(imdb_full)){
      txt <- imdb_df$Link[i] %>% 
            read_html() %>%
            html_nodes("#titleStoryLine , div.inline.canwrap") %>% 
            html_nodes("p, #text") %>% 
            html_text()
      
      imdb_full$plotSummary[i] <- txt
}

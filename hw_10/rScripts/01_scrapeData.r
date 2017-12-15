suppressPackageStartupMessages(library(tidyverse)) 
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(kableExtra))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(rvest))


# Get URL info ---------------------------------------------------------------------------

imdb_home <- "http://www.imdb.com"
imdb_url <- "http://www.imdb.com/chart/top?ref_=nv_mv_250_6"
imdb <- read_html(imdb_url)


# Extract fields -------------------------------------------------------------------------

extractFields <- function(x){
      
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
      
      imdb_df <- data.frame(Title, yearRelease, Rating,
                            Cast, Votes, Link) %>% 
            mutate(Link = paste0(imdb_home, Link))
      
      return(imdb_df)
      
}

imdb_df <- extractFields(imdb)

# Clean data -----------------------------------------------------------------------------

imdb_df2 <- imdb_df %>% 
      mutate(no.Votes = word(Votes, 4),
             no.Votes = as.numeric(gsub(",", "", no.Votes)),
             Director = word(Cast, 1, sep = fixed(' (dir.)')),
             Cast1 = word(Cast, 2, sep = fixed(', ')),
             Cast2 = word(Cast, 3, sep = fixed(', ')))




# Analyze and plot -----------------------------------------------------------------------


plot1 <- ggplot(imdb_df2, aes(yearRelease)) +
      geom_histogram(fill = "thistle", color = "thistle4",
                     alpha = 0.8, binwidth = 2.5) +
      geom_freqpoly(colour = "gray50", binwidth = 3) +
      labs(title = "IMDb Top 250 Movies",
           subtitle = "Year release") +
      theme_minimal()
ggsave("media/yearRelease_hist.png", plot1)


plot2 <- ggplot(imdb_df2, aes(x = yearRelease, y = Rating)) +
      geom_point() + 
      geom_smooth(se = FALSE) + 
      labs(title = "IMDb rating vs. Year of release") + 
      theme_minimal()
ggsave("media/yearRelease_rating.png", 
       plot = plot2, dpi = 500,
       width = 4, height = 4)

plot3 <- ggplot(imdb_df2, aes(x = no.Votes, y = Rating)) +
      geom_point() +
      geom_smooth(se = FALSE) +
      labs(title = "IMDb rating vs. Number of votes") +
      theme_minimal()
ggsave("media/rating_noVotes.png", 
       plot = plot3, dpi = 500,
       width = 4, height = 4)



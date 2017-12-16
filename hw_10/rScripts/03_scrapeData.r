## Read in extracted dataset for analysis

cleanfinalData <- function(imdb_full){
      
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

movieDF <- cleanfinalData(imdb_full)

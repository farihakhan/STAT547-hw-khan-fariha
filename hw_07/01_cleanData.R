library(tidyverse)
library(readr)
library(forcats)

# Load data ------------------------------------------------------------------------------

## Load in dataset from file path
gapminder_data <- read.delim("./data/gapminder.tsv")
levels(gap_data$continent)

plot1 <- gap_data %>% 
      group_by(continent, year)  %>% 
      ggplot(aes(x=year, y=log10(lifeExp), colour=continent)) +
      geom_smooth(se=FALSE, method = lm, size=0.5) +
      scale_color_brewer(palette = "Dark2") +
      ggtitle("Continental Life expectancy by Year") +
      ylab("LifeExp (log10)")
ggsave("lifeExp_vs_year.png", plot1)

# Reorder data ---------------------------------------------------------------------------

## Reorder the continents based on life expectancy
old_levels <- levels(gapminder_data$continent)
old_levels

## Create row of min life expectancy
gapminder_new <- gapminder_data %>% 
      group_by(continent, country) %>% 
      mutate(min_lifeExp=min(lifeExp))

## Reorder continents by minimum life expectancy
new_levels <- fct_reorder(gapminder_data$continent, gapminder_new$min_lifeExp)
new_levels %>% levels() %>% head()


# Plot data -------------------------------------------------------------------------------

gapminder_new %>% 
      ggplot(aes(x=year, y=lifeExp, colour=continent)) +
      geom_smooth(se=FALSE,size=0.5, alpha=0.8)

gapminder_new %>% 
      mutate(continent = as.character(continent)) %>% 
      ggplot(aes(x=year, y=fct_reorder(lifeExp, continent), colour=continent)) +
      geom_smooth(se=FALSE,size=0.5, alpha=0.8)

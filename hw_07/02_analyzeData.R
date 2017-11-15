library(tidyverse)
library(readr)
library(forcats)
library(knitr)

## Import previously generated dataset
gap_Rdata <- read.delim("./data/gapminder_reordered.tsv")


# Asia -----------------------------------------------------------------------------------

topAsia <- gap_new %>% 
      filter(continent == "Asia") %>% 
      group_by(country) %>% 
      summarise(mean_lifeExp = mean(lifeExp)) %>% 
      top_n(-3, wt = desc(mean_lifeExp))
kable(topAsia)

plot_tAsia <- gap_new %>% 
      filter(country %in% topAsia$country) %>% 
      ggplot(aes(x=year,y=lifeExp)) + 
      geom_point() +
      geom_smooth(method = "lm", se=FALSE) +
      facet_wrap( ~country) +
      ggtitle("Asia: Top 3 mean life expectancy")
ggsave("top_Asia.png", plot_tAsia)

# Americas -------------------------------------------------------------------------------

topAmericas <- gap_new %>% 
      filter(continent == "Americas") %>% 
      group_by(country) %>% 
      summarise(mean_lifeExp = mean(lifeExp)) %>% 
      top_n(-3, wt = desc(mean_lifeExp)) 
kable(topAmericas)

plot_tAmericas <- gap_new %>% 
      filter(country %in% topAmericas$country) %>% 
      ggplot(aes(x=year,y=lifeExp)) + 
      geom_point() +
      geom_smooth(method = "lm", se=FALSE) +
      facet_wrap( ~country) +
      ggtitle("Americas: Top 3 mean life expectancy")
ggsave("top_Americas.png", plot_tAmericas)


# Africa ---------------------------------------------------------------------------------

topAfrica <- gap_new %>% 
      filter(continent == "Africa") %>% 
      group_by(country) %>% 
      summarise(mean_lifeExp = mean(lifeExp)) %>% 
      top_n(-3, wt = desc(mean_lifeExp)) 
kable(topAfrica)

plot_tAfrica <- gap_new %>% 
      filter(country %in% topAfrica$country) %>% 
      ggplot(aes(x=year,y=lifeExp)) + 
      geom_point() +
      geom_smooth(method = "lm", se=FALSE) +
      facet_wrap( ~country) +
      ggtitle("Africa: Top 3 mean life expectancy")
ggsave("top_Africa.png", plot_tAfrica)


# Europe ---------------------------------------------------------------------------------

topEurope <- gap_new %>% 
      filter(continent == "Europe") %>% 
      group_by(country) %>% 
      summarise(mean_lifeExp = mean(lifeExp)) %>% 
      top_n(3, wt = desc(mean_lifeExp)) 
kable(topEurope)

plot_tEurope <- gap_new %>% 
      filter(country %in% topEurope$country) %>% 
      ggplot(aes(x=year,y=lifeExp)) + 
      geom_point() +
      geom_smooth(method = "lm", se=FALSE) +
      facet_wrap( ~country) +
      ggtitle("Europe: Top 3 mean life expectancy")
ggsave("top_Europe.png", plot_tEurope)


## write linear fit data to file, use china as an example
offset = 1952
dat <- subset(gap_dat,country=="China")
the_fit <- lm(lifeExp ~ I(year - offset), dat)
output <- data.frame(t(coef(the_fit))) %>%
      setNames(c("intercept", "slope"))
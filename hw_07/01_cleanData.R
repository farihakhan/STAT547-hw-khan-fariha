library(tidyverse)
library(readr)
library(forcats)

# Load data ------------------------------------------------------------------------------

## Load in dataset from file path
gap_data <- read.delim("./data/gapminder.tsv")

old_levels <- levels(gap_data$continent)
old_levels

# Reorder data ---------------------------------------------------------------------------

## Reorder the continents based on life expectancy
gap_new <- gap_data %>% 
      mutate(continent = fct_reorder(continent, lifeExp, max))

## Reorder continents by maximum life expectancy
new_levels <- levels(gap_new$continent)
new_levels


# Plot data -------------------------------------------------------------------------------

plot1 <- gap_data %>% 
      group_by(continent, year)  %>% 
      summarise(max_lifeExp = max(lifeExp)) %>% 
      ggplot(aes(x=year, y=log10(max_lifeExp), colour=continent)) +
      geom_point(aes(shape=continent)) +
      geom_smooth(se=FALSE, method = lm, size=0.5) +
      scale_color_brewer(palette = "Set1") +
      ggtitle("Continental Life expectancy by Year") +
      ylab("Maximum LifeExp (log10)")
ggsave("lifeExp_vs_year.png", plot1)

plot2 <- gap_new %>% 
      group_by(continent, year)  %>% 
      summarise(max_lifeExp = max(lifeExp)) %>% 
      ggplot(aes(x=year, y=log10(max_lifeExp), colour=continent)) +
      geom_point(aes(shape=continent)) +
      geom_smooth(se=FALSE, method = lm, size=0.5) +
      scale_color_brewer(palette = "Set1") +
      ggtitle("REORDERED MAX Continental Life expectancy by Year") +
      ylab("Maximum LifeExp (log10)")
ggsave("lifeExp_vs_year.png", plot2)



# Write table ----------------------------------------------------------------------------

write.table(gap_new, "./data/gapminder_reordered.tsv",
            quote = FALSE, sep = "\t", row.names = FALSE)


# Top 25 LifeExp -------------------------------------------------------------------------


getTop20 <- function(x){
      continent_input <- x
      plot_name <- paste("Average top 20 life expectancy of",
                         x, sep = " ")
      plot3 <- gap_new %>% 
            group_by(continent, country) %>% 
            filter(continent == continent_input) %>% 
            summarise(mean_lifeExp = mean(lifeExp)) %>% 
            arrange(desc(mean_lifeExp)) %>% 
            head(20) %>% 
            ggplot(aes(x=mean_lifeExp, y=fct_reorder(country, mean_lifeExp))) +
            geom_point() +
            ggtitle(plot_name) +
            ylab("Country") + xlab("Average Life expectancy")
      return(plot3)
      
}
getTop20("Asia")
getTop20("Africa")
getTop20("Americas")
getTop20("Oceania")
getTop20("Europe")



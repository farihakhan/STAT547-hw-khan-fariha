library(tidyverse)
library(readr)

# Load data ------------------------------------------------------------------------------

## Load in dataset from file path
gapminder_data <- read_delim("~/Documents/coursework/stat545/stat547/data/gapminder.tsv", 
                        "\t", escape_double = FALSE, trim_ws = TRUE)

# Reorder data ---------------------------------------------------------------------------

## Reorder the continents based on life expectancy
old_levels <- levels(gapminder_data$continent)

j_order <- sapply(c("Fellowship", "Towers", "Return"),
                  function(x) grep(x, old_levels))
new_levels <- old_levels[j_order]
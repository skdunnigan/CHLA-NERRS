library(tidyverse)
library(lubridate)
library(here)
library(janitor)
library(broom)

# chla <- read_csv(here::here('data', ''))
#
# exo1 <- readr::read_csv(here::here('data', '2019-08-20_exo.csv')) %>%
#   janitor::clean_names()
# exo2 <- readr::read_csv(here::here('data', '2019-10-22_exo.csv')) %>%
#   janitor::clean_names()

std <- readr::read_csv(here::here('data', 'std_run.csv')) %>%
  janitor::clean_names()

rundate <- c("2019-10-22")

# create a for loop?
# pull coefficients out of linear model for chlorophyll calculations
df <-broom::tidy(lm(fluor_rfu ~ std_conc, data = (std %>%
                                        filter(datetime == rundate))))

corr <- df[[2,2]]

std %>%
  filter(datetime == rundate) %>%
  ggplot(aes(x = std_conc, y = fluor_rfu)) +
  geom_point() +
  geom_smooth(method = "lm")


# bind exo data together

# extraction data
# fluorescence_in data
# blank corr = fluor - FB fluor
# dilution factor fluor = blank corr

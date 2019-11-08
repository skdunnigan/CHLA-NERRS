library(tidyverse)
library(lubridate)
library(here)
library(janitor)
library(broom)

# ---------------------
# read in data
# ---------------------
# bring in standard dataset for corrections
std <- readr::read_csv(here::here('data', 'std_run.csv')) %>%
  janitor::clean_names()

# bring in fluor data
chla <- readr::read_csv(here::here('data', 'chla_ext.csv')) %>%
  janitor::clean_names()

# bring in exo data
exo1 <- readr::read_csv(here::here('data', '2019-08-20_exo.csv')) %>%
  janitor::clean_names()
exo2 <- readr::read_csv(here::here('data', '2019-10-22_exo.csv')) %>%
  janitor::clean_names()

# ---------------------
# wrangle EXO data
# ---------------------
# bind together the exo data
# fix the date and times to combine
# remove unnecessary columns
exo <- dplyr::bind_rows(exo1, exo2) %>%
  mutate(date = as.Date(date_mm_dd_yyyy, format = "%m/%d/%Y"),
         datetime = lubridate::ymd_hms(paste(date, time_hh_mm_ss))
  ) %>%
  select(-date_mm_dd_yyyy, -time_hh_mm_ss, -time_fract_sec, -fault_code)
rm(exo1, exo2)

# ----------------------
# get calculations for chlorophyll
# ----------------------
# EDIT THIS
rundate <- c("2019-10-22")

# pull coefficients out of linear model for chlorophyll calculations
df <- broom::tidy(lm(fluor_rfu ~ std_conc, data = (std %>%
                                        filter(datetime == rundate))))

# pull out the coefficient as a value
corr <- df[[2,2]]

# plot line
std %>%
  filter(datetime == rundate) %>%
  ggplot(aes(x = std_conc, y = fluor_rfu)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", linetype = "dotted", color = "black") +
  theme_bw() +
  labs(title = paste0("Chlorophyll Tank Study Standard ", rundate),
       subtitle = paste0("Slope correction = ", corr))
ggsave(file = paste0("output/plot_std_", rundate,"_CHLa.png"), dpi = 120)

# use the corr value to calculate chlorophyll values
# extraction data
# fluorescence_in data
# blank corr = fluor - FB fluor
# dilution factor fluor = blank corr
chla_corr <- chla %>%
  dplyr::filter(date_mm_dd_yyyy == rundate) %>%
  dplyr::mutate(date = lubridate::ymd(date_mm_dd_yyyy),
                datetime = lubridate::ymd_hms(paste(date, time_hh_mm_ss)),
                blank_corr_fluor = (fluor_rfu - fb_fluor_rfu),
                dil_fact_fluor = (blank_corr_fluor * (ext_vol/vol_filter)),
                chla_ugl = (dil_fact_fluor / corr)
  ) %>%
  select(-date_mm_dd_yyyy, -time_hh_mm_ss, -date)

# ---------------------
# merge exo and chla data
# ---------------------

chla_exo <- left_join(chla_corr, exo, by = "datetime")

# ---------------------
# create plots
# ---------------------

# plot chla ext vs exo
chla_y_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L"))
ggplot(data = chla_exo, aes(x = datetime)) +
  geom_point(aes(y = chla_ugl), size = 2) +
  geom_line(aes(y = chla_ugl), size = 1) +
  geom_line(aes(y = chlorophyll_u_00b5_g_l),
            linetype = "dashed", size = 1) +
  geom_point(aes(y = chlorophyll_u_00b5_g_l), size = 2) +
  theme_bw() +
  theme(axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic")) +
  labs(x = "",
       y = chla_y_title,
       title = paste0("Chlorophyll Tank Study ", rundate),
       # subtitle = paste0("Slope correction = ", corr),
       caption = "Dashed line is EXO2 chlorophyll and solid is from extracted chlorophyll")
ggsave(file = paste0("output/plot_", rundate,"_CHLa.png"), dpi = 120)

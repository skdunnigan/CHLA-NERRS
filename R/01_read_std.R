
# ----00 !!EDIT THIS DATE----
rundate <- c("2019-10-22")

# ----01 read in data from standards----
# bring in standard dataset for corrections
std <- readr::read_csv(here::here('data', 'std_run.csv')) %>%
  janitor::clean_names()

# set date as a date format
std <- std %>%
  dplyr::mutate(datetime = as.Date(datetime, format = "%m/%d/%Y"))

# ----02 get calculations for chlorophyll in form of slope----

# pull coefficients out of linear model for chlorophyll calculations
df <- broom::tidy(lm(fluor_rfu ~ std_conc, data = (std %>%
                                        filter(datetime == rundate))))

# pull out the coefficient as a value
corr <- df[[2,2]]

# plot line with slope value used
# export to output folder
std %>%
  filter(datetime == rundate) %>%
  ggplot(aes(x = std_conc, y = fluor_rfu)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", linetype = "dotted", color = "black") +
  theme_bw() +
  labs(title = paste0("Chlorophyll Tank Study Standard ", rundate),
       subtitle = paste0("Slope correction = ", corr))
ggsave(file = here::here('output', 'chla_ext', paste0(rundate,"_plot_std_CHLa.png")),
       height = 4, width = 6, dpi = 120)

std %>%
  filter(datetime == rundate) %>%
  ggpubr::ggscatter(x = "std_conc", y = "fluor_rfu",
                    add = "reg.line") + # add regression line
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 199) +
  stat_regline_equation(label.y = 180) +
  theme_bw() +
  labs(title = paste0("Chlorophyll Tank Study Standard ", rundate))
ggsave(file = here::here('output', 'chla_ext', paste0(rundate, "_plot_std_eq_CHLa.png")),
       height = 4, width = 6, dpi = 120)

# ----03 bring in raw fluorometric data----
chla <- readr::read_csv(here::here('data', 'chla_raw', paste0(rundate, '_chla_raw.csv'))) %>%
  janitor::clean_names()

# ----04 use the corr value to calculate chlorophyll values----
# extraction data
# fluorescence_in data
# blank corr = fluor - FB fluor
# dilution factor fluor = blank corr
chla_corr <- chla %>%
  filter(duplicate == 0) %>%
  dplyr::mutate(date_sampled = as.Date(date_mm_dd_yyyy, format = "%m/%d/%Y"),
                date_analyzed = as.Date(date_analyzed, format = "%m/%d/%Y"),
                time = as.character(time_hh_mm_ss),
                time2 = substr(time, nchar(time) - 8, nchar(time)),
                datetime = paste(date_sampled, time2),
                datetime = lubridate::ymd_hms(datetime),
                blank_corr_fluor = (fluor_rfu - fb_fluor_rfu),
                dil_fact_fluor = (blank_corr_fluor * (vol_ext/vol_filter)),
                chla_ugl = (dil_fact_fluor / corr)
                ) %>%
  dplyr::select(-date_mm_dd_yyyy, -time_hh_mm_ss, -time, -time2)


# ----05 export as csv with all the calculations----
write.csv(chla_corr, here::here('output', 'chla_ext', paste0(rundate, '_chla.csv')))

# ----06 clear environment----
rm(rundate, std, df, corr, chla, chla_corr)

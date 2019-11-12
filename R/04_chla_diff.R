# ----01 run script to create dataframe----
source('R/02_exo_chla.R')

# ----02 calculate difference between exo and extracted chlorophyll----
chla_diff <- chla_exo %>%
  dplyr::mutate(chla_diff = chlorophyll_ugl - chla_ugl) %>%
  dplyr::select(datetime, date_analyzed, date_sampled, mmdd, method,
         chlorophyll_ugl, chla_ugl, chla_diff)

#----03 calculate mean and sd of difference in chlorophyll----
chla_diff %>%
  group_by(method) %>%
  summarise(mean = mean(chla_diff, na.rm = TRUE),
            sd = sd(chla_diff, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(aes(x = method, y = mean), stat = "identity", width = 0.2, fill = "grey") +
  geom_errorbar(aes(x = method, ymin = mean - sd, ymax = mean + sd), width = 0.2) +
  scale_y_continuous(expand = c(0,0)) +
  chla_theme +
  labs(x = "Method",
       y = expression(paste("Average Difference in Chlorophyll ", italic("a "), mu*"g/L")),
       title = "Average Difference",
       subtitle = "EXO Total Algae Sensor vs. Extracted Chlorophyll")
ggsave(file = here::here('output', 'difference_comparison_CHLa.png'),
       height = 4, width = 6, dpi = 120)

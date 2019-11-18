# ----01 run script to create dataframe----
source('R/00_load_packages.R')
source('R/05_swmp_load.R')

# ----02 make a df for pellicer creek and fort matanzas

pc_nut <- nut %>%
  filter(site == "pellicer creek", month > 5) %>% # filter station name and all months with data
    select(site, station_code, date_sampled, month, day, cdmo_name, component_long, result, remark)


chla_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L"))
ytemp <- expression("Temperature " ( degree~C))

ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek", month > 5),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N"),
             aes(x = date_sampled, y = result), color = "black", size = 3) +
  xlim(as.POSIXct(c("2019-06-01", "2019-10-01"))) +
  theme_cowplot()
# ----03 plot each month separately and combine into stacked figure ----

# just july
jul <- ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 7 & day == 14:15),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1.5) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 7),
             aes(x = date_sampled, y = result),
             color = "black", size = 4) +
  geom_line(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 7),
             aes(x = date_sampled, y = result),
             color = "black", size = 1, linetype = "dashed") +
  geom_point(data = filter(pc_nut, cdmo_name == "CHLAF" & month == 7),
             aes(x = date_sampled, y = result),
             color = "orange", size = 4) +
  xlim(as.POSIXct(c("2019-07-14 00:00", "2019-07-15 13:00"))) +
  theme_cowplot() +
  labs(x = "",
       y = "")

# just aug
aug <- ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 8 & day == 12:13),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1.5) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 8),
             aes(x = date_sampled, y = result),
             color = "black", size = 4) +
  geom_line(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 8),
            aes(x = date_sampled, y = result),
            color = "black", size = 1, linetype = "dashed") +
  geom_point(data = filter(pc_nut, cdmo_name == "CHLAF" & month == 8),
             aes(x = date_sampled, y = result),
             color = "orange", size = 4) +
  xlim(as.POSIXct(c("2019-08-12 00:00", "2019-08-13 13:00"))) +
  theme_cowplot() +
  labs(x = "",
       y = chla_title)

# just sep
sep <- ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 9 & day == 10:11),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1.5) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 9),
             aes(x = date_sampled, y = result),
             color = "black", size = 4) +
  geom_line(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 9),
            aes(x = date_sampled, y = result),
            color = "black", size = 1, linetype = "dashed") +
  geom_point(data = filter(pc_nut, cdmo_name == "CHLAF" & month == 9),
             aes(x = date_sampled, y = result),
             color = "orange", size = 4) +
  xlim(as.POSIXct(c("2019-09-10 00:00", "2019-09-11 13:00"))) +
  theme_cowplot() +
  labs(x = "DateTime",
       y = "",
       caption = "A = July , B = August, C = September 2019")

# make a stacked grid
plot_grid(jul, aug, sep, ncol = 1,
          labels = "AUTO", # provides an automatic "tag" for each plot
          hjust = -5.5, # adjusts position of the tag to align in the plots
          align = "v")
ggsave(file = here::here('output', 'gtm', 'swmpcomparison_pc_CHLa.png'),
       height = 7, width = 6, dpi = 120)
rm(jul, aug, sep)

# ---- 04 add salinity ----
# just july
jul <- ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 7 & day == 14:15),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1.5) +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 7 & day == 14:15),
            aes(x = datetime, y = sal),
            color = "lightblue", size = 1.5) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 7),
             aes(x = date_sampled, y = result),
             color = "black", size = 4) +
  geom_line(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 7),
            aes(x = date_sampled, y = result),
            color = "black", size = 1, linetype = "dashed") +
  geom_point(data = filter(pc_nut, cdmo_name == "CHLAF" & month == 7),
             aes(x = date_sampled, y = result),
             color = "orange", size = 4) +
  xlim(as.POSIXct(c("2019-07-14 00:00", "2019-07-15 13:00"))) +
  theme_cowplot() +
  labs(x = "",
       y = "")

# just aug
aug <- ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 8 & day == 12:13),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1.5) +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 8 & day == 12:13),
            aes(x = datetime, y = sal),
            color = "lightblue", size = 1.5) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 8),
             aes(x = date_sampled, y = result),
             color = "black", size = 4) +
  geom_line(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 8),
            aes(x = date_sampled, y = result),
            color = "black", size = 1, linetype = "dashed") +
  geom_point(data = filter(pc_nut, cdmo_name == "CHLAF" & month == 8),
             aes(x = date_sampled, y = result),
             color = "orange", size = 4) +
  xlim(as.POSIXct(c("2019-08-12 00:00", "2019-08-13 13:00"))) +
  theme_cowplot() +
  labs(x = "",
       y = chla_title)

# just sep
sep <- ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 9 & day == 10:11),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1.5) +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 9 & day == 10:11),
            aes(x = datetime, y = sal),
            color = "lightblue", size = 1.5) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 9),
             aes(x = date_sampled, y = result),
             color = "black", size = 4) +
  geom_line(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 9),
            aes(x = date_sampled, y = result),
            color = "black", size = 1, linetype = "dashed") +
  geom_point(data = filter(pc_nut, cdmo_name == "CHLAF" & month == 9),
             aes(x = date_sampled, y = result),
             color = "orange", size = 4) +
  xlim(as.POSIXct(c("2019-09-10 00:00", "2019-09-11 13:00"))) +
  theme_cowplot() +
  labs(x = "DateTime",
       y = "",
       caption = "A = July , B = August, C = September 2019")

# make a stacked grid
plot_grid(jul, aug, sep, ncol = 1,
          labels = "AUTO", # provides an automatic "tag" for each plot
          hjust = -5.5, # adjusts position of the tag to align in the plots
          align = "v")
ggsave(file = here::here('output', 'gtm', 'swmpcomparison_pc_sal_CHLa.png'),
       height = 7, width = 6, dpi = 120)
rm(jul, aug, sep)

# ---- 05 add turbidity ----
# just july
jul <- ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 7 & day == 14:15),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1.5) +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 7 & day == 14:15),
            aes(x = datetime, y = turb),
            color = "lightsalmon", size = 1.5) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 7),
             aes(x = date_sampled, y = result),
             color = "black", size = 4) +
  geom_line(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 7),
            aes(x = date_sampled, y = result),
            color = "black", size = 1, linetype = "dashed") +
  geom_point(data = filter(pc_nut, cdmo_name == "CHLAF" & month == 7),
             aes(x = date_sampled, y = result),
             color = "orange", size = 4) +
  xlim(as.POSIXct(c("2019-07-14 00:00", "2019-07-15 13:00"))) +
  theme_cowplot() +
  labs(x = "",
       y = "")

# just aug
aug <- ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 8 & day == 12:13),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1.5) +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 8 & day == 12:13),
            aes(x = datetime, y = turb),
            color = "lightsalmon", size = 1.5) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 8),
             aes(x = date_sampled, y = result),
             color = "black", size = 4) +
  geom_line(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 8),
            aes(x = date_sampled, y = result),
            color = "black", size = 1, linetype = "dashed") +
  geom_point(data = filter(pc_nut, cdmo_name == "CHLAF" & month == 8),
             aes(x = date_sampled, y = result),
             color = "orange", size = 4) +
  xlim(as.POSIXct(c("2019-08-12 00:00", "2019-08-13 13:00"))) +
  theme_cowplot() +
  labs(x = "",
       y = chla_title)

# just sep
sep <- ggplot() +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 9 & day == 10:11),
            aes(x = datetime, y = chl_fluor),
            color = "grey", size = 1.5) +
  geom_line(data = filter(wq, site_name == "pellicer creek" & month == 9 & day == 10:11),
            aes(x = datetime, y = turb),
            color = "lightsalmon", size = 1.5) +
  geom_point(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 9),
             aes(x = date_sampled, y = result),
             color = "black", size = 4) +
  geom_line(data = filter(pc_nut, cdmo_name == "UncCHLA_N" & month == 9),
            aes(x = date_sampled, y = result),
            color = "black", size = 1, linetype = "dashed") +
  geom_point(data = filter(pc_nut, cdmo_name == "CHLAF" & month == 9),
             aes(x = date_sampled, y = result),
             color = "orange", size = 4) +
  xlim(as.POSIXct(c("2019-09-10 00:00", "2019-09-11 13:00"))) +
  theme_cowplot() +
  labs(x = "DateTime",
       y = "",
       caption = "A = July , B = August, C = September 2019")

# make a stacked grid
plot_grid(jul, aug, sep, ncol = 1,
          labels = "AUTO", # provides an automatic "tag" for each plot
          hjust = -5.5, # adjusts position of the tag to align in the plots
          align = "v")
ggsave(file = here::here('output', 'gtm', 'swmpcomparison_pc_sal_CHLa.png'),
       height = 7, width = 6, dpi = 120)
rm(jul, aug, sep)

# ----06 add temperature ----
# just july temp
jul_temp <- ggplot(data = filter(wq, site_name == "pellicer creek" & month == 7 & day == 14:15)) +
  geom_line(aes(x = datetime, y = temp),
            color = "lightgoldenrod", size = 1.5) +
  xlim(as.POSIXct(c("2019-07-14 00:00", "2019-07-15 13:00"))) +
  theme_cowplot() +
  labs(x = "",
       y = "")

# just aug

aug_temp <- ggplot(data = filter(wq, site_name == "pellicer creek" & month == 8 & day == 12:13)) +
  geom_line(aes(x = datetime, y = temp),
            color = "lightgoldenrod", size = 1.5) +
  xlim(as.POSIXct(c("2019-08-12 00:00", "2019-08-13 13:00"))) +
  theme_cowplot() +
  labs(x = "",
       y = ytemp)

# just sep
sep_temp <- ggplot(data = filter(wq, site_name == "pellicer creek" & month == 9 & day == 10:11)) +
  geom_line(aes(x = datetime, y = temp),
            color = "lightgoldenrod", size = 1.5) +
  xlim(as.POSIXct(c("2019-09-10 00:00", "2019-09-11 13:00"))) +
  theme_cowplot() +
  labs(x = "DateTime",
       y = "",
       caption = "A = July , B = August, C = September 2019")

# make a stacked grid
plot1 <- plot_grid(jul, aug, sep, ncol = 1)
plot2 <- plot_grid(jul_temp, aug_temp, sep_temp, ncol = 1)
plot_temp <- plot_grid(plot1, plot2, ncol = 2)
ggsave(file = here::here('output', 'gtm', 'swmpcomparison_pc_sal_CHLa.png'),
       height = 7, width = 6, dpi = 120)
rm(jul, aug, sep)

# ----01 read in all files with extracted chlorophyll data----
files1 <- list.files(here::here('output', 'chla_ext'),
                    pattern = "*chla.csv", full.names = TRUE)
chla_tbl <- sapply(files1, readr::read_csv, simplify = FALSE) %>%
  dplyr::bind_rows(.id = "id") %>%
  janitor::clean_names()

# redo table to remove excess information
chla_tbl <- chla_tbl %>%
  dplyr::select(datetime, chla_ugl, dil_fact_fluor)

# ----02 read in all files with exo data during tank experiments----
files2 <- list.files(here::here('data', 'exo'),
                    pattern = "*_exo.csv", full.names = TRUE)
exo_tbl <- sapply(files2, readr::read_csv, simplify = FALSE) %>%
  dplyr::bind_rows(.id = "id") %>%
  janitor::clean_names()

# reorganize exo table to redo some column names and set datetime column
exo_tbl <- exo_tbl %>%
  dplyr::mutate(date = as.Date(date_mm_dd_yyyy, format = "%m/%d/%Y"),
                datetime = lubridate::ymd_hms(paste(date, time_hh_mm_ss)),
                temp = temp_u_00b0_c,
                spcond = sp_cond_m_s_cm,
                chlorophyll_ugl = chlorophyll_u_00b5_g_l) %>%
    dplyr::select(-date_mm_dd_yyyy, -time_hh_mm_ss, -time_fract_sec,
                  -fault_code, -temp_u_00b0_c, -chlorophyll_u_00b5_g_l,
                  -sp_cond_m_s_cm)
# remove files
rm(files1, files2)

# ----03 bind data together based on datetime stamps----
chla_exo <- left_join(chla_tbl, exo_tbl, by = "datetime") %>%
  mutate(mmdd = format(datetime,"%m-%d"))

# remove exo and extraction tables
rm(chla_tbl, exo_tbl)

# ----04 create figures for tank experiments----
# axis titles
chla_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L"))
chla_exo_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " EXO"))
chla_extr_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " Extracted"))

# plot chla ext vs exo for single date
# MUST CHANGE DATE IN THIS FIGURE
# loop by date
uniq_date <- unique(chla_exo$mmdd)

for (i in uniq_date) {
chla_site_plot <- chla_exo %>%
  filter(mmdd == i) %>%
  ggpubr::ggscatter(y = "chlorophyll_ugl", x = "chla_ugl",
                    add = "reg.line", conf.int = TRUE,
                    add.params = list(color = "black", fill = "grey")) +
  stat_regline_equation(
    aes(label = paste(..rr.label.., eq.label,sep = "~`, `~")), label.y.npc = c("top")
    ) +
  theme_bw() +
  theme(axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic")) +
  labs(y = chla_exo_title,
       x = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = i)
  ggsave(chla_site_plot, file = here::here('output', paste0(i, "_tank_chla.png")),
         height = 4, width = 6, dpi = 120)
}

# put tank studies onto one figure with R2, p-value, and linear equation
chla_exo %>%
ggpubr::ggscatter(y = "chlorophyll_ugl", x = "chla_ugl",
                  add = "reg.line", conf.int = TRUE, # add regression line and confidence interval
                  add.params = list(color = "black", fill = "grey")) + # adjust line and CI colors
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 10.0) + # add R2 and p value
  stat_regline_equation(label.y = 9.5) + # add linear equation
  theme_bw() +
  theme(axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic")) +
  labs(y = chla_exo_title,
       x = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "Tank Experiments")
ggsave(file = here::here('output', 'tank_plot_CHLa.png'),
       height = 4, width = 6, dpi = 120)

# facet by date in tank studies
chla_exo %>%
  ggplot(aes(y = chlorophyll_ugl, x = chla_ugl, color = mmdd)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = FALSE) +
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 10) +
  stat_regline_equation(label.y = 9.5) +
  facet_wrap(~mmdd) +
  theme_classic2() +
  theme(legend.position = "none",
        axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic")) +
  scale_color_brewer(type = "qual", palette = "Set1") +
  labs(y = chla_exo_title,
       x = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "Tank Experiments")
ggsave(file = here::here('output', "tank_facet_plot_CHLa.png"),
       height = 4, width = 6, dpi = 120)

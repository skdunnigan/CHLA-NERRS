# ----01 read in all files with extracted chlorophyll data----
files <- list.files(here::here('output', 'chla_ext'),
                    pattern = "*chla.csv", full.names = TRUE)
chla_tbl <- sapply(files, readr::read_csv, simplify = FALSE) %>%
  dplyr::bind_rows(.id = "id") %>%
  janitor::clean_names()

# redo table to remove excess information
chla_tbl <- chla_tbl %>%
  dplyr::select(datetime, chla_ugl, dil_fact_fluor)

# remove files df
rm(files)

# ----02 read in all files with exo data during tank experiments----
files <- list.files(here::here('data', 'exo'),
                    pattern = "*_exo.csv", full.names = TRUE)
exo_tbl <- sapply(files, readr::read_csv, simplify = FALSE) %>%
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
rm(files)

# ----03 bind data together based on datetime stamps----
chla_exo <- left_join(chla_tbl, exo_tbl, by = "datetime") %>%
  mutate(mmdd = format(datetime,"%m-%d"))

# remove exo and extraction tables
rm(chla_tbl, exo_tbl)

# ----04 create figures ----
chla_title <- <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L"))

chla_exo_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " EXO"))

chla_extr_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " Extracted"))
# plot chla ext vs exo
chla_exo %>%
  filter(date == "2019-08-20") %>%
  ggpubr::ggscatter(x = "chlorophyll_ugl", y = "chla_ugl",
                    add = "reg.line") +
  stat_cor(label.y = 4.0) +
  stat_regline_equation(label.y = 3.7) +
  theme_bw() +
  theme(axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic")) +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "2019-08-20")

chla_exo %>%
  filter(date == "2019-10-22") %>%
  ggpubr::ggscatter(x = "chlorophyll_ugl", y = "chla_ugl",
                    add = "reg.line") +
  stat_cor(label.y = 4.0) +
  stat_regline_equation(label.y = 3.7) +
  theme_bw() +
  theme(axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic")) +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "2019-10-22")

chla_exo %>%
ggpubr::ggscatter(x = "chlorophyll_ugl", y = "chla_ugl",
  add = "reg.line") +
  stat_cor(label.y = 5.9, label.x = 8.5) +
  stat_regline_equation(label.y = 5.6, label.x = 8.5) +
  theme_bw() +
  theme(axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic")) +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison")

chla_exo %>%
  ggplot(aes(x = chlorophyll_ugl, y = chla_ugl, color = mmdd)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = FALSE) +
  stat_cor(label.y = 4) +
  stat_regline_equation(label.y = 3.7) +
  facet_wrap(~mmdd, scales = "free_x") +
  theme_classic2() +
  theme(legend.position = "none",
        axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic")) +
  scale_color_brewer(type = "qual", palette = "Set1") +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison")
ggsave(file = here::here('output', "plot_CHLa.png"), dpi = 120)

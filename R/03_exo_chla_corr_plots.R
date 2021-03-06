# ----01 run script to create dataframe----
source('R/00_load_packages.R')
source('R/02_exo_chla.R')

# ----02 create axis titles and basic theme for figures----

chla_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L"))
chla_exo_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " EXO"))
chla_extr_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " Extracted"))
chla_RFU_title <- expression(paste("Chlorophyll ", italic("a "), "RFU EXO"))

# set standard theme for plots
chla_theme <- theme_classic2() +
  theme(axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic"))

# ----03 plot chla ext vs exo for single date using LOOP----
chla_tank <- chla_exo %>%
  filter(method == "tank")
uniq_date <- unique(chla_tank$mmdd)

for (i in uniq_date) {
  chla_date_plot <- chla_tank %>%
  filter(mmdd == i) %>%
  ggpubr::ggscatter(y = "chlorophyll_ugl", x = "chla_ugl",
                    add = "reg.line", conf.int = TRUE,
                    add.params = list(color = "black", fill = "grey")) +
  stat_regline_equation(
    aes(label = paste(..rr.label.., eq.label,sep = "~`, `~")), label.y.npc = c("top")
    ) +
  theme_cowplot() +
  labs(y = chla_exo_title,
       x = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = i)
  ggsave(chla_date_plot, file = here::here('output', 'gtm', 'gtm_tank', paste0(i, "_tank_chla.png")),
         height = 4, width = 6, dpi = 120)
}

rm(i, chla_tank, uniq_date, chla_date_plot)

# ----04 put tank studies onto one figure with R2, p-value, and linear equation----
chla_exo %>%
  filter(method == "tank") %>%
  ggpubr::ggscatter(x = "chlorophyll_ugl", y = "chla_ugl",
                  add = "reg.line", conf.int = TRUE, # add regression line and confidence interval
                  add.params = list(color = "black", fill = "grey")) + # adjust line and CI colors
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 10.0) + # add R2 and p value
  stat_regline_equation(label.y = 9.5) + # add linear equation
  theme_cowplot() +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "Tank Experiments")
ggsave(file = here::here('output', 'gtm', 'gtm_tank', 'tank_plot_CHLa.png'),
       height = 4, width = 6, dpi = 120)

# ----05 same figure as number 04, but with colors applied to the date points----
chla_exo %>%
  filter(method == "tank") %>%
  ggpubr::ggscatter(x = "chlorophyll_ugl", y = "chla_ugl", color = "mmdd",
                    add = "reg.line", conf.int = TRUE, # add regression line and confidence interval
                    add.params = list(color = "black", fill = "grey")) + # adjust line and CI colors
  scale_color_brewer(name = "Date Sampled", type = "qual", palette = "Set1") +
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 10.0) + # add R2 and p value
  stat_regline_equation(label.y = 9.5) + # add linear equation
  theme_cowplot() +
  theme(legend.position = "bottom") +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "Tank Experiments")
ggsave(file = here::here('output', 'gtm', 'gtm_tank', 'tank_plot_color_CHLa.png'),
       height = 4, width = 6, dpi = 120)

# ----06 facet by date in tank studies with unique equations/lines each----
chla_exo %>%
  filter(method == "tank") %>%
  ggplot(aes(x = chlorophyll_ugl, y = chla_ugl, color = mmdd)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = FALSE) +
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 10) +
  stat_regline_equation(label.y = 9.5) +
  facet_wrap(~mmdd) +
  theme_cowplot() +
  theme(legend.position = "none") +
  scale_color_brewer(type = "qual", palette = "Set1") +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "Tank Experiments")
ggsave(file = here::here('output', 'gtm', 'gtm_tank', "tank_facet_plot_CHLa.png"),
       height = 4, width = 6, dpi = 120)

# ----07 isco only figure comparison ----
chla_exo %>%
  filter(method == "isco") %>%
  ggpubr::ggscatter(x = "chlorophyll_ugl", y = "chla_ugl",
                    add = "reg.line", conf.int = TRUE, # add regression line and confidence interval
                    add.params = list(color = "black", fill = "grey")) + # adjust line and CI colors
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.x = 12.5, label.y = 16) + # add R2 and p value
  stat_regline_equation(label.x = 12.5, label.y = 15) + # add linear equation
  theme_cowplot() +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "ISCO Experiments")
ggsave(file = here::here('output', 'gtm', 'gtm_isco', 'isco_plot_CHLa.png'),
       height = 4, width = 6, dpi = 120)

# ----08 isco and tank comparison----
chla_exo %>%
  ggpubr::ggscatter(x = "chlorophyll_ugl", y = "chla_ugl", color = "method",
                    add = "reg.line", conf.int = TRUE, # add regression line and confidence interval
                    add.params = list(color = "black", fill = "grey")) + # adjust line and CI colors
  scale_color_brewer(name = "Method", type = "qual", palette = "Set1") +
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 25) + # add R2 and p value
  stat_regline_equation(label.y = 23) + # add linear equation
  theme_cowplot() +
  theme(legend.position = "bottom") +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "Tank and ISCO Experiments")
ggsave(file = here::here('output', 'gtm', 'iscotank_plot_CHLa.png'),
       height = 4, width = 6, dpi = 120)

# ----09 isco and tank comparison_chlorophyll RFU on sonde----
chla_exo %>%
  ggpubr::ggscatter(x = "chlorophyll_rfu", y = "chla_ugl", color = "method",
                    add = "reg.line", conf.int = TRUE, # add regression line and confidence interval
                    add.params = list(color = "black", fill = "grey")) + # adjust line and CI colors
  scale_color_brewer(name = "Method", type = "qual", palette = "Set1") +
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 25) + # add R2 and p value
  stat_regline_equation(label.y = 23) + # add linear equation
  theme_cowplot() +
  theme(legend.position = "bottom") +
  labs(x = chla_RFU_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "Tank and ISCO Experiments")
ggsave(file = here::here('output', 'gtm', 'iscotank_plot_RFU_CHLa.png'),
       height = 4, width = 6, dpi = 120)

# ----10 isco and tank side-by-side comparison----
chla_exo %>%
  ggplot(aes(x = chlorophyll_ugl, y = chla_ugl, color = method)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = FALSE) +
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 13.8) +
  stat_regline_equation(label.y = 12.8) +
  facet_wrap(~method, scales = "free_x") +
  theme_cowplot() +
  theme(legend.position = "none") +
  scale_color_brewer(type = "qual", palette = "Set1") +
  labs(x = chla_exo_title,
       y = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "Tank Experiments")
ggsave(file = here::here('output', 'gtm', "iscotank_facet_plot_CHLa.png"),
       height = 4, width = 6, dpi = 120)

# ----01 run script to create dataframe----
source('R/02_exo_chla.R')

# ----02 create axis titles for figures----

chla_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L"))
chla_exo_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " EXO"))
chla_extr_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " Extracted"))

# ----03 plot chla ext vs exo for single date using LOOP----
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

# ----04 put tank studies onto one figure with R2, p-value, and linear equation----
chla_exo %>%
ggpubr::ggscatter(y = "chlorophyll_ugl", x = "chla_ugl",
                  add = "reg.line", conf.int = TRUE, # add regression line and confidence interval
                  add.params = list(color = "black", fill = "grey")) + # adjust line and CI colors
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 10.0) + # add R2 and p value
  stat_regline_equation(label.y = 9.5) + # add linear equation
  theme_classic2() +
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

# ----05 same figure as number 04, but with colors applied to the date points----
chla_exo %>%
  ggpubr::ggscatter(y = "chlorophyll_ugl", x = "chla_ugl", color = "mmdd",
                    add = "reg.line", conf.int = TRUE, # add regression line and confidence interval
                    add.params = list(color = "black", fill = "grey")) + # adjust line and CI colors
  scale_color_brewer(name = "Date Sampled", type = "qual", palette = "Set1") +
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")), label.y = 10.0) + # add R2 and p value
  stat_regline_equation(label.y = 9.5) + # add linear equation
  theme_classic2() +
  theme(legend.position = "bottom",
        axis.text = element_text(color = "black", size = 12),
        axis.title = element_text(color = "black", size = 12),
        plot.caption = element_text(size = 8, face = "italic"),
        plot.subtitle = element_text(size = 10, face = "italic")) +
  labs(y = chla_exo_title,
       x = chla_extr_title,
       title = "Chlorophyll Comparison",
       subtitle = "Tank Experiments")
ggsave(file = here::here('output', 'tank_plot_color_CHLa.png'),
       height = 4, width = 6, dpi = 120)

# ----06 facet by date in tank studies with unique equations/lines each----
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
# ----01 run script to create dataframe----
source('R/00_load_packages.R')
source('R/02_exo_chla.R')

# ----02 create axis titles and basic theme for figures----

chla_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L"))
chla_exo_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " EXO"))
chla_extr_title <- expression(paste("Chlorophyll ", italic("a "), mu*"g/L", " Extracted"))

# ----03 plot chla ext vs exo for single NERR ISCO results using LOOP----
chla_isco_nerr <- chla_exo_all %>%
  filter(method == "isco")
uniq_nerr <- unique(chla_isco_nerr$nerr)

for (i in uniq_nerr) {
  chla_isco_nerr_plot <- chla_isco_nerr %>%
    filter(nerr == i) %>%
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
         subtitle = paste0("NERR: ", i))
  ggsave(chla_isco_nerr_plot, file = here::here('output', 'nerrs', paste0(i, "_isco_chla.png")),
         height = 4, width = 6, dpi = 120)
}

rm(i, chla_isco_nerr, uniq_nerr, chla_isco_nerr_plot)

# ----04 isco only figure comparison with nerrs colored----
chla_exo_all %>%
  filter(method == "isco") %>%
  ggpubr::ggscatter(y = "chlorophyll_ugl", x = "chla_ugl",
                    color = "nerr",
                    add = "reg.line", conf.int = TRUE, # add regression line and confidence interval
                    add.params = list(color = "black", fill = "grey")
                    ) + # adjust line and CI colors
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~")),
    label.x = 2, label.y = 20
    )+ # add R2 and p value
  stat_regline_equation(label.x = 2, label.y = 17) + # add linear equation
  scale_color_discrete(name = "NERR") +
  theme_cowplot() +
  theme(legend.position = "bottom") +
  labs(y = chla_exo_title,
       x = chla_extr_title,
       title = "Chlorophyll Comparison NERR",
       subtitle = "ISCO Experiments")
ggsave(file = here::here('output', 'nerrs', 'NERR_isco_plot_CHLa.png'),
       height = 4, width = 6, dpi = 120)

# ----05 isco only with nerrs faceted ----
chla_exo_all %>%
  filter(method == "isco") %>%
  ggplot(aes(y = chlorophyll_ugl, x = chla_ugl, color = nerr)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = FALSE) +
  stat_cor(
    aes(label = paste(..rr.label.., ..p.label.., sep = "~`, `~"))) + # add R2 and p value
  # stat_regline_equation() + # add linear equation
  facet_wrap(~nerr, scales = "free") +
  theme_cowplot() +
  theme(legend.position = "none") +
  labs(y = chla_exo_title,
       x = chla_extr_title,
       title = "Chlorophyll Comparison NERR",
       subtitle = "ISCO Experiments")
ggsave(file = here::here('output', 'nerrs', 'NERR_isco_plot_CHLa.png'),
       height = 4, width = 6, dpi = 120)


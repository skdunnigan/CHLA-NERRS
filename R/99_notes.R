# # pull out unique dates
# uniq_dates = unique(std$datetime)
#
# # loop by date
# for (i in uniq_dates) {
#   df <- broom::tidy(lm(fluor_rfu ~ std_conc,
#                        data = (std %>%
#                                  filter(datetime == i)))
#                     )
#
#   corr_i <- df[[2,2]]
#
#   std %>%
#     filter(datetime == i) %>%
#     ggplot(aes(x = std_conc, y = fluor_rfu)) +
#     geom_point() +
#     geom_smooth(method = "lm")
#
#   }

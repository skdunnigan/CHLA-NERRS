# this script adds in data from wells

# ----01 run script to create dataframe----
source('R/00_load_packages.R')
source('R/02_exo_chla.R')

# ----01 read in all files from external----
files_external <- list.files(here::here('data', 'external'),
                     pattern = "*.csv", full.names = TRUE)
extern_tbl <- sapply(files_external, readr::read_csv, simplify = FALSE) %>%
  dplyr::bind_rows(.id = "id") %>%
  janitor::clean_names()

# redo table to edit and remove excess information
extern_tbl <- extern_tbl %>%
  dplyr::mutate(date1 = as.POSIXct(time, format = "%m/%d/%Y %H:%M"),
                datetime = lubridate::ymd_hms(date1),
                chla_ugl = chl_a_flour,
                chlorophyll_ugl = chl_a_exo) %>%
  dplyr::select(-time, -chl_a_exo, -chl_a_flour, -date1, -level)

# ----02 add data dictionary information----
data_dict <- readr::read_csv(here::here('data', 'data_dictionary.csv')) %>%
  janitor::clean_names()

data_dict <- data_dict %>%
  dplyr::mutate(date_analyzed = as.Date(date_analyzed, format = "%m/%d/%Y"))

# ----03 bind the data dictionary and chlorophyll data together
extern_long <- left_join(extern_tbl, data_dict, by = "date_analyzed")

# ----04 bind this df into the chla_exo df
chla_exo_all <- bind_rows(chla_exo, extern_long)

rm(files_external, extern_tbl, data_dict, extern_long)

# script to read in all extracted chlorophyll data files and exo data files

# ----01 read in all files with extracted chlorophyll data----
files1 <- list.files(here::here('output', 'chla_ext'),
                     pattern = "*chla.csv", full.names = TRUE)
chla_tbl <- sapply(files1, readr::read_csv, simplify = FALSE) %>%
  dplyr::bind_rows(.id = "id") %>%
  janitor::clean_names()

# redo table to remove excess information
chla_tbl <- chla_tbl %>%
  dplyr::select(datetime, date_analyzed, chla_ugl, dil_fact_fluor)

# ----02 add data dictionary information----
data_dict <- readr::read_csv(here::here('data', 'data_dictionary.csv')) %>%
  janitor::clean_names()

data_dict <- data_dict %>%
  dplyr::mutate(date_analyzed = as.Date(date_analyzed, format = "%m/%d/%Y"))

# bind with chla_tbl
chla_tbl_long <- left_join(chla_tbl, data_dict, by = "date_analyzed") %>%
  dplyr::select(-run, -sample_location)

# ----03 read in all files with exo data during tank experiments----
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

# ----04 bind data together based on datetime stamps----
chla_exo <- left_join(chla_tbl_long, exo_tbl, by = "datetime") %>%
  mutate(mmdd = format(datetime,"%m-%d"))

# remove exo and extraction tables
rm(chla_tbl, chla_tbl_long, exo_tbl, data_dict)


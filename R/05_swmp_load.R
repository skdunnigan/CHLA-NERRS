# script to read in all SWMP exo data primaryQC files and nutrient file

# ----01 read in all files with exo data for SWMP WQ deployments----
files_swmpwq <- list.files(here::here('data', 'swmp', 'exo'),
                     pattern = "*_QC.csv", full.names = TRUE)
swmpwq_tbl <- sapply(files_swmpwq, readr::read_csv, simplify = FALSE) %>%
  dplyr::bind_rows(.id = "id") %>%
  janitor::clean_names()

# reorganize exo table to redo some column names and set datetime column
wq <- swmpwq_tbl %>%
  dplyr::mutate(date = as.Date(date, format = "%m/%d/%Y"),
                datetime = lubridate::ymd_hms(paste(date, time)),
                site_name = tolower(site_name),
                month = month(datetime),
                day = day(datetime))

# ----02 read in nutrient data file ----

# load GTMNERR SWMP nutrient dataset
# load file with CDMO SWMP names
# load GTMNERR SWMP field data
nut <- readxl::read_xlsx(here::here('data', 'swmp', 'nut', '2019_Nutrients_10.1.xlsx'),
                         sheet = "Chemistry") %>%
  janitor::clean_names()

names <- readr::read_csv(here::here('data', 'swmp', 'nut', 'componentnames.csv')) %>%
  janitor::clean_names()

# remove component_short
# force names to lowercase
# remove any spaces in station_code
# merge cdmo names file with dataframe to convert
# set cdmo_name to factor
# --------------------------------------------------
nut <- nut %>%
  dplyr::select(-component_short) %>%
  dplyr::mutate(station_code = tolower(station_code),
                station_code = gsub(" ","", station_code),
                site = tolower(site),
                component_long = tolower(component_long),
                month = month(date_sampled),
                day = day(date_sampled)) %>%
  dplyr::left_join(names, by = "component_long") %>%
  dplyr::mutate(cdmo_name = forcats::as_factor(cdmo_name))


rm(names, files_swmpwq, swmpwq_tbl)

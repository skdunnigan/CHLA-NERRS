# CHLA-NERRS
Files for the Total Algae Chlorophyll Sensor Assessment project for the National Estuarine Research Reserve System

## R Code

Elaboration on the functions of each script

### `00_load_packages.R`

*  `tidyverse` - because, *tidyverse*
*  `lubridate` - works with dates and times
*  `here` - sets relative file paths
*  `janitor` - cleans data, specifically `clean_names()` function
*  `broom` - converts the linear model statistics into a tibble
*  `readr` - reads in the csv files
*  `ggpubr` - this expands the `ggplot2` package and gives more flexibility

### `01_read_std.R`

Brings in the .csv file that has the standard information (for calibration of the fluorometer prior to each extraction). The information in this file is then used to create a linear regression between the standard and 90% acetone solutions to produce the best fit line. The slope of this line is then used as the normalization coefficient for all the relative fluorescence units for each sample for a particular date. 
This also brings in the `_chla_raw.csv files` for specified date in `rundate` and uses the slope of the standard information regression to produce a chlorophyll value in ug/L for each relative fluorescence unit.

*Outputs:* 

*   `_chla.csv` file with all the calculated chlorophyll information
*   `plot_std_..._chla.png` that has the calculated slope based on the standards used.
*   `plot_std_eq_..._ chla.png` has the R2, p, and equation for standard lines

### `02_exo_chla.R`

This code reads in each of the extracted chlorophyll files in the 'output/chla_ext' folder and binds them into one dataframe. It also uses the `data_dictionary.csv` file to add in additional information associated with each extracted chlorophyll dataset (isco vs. tank). Then, it reads in and binds together the water quality data from the EXO. This is then joined with the extracted chlorophyll data into one data frame with all the information associated with the specific datetime stamps. 

No outputs except for the `chla_exo` data frame.

### `03_exo_chla_corr_plots.R`

This code creates plots! Lots of plots which are exported into the `/output` folder. There are currently nine sections of code:

### `03.2_exo_chla_corr_plots_all.R`

This code creates similar plots to the previous, however it does add data from other NERRs

### `04_chla_diff.R`

This code calculates differences between in vivo sensor measurements with extracted (in vitro) chlorophyll measurements.

### `05_swmp_load.R`

This code reads in gtmnerr swmp wq and nutrient data

### `06_swmp_plots-forNOV.R`

This code presents visuals of gtmnerr swmp data for the data update in November.

# CHLA-NERRS
Files for the Total Algae Chlorophyll Sensor Assessment project for the National Estuarine Research Reserve System

## R Code

Elaboration on the functions of each script

### `01_read_std.R`

Brings in the .csv file that has the standard information (for calibration of the fluorometer prior to each extraction). The information in this file is then used to create a linear regression between the standard and 90% acetone solutions to produce the best fit line. The slope of this line is then used as the normalization coefficient for all the relative fluorescence units for each sample for a particular date. 
This also brings in the `_chla_raw.csv files` for specified date in `rundate` and uses the slope of the standard information regression to produce a chlorophyll value in ug/L for each relative fluorescence unit.

*Outputs:* 

*   `_chla.csv` file with all the calculated chlorophyll information
*   `plot_std_..._chla.png` that has the calculated slope based on the standards used.
*   `plot_std_eq_..._ chla.png` has the R2, p, and equation for standard lines

### `02_exo_chla.R`

This code reads in each of the extracted chlorophyll files in the 'output/chla_ext' folder. 

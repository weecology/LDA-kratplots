# LDA-kratplots
## Repo for holding code for working on LDA analysis of krat exclosure plots

Project examining community dynamics on Portal krat exclosure plots. Based off original project which focused on control plots only: https://github.com/emchristensen/Extreme-events-LDA
This work expands on the original project by asking whether the rodent community present on the experimentally altered plots (altered by removing krats) experienced changes at the same time as the rodent community on the control plots. 

## Main Analysis Scripts: 
  * __rodent_LDA_analysis_exclosures.R__ main script for analyzing rodent community change using LDA
  * __rodent_LDA_analysis.R__ main script from original project, using control plot rodent data
  
## Auxiliary scripts:
  * __AIC_model_selection.R__ contains functions for calculating AIC for different candidate LDA models
  * __changepointmodel.r__ contains change-point model code
  * __LDA-distance.R__ function for computing Hellinger distance analyses
  * __rodent_data_for_LDA.R__ functions for creating Rodent_table_dat.csv
  * __readResults.R__
  * __RodentAbundancesAdjustable.R__
  
## Figure Scripts:
  * __NDVI_figure.R__ creates a timeseries of NDVI at the site from 1984-2015, to show periods of low resources
  * __abundance_plots.R__ contains code for plotting timeseries of total rodent abundance (Fig 2 in manuscript)
  * __LDA_figure_scripts.R__ contains functions for making main plots in manuscript (Fig 1). Called from rodent_LDA_analysis_exclosures.R
  
## Data files:
  * _exclosures_dat.csv_ table of rodent data from krat exclosure plots, created in rodent_LDA_analysis_exclosures.R
  * _exclosures_dates.csv_ table of dates corresponding to periods in exclosures_dat.csv
  * _Monthly_Landsat_NDVI.csv_ NDVI data for portal from Landsat satellites
  * _Rodent_table_dat.csv_ table of rodent data from control plots from original project

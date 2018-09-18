# LDA-kratplots
## Repo for holding code for working on LDA analysis of krat exclosure plots

Project examining community dynamics on Portal krat exclosure plots. Based off original project which focused on control plots only: https://github.com/emchristensen/Extreme-events-LDA
This work expands on the original project by asking whether the rodent community present on the experimentally altered plots (altered by removing krats) experienced changes at the same time as the rodent community on the control plots. 

## Main Analysis 
  * __compare_changepoint_distributions.R__ code for analyzing overlap of changepoint distributions from control plots and krat exclosures
  * __main_results_figures.R__ code for making Fig 1 and 2 in ms (multipart LDA and changepoint results)
  * __run-hg.R__ code for running analyses on hipergator
  * __whole-analysis.R__ main script for analyzing rodent community change using LDA. Pulls data from PortalData repo, manipulates it for input to LDA model, runs LDA models and model selection, runs changepoint model and model selection
  
## data folder
  * __paper_dat.csv__ Portal rodent data that was used in the original Extreme-events-LDA project
  
## figures folder
  * __baileys-population.R__ plot population time series of C. baileyi on control and krat exclosure plots (Fig 4 in ms)
  * __species-populations.R__ plot popultion time series of all species around 1990 changepoint (supplemental fig in ms)
  * __total_abundance_plots.r__ plot total abundance time series on control and krat exclosure plots (not used in ms, but was used in Extreme-events-LDA project)
  
## functions folder 
Contains scripts used by whole-analysis.R
  * __changepoint_histogram_plot.R__ function for plotting changepoint histograms (used by main_results_figures.R)
  * __convert_summary_to_dates.R__ function to convert output of changepoint model (in time steps) to dates for interpretation and plotting
  * __eval_changepoint_model.R__ functions for evaluating candidate changepoint models and doing model selection
  * __get-data.R__ function "get_rodent_lda_data" for extracting data from PortalData repo, using portalr package, and preparing it for input to LDA model
  * __lda_plot_function.R__ functions for visualizing output of LDA model: barplots of species composition of topics (from previous work in Extreme-events-LDA)
  * __plots_from_ldats.R__ functions for visualizing output of LDA model: timeseries (from LDATS package)
  * __run_changepoint_model.R__ function for running changepoint model, potentially with multiple numbers of changepoints
  * __select_LDA.R__ function "run_rodent_LDA" to run a bunch of LDA models and do model selection. Returns only the best LDA model.
  
## models folder
Contains .Rdata results files from runs done on hipergator

## previous-work folder
Contains code and data from Extreme-events-LDA repo (may or may not be completely up to date). 

## reports folder
Rmarkdown files and pdfs of results for facilitating discussion

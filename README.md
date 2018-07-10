# LDA-kratplots
## Repo for holding code for working on LDA analysis of krat exclosure plots

Project examining community dynamics on Portal krat exclosure plots. Based off original project which focused on control plots only: https://github.com/emchristensen/Extreme-events-LDA
This work expands on the original project by asking whether the rodent community present on the experimentally altered plots (altered by removing krats) experienced changes at the same time as the rodent community on the control plots. 

## Main Analysis 
  * __whole-analysis.R__ main script for analyzing rodent community change using LDA. Pulls data from PortalData repo, manipulates it for input to LDA model, runs LDA models and model selection, runs changepoint model and model selection
  
## data folder
  * __paper_dat.csv__ Portal rodent data that was used in the original Extreme-events-LDA project
  
## functions folder 
Contains scripts used by whole-analysis.R
  * __convert_summary_to_dates.R__ function to convert output of changepoint model (in time steps) to dates for interpretation and plotting
  * __eval_changepoint_model.R__ functions for evaluating candidate changepoint models and doing model selection
  * __get-data.R__ function "get_rodent_lda_data" for extracting data from PortalData repo, using portalr package, and preparing it for input to LDA model
  * __lda_plot_function.R__ functions for visualizing output of LDA model: barplots of species composition of topics (from previous work in Extreme-events-LDA)
  * __plots_from_ldats.R__ functions for visualizing output of LDA model: timeseries (from LDATS package)
  * __run_changepoint_model.R__ function for running changepoint model, potentially with multiple numbers of changepoints
  * __select_LDA.R__ function "run_rodent_LDA" to run a bunch of LDA models and do model selection. Returns only the best LDA model.
  
## previous-work folder
Contains code and data from Extreme-events-LDA repo (may or may not be completely up to date). 

## reports folder
Rmarkdown files and pdfs of results for facilitating discussion

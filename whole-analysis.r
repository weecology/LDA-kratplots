library(LDATS)
library(tidyverse)
library(RCurl)
library(portalr)

#### Get data #### 
# Functions to download data using portalr and prepare it for LDATS
source('functions/get-data.R')

# argument time_or_plots says whether to prioritize time (longer time series) or plots (more plots,
# but a shorter timeseries)
# treatment is control or exclosure
control_time = get_rodent_lda_data(time_or_plots = 'time', treatment = 'control')

#### Run LDAs ####
control_time_LDA = LDATS::LDA(data = select(control_time, -date), ntopics =  c(2, 3, 4, 5),
                              nseeds = 4, ncores = 4)

#### Select the best LDA (AICc) ####
control_time_LDA_use = LDATS:::LDA_select(lda_models = control_time_LDA, LDA_eval = quote(AIC), correction = TRUE,
                                 LDA_selector = quote(min))
# plot best lda topics (skip for now)
# plot(control_time_LDA_use)

#### Run change point model ####
# Prepare the covariate matrix with time, sin_year, and cos_year
document_covariate_matrix = select(control_time, 'date') %>%
  mutate(time = (1970 + as.integer(julian(date)) / 365.25)) %>%
  mutate(sin_year = sin(time * 2 * pi), cos_year = cos(time * 2 * pi)) %>%
  select(-date)

# Prepare arguments for LDATS
weights <- LDATS::doc_weights(select(control_time, -date))
formula <- quote("sin_year + cos_year")
nchangepoints <- c(2, 3)
selected = control_time_LDA_use

# Run models
mtss <- selected %>%
  LDATS::MTS_prep(document_covariate_matrix) %>%
  LDATS::MTS_set(formula, nchangepoints, weights) 

#### Changepoint model selection #### 

# Calculate deviance (?) for each changepoint model
# This calculation is taken from previous_work/paper/rodent_LDA_analysis.r line 113
changepoint_model_eval = function(changepoint_model, lda_model) {
  saved_lls = changepoint_model$lls
  ntopics = lda_model@k
  npoints =  changepoint_model$nchangepoints
  out = mean(saved_lls * -2) + 2*(3*(ntopics-1)*(npoints+1)+(npoints))
  return(out)
}

# Select the model with the lowest deviance
changepoint_model_select = function(model_set) {
  model_values = sapply(model_set, changepoint_model_eval, lda_model = selected)
  out = model_set[[which(model_values == min(model_values))]]
  return(out)
}


selected_changepoint_model = changepoint_model_select(mtss)

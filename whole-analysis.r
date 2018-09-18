
library(LDATS)
#library(RCurl)
library(portalr)

#### Get data #### 
# Functions to download data using portalr and prepare it for LDATS
source('functions/get-data.R')
source('functions/select_LDA.R')
source('functions/run_changepoint_model.R')
source('functions/eval_changepoint_model.R')

# argument time_or_plots says whether to prioritize time (longer time series) or plots (more plots,
# but a shorter timeseries)
# treatment is control or exclosure

#rodent_data = get_rodent_lda_data(time_or_plots = 'time', treatment = 'exclosure')
# using the same data as the paper:
#rodent_data = read.csv('paper_dat.csv', stringsAsFactors = FALSE, colClasses = c('Date', rep('integer', 21)))
#colnames(rodent_data)[1] <- 'date'



# rodent community on control plots -----

# get data and prepare for models
rodent_data = get_rodent_lda_data(time_or_plots = 'time', treatment = 'control', type = 'granivores')
time_data = select(rodent_data, period, date, newmoon, timestep)

rodent_data = rodent_data %>%
  select(-period, 
         -newmoon)

# run LDA
selected = run_rodent_LDA(rodent_data = rodent_data, topics_vector = c(2, 3, 4, 5, 6),
                          nseeds = 200, ncores = 4)

# run change point model
changepoint_models = run_rodent_cpt(rodent_data = rodent_data, selected = selected,
                                    changepoints_vector = c(2, 3, 4, 5, 6), samp_weights = 'allone')

changepoint = select_changepoint_model(changepoint_models)

# save output
save(rodent_data,
     time_data,
     selected,
     changepoint_models,
     changepoint,
     file = 'models/control_results.Rdata')


# analysis of rodent community on krat exclosure plots -----

# get data and prepare for models
rm(rodent_data,time_data,selected,changepoint_models,changepoint)

rodent_data = get_rodent_lda_data(time_or_plots = 'time', treatment = 'exclosure', type = 'granivores')
time_data = select(rodent_data, period, date, newmoon, timestep)

rodent_data = rodent_data %>%
  select(-period, 
         -newmoon)

# run LDA
selected = run_rodent_LDA(rodent_data = rodent_data, topics_vector = c(2, 3, 4, 5, 6),
                          nseeds = 200, ncores = 4)

# run change point model
changepoint_models = run_rodent_cpt(rodent_data = rodent_data, selected = selected,
                                    changepoints_vector = c(2, 3, 4, 5, 6), samp_weights = 'allone')

changepoint = select_changepoint_model(changepoint_models)

# save output
save(rodent_data,
     time_data,
     selected,
     changepoint_models,
     changepoint,
     file = 'models/exclosure_results.Rdata')

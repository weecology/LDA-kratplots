
library(LDATS)
library(RCurl)
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
 
rodent_data = get_rodent_lda_data(time_or_plots = 'time', treatment = 'control', type = 'granivores')


# rodent_data_control = get_rodent_lda_data(time_or_plots = 'time', treatment = 'control', type = 'granivores')
# rodent_data_exclosures = get_rodent_lda_data(time_or_plots = 'time', treatment = 'exclosure', type = 'granivores')
# 
# rodent_data_control = rodent_data_control %>%
#   filter(period %in% rodent_data_exclosures$period)
# 
# rodent_data = rodent_data_control[,2:16] + rodent_data_exclosures[,2:16]
# rodent_data = cbind(rodent_data, rodent_data_control[, c(1, 17:19)])


time_data = select(rodent_data, period, date, newmoon, timestep)

rodent_data = rodent_data %>%
  select(-period, 
         -newmoon)

selected = run_rodent_LDA(rodent_data = rodent_data, topics_vector = c(2, 3, 4, 5, 6),
                          nseeds = 200, ncores = 4)

# save(rodent_data, selected, time_data, file = 'models/lda_c_and_e.Rdata')

changepoint_models = run_rodent_cpt(rodent_data = rodent_data, selected = selected,
                             changepoints_vector = c(2, 3, 4, 5, 6), weights = 'allone')

changepoint = select_changepoint_model(changepoint_models)

save(rodent_data, time_data, selected, changepoint, changepoint_models, file = 'models/time_steps/ctrl_time_gran_wt1.Rdata')

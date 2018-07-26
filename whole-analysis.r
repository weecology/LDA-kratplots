
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


rodent_data_control = get_rodent_lda_data(time_or_plots = 'time', treatment = 'control', type = 'granivores')
rodent_data_exclosures = get_rodent_lda_data(time_or_plots = 'time', treatment = 'exclosure', type = 'granivores')

rodent_data_control$plot_type = 'control'
rodent_data_exclosures$plot_type = 'exclosure'

rodent_data_control = rodent_data_control %>%
   filter(period %in% rodent_data_exclosures$period)
# 
# rodent_data = rodent_data_control[,2:16] + rodent_data_exclosures[,2:16]
# rodent_data = cbind(rodent_data, rodent_data_control[, c(1, 17:19)])

rodent_data_all = rbind(rodent_data_control, rodent_data_exclosures)


time_data = select(rodent_data_all, period, date, newmoon, timestep)

rodent_data = rodent_data_all %>%
  select(-period, 
         -newmoon,
         -plot_type)

selected = run_rodent_LDA(rodent_data = rodent_data, topics_vector = c(2, 3, 4, 5, 6),
                          nseeds = 200, ncores = 4)

save(rodent_data, rodent_data_all, selected, time_data, file = 'models/lda_c_and_e_sameLDA.Rdata')

rodent_data_control <- rodent_data[ which(rodent_data_all$plot_type == 'control'), ]

selected_control <- selected
selected_control@gamma <- selected_control@gamma[ which(rodent_data_all$plot_type == 'control'), ]

changepoint_models_control = run_rodent_cpt(rodent_data = rodent_data_control, selected = selected_control,
                             changepoints_vector = c(2, 3, 4, 5, 6), weights = 'allone', ncores = 8)

changepoint_control = select_changepoint_model(changepoint_models_control)

save(rodent_data, 
     rodent_data_control,
     rodent_data_all, 
     time_data, 
     selected, 
     selected_control,
     changepoint_control, 
     changepoint_models_control, 
     file = 'models/oneLDA_control.Rdata')

rm(changepoint_control, changepoint_models_control, selected_control)

rodent_data_exclosures <- rodent_data[ which(rodent_data_all$plot_type == 'exclosure'), ]
selected_exclosures <- selected
selected_exclosures@gamma <- selected_exclosures@gamma[ which(rodent_data_all$plot_type == 'exclosure'), ]

changepoint_models_exclosures = run_rodent_cpt(rodent_data = rodent_data_exclosures, selected = selected_exclosures,
                                            changepoints_vector = c(2, 3, 4, 5, 6), weights = 'allone')

changepoint_exclosures = select_changepoint_model(changepoint_models_exclosures)

save(rodent_data, 
     rodent_data_exclosures,
     rodent_data_all, 
     time_data, 
     selected, 
     selected_exclosures,
     changepoint_exclosures, 
     changepoint_models_exclosures, 
     file = 'models/oneLDA_exclosures.Rdata')

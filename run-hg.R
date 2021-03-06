# install packages

# devtools::install_github(repo = 'weecology/LDATS', local = T)
# devtools::install_github(repo = 'weecology/portalr', local = T)

library(LDATS)
library(RCurl)
library(portalr)

#### Get data #### 
# Functions to download data using portalr and prepare it for LDATS
source('functions/get-data.R')
source('functions/select_LDA.R')
source('functions/run_changepoint_model.R')
source('functions/eval_changepoint_model.R')
# 
# rodent_data <- get_rodent_lda_data(time_or_plots = 'time', treatment = 'control', type = 'granivores')
# 
# print('loaded rodent data')
# 
# time_data <- select(rodent_data, period, date, newmoon, timestep)
# 
# rodent_data <- rodent_data %>%
#   select(-period, 
#          -newmoon)
# 
# selected <- run_rodent_LDA(rodent_data = rodent_data, topics_vector = c(2, 3, 4, 5, 6),
#                           nseeds = 200, ncores = 4)
# 
# print('ran LDA')
# 
# changepoint_models = run_rodent_cpt(rodent_data = rodent_data, selected = selected,
#                                             changepoints_vector = c(2, 3, 4, 5, 6), samp_weights = 'allone')
# 
# print("ran changepoint control")
# 
# changepoint = select_changepoint_model(changepoint_models)
# 
# print("selected changepoint control")
# 
# save(rodent_data, 
#      time_data, 
#      selected, 
#      changepoint_models,
#      changepoint,
#      file = 'models/control_hg.Rdata')
# 
# rm(list=ls())
# # 
# print("saved control")
# 
# 
# source('functions/get-data.R')
# source('functions/select_LDA.R')
# source('functions/run_changepoint_model.R')
# source('functions/eval_changepoint_model.R')
# 
# 
rodent_data <- get_rodent_lda_data(time_or_plots = 'time', treatment = 'exclosure', type = 'granivores')


time_data <- select(rodent_data, period, date, newmoon, timestep)

rodent_data <- rodent_data %>%
  select(-period,
         -newmoon)

selected <- run_rodent_LDA(rodent_data = rodent_data, topics_vector = c(2, 3, 4, 5, 6),
                           nseeds = 200, ncores = 4)


print("ran lDA")

changepoint_models = run_rodent_cpt(rodent_data = rodent_data, selected = selected,
                                    changepoints_vector = c(2, 3, 4, 5, 6), samp_weights = 'allone')
print("ran changepoint ex")

changepoint = select_changepoint_model(changepoint_models)
print("selected changepoint ex")

save(rodent_data,
     time_data,
     selected,
     changepoint_models,
     changepoint,
     file = 'models/exclosure_hg.Rdata')
print("saved ex")

q()
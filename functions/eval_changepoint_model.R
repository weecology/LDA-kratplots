#### Changepoint model selection ####
library(dplyr)
# Calculate deviance (?) for each changepoint model
# This calculation is taken from previous_work/rodent_LDA_analysis.r line 131
changepoint_model_eval = function(changepoint_model, lda_model) {
  saved_lls = changepoint_model$lls
  ntopics = lda_model@k
  npoints =  changepoint_model$nchangepoints
  out = mean(saved_lls * -2) + 2*(3*(ntopics-1)*(npoints+1)+(npoints))
  return(out)
}

# Add deviance to models
changepoint_model_eval_set = function(model_set) {
  for(i in 1:length(model_set)) {
    model_set[[i]]$deviance = changepoint_model_eval(model_set[[i]], lda_model = selected)
  }
  return(model_set)
}

select_changepoint_model = function(model_set) {
  deviance = NULL
  for(i in 1:length(model_set)) {
    deviance[i] = changepoint_model_eval(model_set[[i]], lda_model = selected)
  }
  changepoint = model_set[[ which(deviance == min(deviance))]]
  return(changepoint)
}


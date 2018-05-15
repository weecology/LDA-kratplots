run_rodent_cpt = function(rodent_data = rodent_data, selected = selected, 
                          changepoints_vector = c(2, 3, 4, 5)) {
  #### Run change point model ####
  # Prepare the covariate matrix with time, sin_year, and cos_year
  document_covariate_matrix = select(rodent_data, 'date') %>%
    mutate(time = (1970 + as.integer(julian(date)) / 365.25)) %>%
    mutate(sin_year = sin(time * 2 * pi), cos_year = cos(time * 2 * pi)) %>%
    select(-date)
  
  # Prepare arguments for LDATS
  weights <- LDATS::doc_weights(select(rodent_data, -date))
  formula <- quote("sin_year + cos_year")
  nchangepoints <- changepoints_vector
  nit = 1e3
  
  # Run models
  mtss <- selected %>%
    LDATS::MTS_prep(document_covariate_matrix) %>%
    LDATS::MTS_set(formula, nchangepoints, weights, nit) 
  
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
  
  return(selected_changepoint_model)
  
}
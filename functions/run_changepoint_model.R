run_rodent_cpt = function(rodent_data = rodent_data, selected = selected,
                          changepoints_vector = c(2, 3, 4, 5, 6), samp_weights = 'something') {
  #### Run change point model ####
  # Prepare the covariate matrix with time, sin_year, and cos_year
  document_covariate_matrix = select(rodent_data, 'date', 'timestep') %>%
    mutate(time = (1970 + as.integer(julian(date)) / 365.25)) %>%
    mutate(sin_year = sin(time * 2 * pi), cos_year = cos(time * 2 * pi)) %>%
    mutate(time = timestep) %>%
    select(-date, -timestep)

  # Prepare arguments for LDATS
 if(samp_weights == 'prop') {
   samp_weights <- LDATS::doc_weights(select(rodent_data, -date, -timestep))
 }
 if (samp_weights == 'allone'){
  samp_weights <- rep(1, length(rodent_data$timestep))
 }

  formula <- ~ sin_year + cos_year
  nchangepoints <- changepoints_vector
  nit = 1e5

  # Run models
  mtss <- selected %>%
    LDATS::MTS_prep(document_covariate_matrix) %>%
    LDATS::MTS_set(formula, nchangepoints, samp_weights, nit)

  # Add deviance
  mtss <- changepoint_model_eval_set(mtss)

  return(mtss)

}

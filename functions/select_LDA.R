run_rodent_LDA <- function(rodent_data, topics_vector = c(2, 3, 4, 5), nseeds = 200, ncores = 4){
  
  #### Run LDAs ####
  LDA_models = LDATS::LDA(data = select(rodent_data, -date), ntopics =  topics_vector,
                          nseeds = nseeds, ncores = ncores)
  
  #### Select the best LDA (AICc) ####
  selected = LDATS:::LDA_select(lda_models = LDA_models, LDA_eval = quote(AIC), correction = TRUE,
                                LDA_selector = quote(min))
  # plot best lda topics (skip for now)
  # plot(selected)
  return(selected)
}
  

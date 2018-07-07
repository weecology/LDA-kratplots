
convert_summary_to_dates <- function(cpt_model, time_data_table) {
  
  cps_summary <- summarize_cps(cpt_model$cps, prob = 0.95)
  
  cpt_summary_dates <- cps_summary %>%
    mutate(Mean = round(Mean), Median = round(Median), Upper = round(Upper), Lower = round(Lower))
  
  dates_table <- time_data_table %>%
    select(date, timestep)
  
  all_timesteps <-as.data.frame(seq(min(cpt_model$cps), max(cpt_model$cps), 1))
  
  colnames(all_timesteps) <- 'timestep'
  
  all_timesteps <- left_join(all_timesteps, dates_table, by = 'timestep')
  
  missing_timesteps <- which(is.na(all_timesteps$date)) 
  
  for (i in 1:length(missing_timesteps)) {
    all_timesteps$date[missing_timesteps[i]] <- all_timesteps$date[missing_timesteps[i] - 1] + 20
  }
  
  for (i in 1:4){
    
    colnames(all_timesteps) <- c(colnames(cpt_summary_dates)[i], 
                                 paste0(colnames(cpt_summary_dates)[i], '_date'))
    
    cpt_summary_dates <- left_join(cpt_summary_dates, all_timesteps, by = colnames(all_timesteps)[1])
    
  }
  
  cpt_summary_dates <- cpt_summary_dates %>%
    select(Mean_date, Median_date, Lower_date, Upper_date, SD, MCMCerr, AC10, ESS)
  
  return(cpt_summary_dates)
}

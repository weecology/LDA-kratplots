library(dplyr)
library(portalr)

get_plant_data <- function(time_or_plots = 'time', 
                           chosen_treatment = 'control') {
  if (tolower(time_or_plots) == 'plots') {
    min_month = 1
    min_year = 1988 
    filtered_plots = c(1:24)
  } else if(tolower(time_or_plots) == 'time') {
    filtered_plots = c(3, 4, 10, 11, 14, 15, 16, 17, 19, 21, 23)
    min_month = 7
    min_year = 1981
  }
  
  plants <- load_plant_data(path = "repo")
  
  quadrats <- plants$quadrat_data
  date_table <- plants$date_table
  plots_table <- plants$plots_table
  census_table <- plants$census_table
  
  date_table <- date_table %>%
    select(year, season, start_month) 
  
  month_nas <- which(is.na(date_table$start_month))
  for(i in 1:length(month_nas)) {
    thisrow = as.numeric(month_nas[i])
    if(date_table$season[thisrow] == 'summer'){ 
      date_table$start_month[thisrow] <- 7
    } else if (date_table$season[thisrow] == 'winter') {
      date_table$start_month[thisrow] <- 3
    }
  }
  
  plots_table <- plots_table %>%
    select(year, month, plot, treatment)
  
  quadrats <- plants$quadrat_data %>% 
    filter(plot %in% filtered_plots) %>%
    select(-cover, -cf) %>%
    left_join(date_table, by = c('year', 'season')) %>%
    mutate(month = start_month) %>%
    select(-start_month) %>%
    left_join(plots_table, by = c('year', 'month', 'plot')) %>%
    left_join(census_table, by = c('year', 'season', 'plot', 'quadrat'))
  
  
  quadrats_summary <- quadrats %>%
    filter(treatment %in% c('exclosure', 'control')) %>%
    select(year, month, season, treatment, plot, species, abundance, quadrat) %>%
    group_by(year, month, season, treatment, plot) %>%
    mutate(effort = length(unique(quadrat))) %>%
    ungroup() 
  
  quadrats_effort <- quadrats_summary %>%
    select(year, month, season, treatment, plot, effort) %>%
    distinct() %>%
    group_by(year, month, treatment) %>%
    summarize(effort = sum(effort)) %>%
    ungroup()
  
  quadrats_summary <- quadrats_summary %>%
    group_by(year, month, season, treatment) %>%
    summarize(total_n = sum(abundance), richness = length(unique(species))) %>%
    ungroup() %>%
    left_join(quadrats_effort, by = c('year', 'month', 'treatment')) %>%
    mutate(standardized_n = (total_n/effort) * 64) %>%
    mutate(standardized_n = as.integer(round(standardized_n)))
  
  quadrats_summary_out <- quadrats_summary %>%
    filter(treatment %in% chosen_treatment) %>%
    mutate(date = zoo::as.yearmon(paste(year, month), "%Y %m")) %>%
    select(date, season, treatment, richness, standardized_n)
  
  return(quadrats_summary_out)
}

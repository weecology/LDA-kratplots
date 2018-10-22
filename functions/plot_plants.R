library(ggplot2)
library(dplyr)
make_plant_plots <- function(plant_data){

  winter <- filter(plant_data, season == 'winter')
  
winter_n_plot <- ggplot(winter, aes(date, standardized_n)) +
  theme_minimal() +
  geom_point(aes(x = date, y = standardized_n, color= treatment)) +
  geom_line(aes(x = date, y = standardized_n, color= treatment)) +
  ggtitle("Total Winter abundance (standardized by effort)")

winter_s_plot <- ggplot(winter, aes(date, richness)) +
  theme_minimal() +
  geom_point(aes(x = date, y = richness, color= treatment)) + 
  geom_line(aes(x = date, y = richness, color= treatment)) +
  ggtitle("Winter Species richness")



summer <- filter(plant_data, season == 'summer')

summer_n_plot <- ggplot(summer, aes(date, standardized_n)) +
  theme_minimal() +
  geom_point(aes(x = date, y = standardized_n, color= treatment)) +
  geom_line(aes(x = date, y = standardized_n, color= treatment)) +
  ggtitle("Total Summer abundance (standardized by effort)")

summer_s_plot <- ggplot(summer, aes(date, richness)) +
  theme_minimal() +
  geom_point(aes(x = date, y = richness, color= treatment)) + 
  geom_line(aes(x = date, y = richness, color= treatment)) +
  ggtitle("Summer Species richness")


plant_plots <- list(winter_n_plot, winter_s_plot, summer_n_plot, summer_s_plot)

return(plant_plots) 
}

add_cpt_estimates <- function(plant_plot, estimates, npts) {
  if(length(estimates) == 4) {
  plant_plot = plant_plot + 
    geom_vline(xintercept=estimates[1], colour = 'red') + 
    geom_vline(xintercept=estimates[2], colour = 'red') + 
    geom_vline(xintercept=estimates[3], colour = 'red') + 
    geom_vline(xintercept=estimates[4], colour = 'red') 
  
  }
  
  if(length(estimates) == 1) {
    plant_plot = plant_plot + 
      geom_vline(xintercept=estimates, colour = 'red')
  }
  
  return(plant_plot)
  
}

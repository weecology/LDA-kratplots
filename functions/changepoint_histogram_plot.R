
#' @title changepoint histogram plot
#' @description makes histogram plot of changepoints from changepoint model result
#' 
#' @param changepoint output of changepoint model (select_changepoint_model() function)
#' @param rodent_data data frame of original data (from get_rodent_lda_data() function)
#' @param binwidth bin width of histogram (1 = 1 year)
#'
chpt_histogram_plot = function(changepoint, rodent_data, binwidth) {
  
  cps_gathered = tidyr::gather(as.data.frame(changepoint$cps), key = 'cpt', value = 'year_number', 1:changepoint$nchangepoints)
  
  cps_years <- dplyr::select(rodent_data, date, timestep) %>%
    mutate(date_numeric = 1970 + as.integer(julian(date)) / 365.25) %>%
    mutate(period = row_number()) %>%
    mutate(year_number = timestep)
  
  cps_gathered <- left_join(cps_gathered, cps_years, by='year_number')
  
  
  # from old code
  histoplot = ggplot(data = cps_gathered, aes(x=date_numeric)) +
    geom_histogram(data=subset(cps_gathered,cpt=='V1'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='black', alpha=.4) +
    geom_histogram(data=subset(cps_gathered,cpt=='V2'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='black', alpha=.4) +
    geom_histogram(data=subset(cps_gathered,cpt=='V3'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='black', alpha=.4) +
    geom_histogram(data=subset(cps_gathered,cpt=='V4'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='black', alpha=.4) +
    labs(x='',y='') +
    xlim(range(cps_years$date_numeric)) +
    scale_y_continuous(labels=c('0.00','0.20','0.40','0.60','0.80'),breaks = c(0,.2,.4,.6,.8)) +
    theme(axis.text=element_text(size=12),
          panel.border=element_rect(colour='black',fill=NA),
          panel.background = element_blank(),
          panel.grid.major = element_line(colour='grey90'),
          panel.grid.minor = element_line(colour='grey90')) 
  
  return(histoplot)
}


#' @title changepoint histogram plot
#' @description makes histogram plot of changepoints from changepoint model result
#' 
#' @param changepoint output of changepoint model (select_changepoint_model() function)
#' @param rodent_data data frame of original data (from get_rodent_lda_data() function)
#' @param binwidth bin width of histogram (1 = 1 year)
#'
compare_chpt = function(changepoint1, rodent_data1, changepoint2, rodent_data2, binwidth) {
  
  cps_gathered1 = tidyr::gather(as.data.frame(changepoint1$cps), key = 'cpt', value = 'year_number', 1:changepoint1$nchangepoints)
  
  cps_years1 <- dplyr::select(rodent_data1, date, timestep) %>%
    mutate(date_numeric = 1970 + as.integer(julian(date)) / 365.25) %>%
    mutate(period = row_number()) %>%
    mutate(year_number = timestep)
  
  cps_gathered1 <- left_join(cps_gathered1, cps_years1, by='year_number')
  
  cps_gathered2 = tidyr::gather(as.data.frame(changepoint2$cps), key = 'cpt', value = 'year_number', 1:changepoint2$nchangepoints)
  
  cps_years2 <- dplyr::select(rodent_data2, date, timestep) %>%
    mutate(date_numeric = 1970 + as.integer(julian(date)) / 365.25) %>%
    mutate(period = row_number()) %>%
    mutate(year_number = timestep)
  
  cps_gathered2 <- left_join(cps_gathered2, cps_years2, by='year_number')
  
  
  # from old code
  histoplot = ggplot(data = cps_gathered1, aes(x=date_numeric)) +
    geom_histogram(data=subset(cps_gathered1,cpt=='V1'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='black', alpha=.4) +
    geom_histogram(data=subset(cps_gathered1,cpt=='V2'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='black', alpha=.4) +
    geom_histogram(data=subset(cps_gathered1,cpt=='V3'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='black', alpha=.4) +
    geom_histogram(data=subset(cps_gathered1,cpt=='V4'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='black', alpha=.4) +
    labs(x='',y='') +
    geom_histogram(data=subset(cps_gathered2,cpt=='V1'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='red', alpha=.4) +
    geom_histogram(data=subset(cps_gathered2,cpt=='V2'), aes(y=..count../sum(..count..)), binwidth=binwidth, fill='red', alpha=.4) +
    xlim(range(cps_years1$date_numeric)) +
    scale_y_continuous(labels=c('0.00','0.20','0.40','0.60','0.80'),breaks = c(0,.2,.4,.6,.8)) +
    theme(axis.text=element_text(size=12),
          panel.border=element_rect(colour='black',fill=NA),
          panel.background = element_blank(),
          panel.grid.major = element_line(colour='grey90'),
          panel.grid.minor = element_line(colour='grey90')) 
  
  return(histoplot)
}

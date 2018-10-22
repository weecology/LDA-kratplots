library(LDATS)
library(multipanelfigure)
library(dplyr)
library(topicmodels)

source('functions/lda_plot_function.R')
source('functions/plots_from_ldats.R')
source('functions/convert_summary_to_dates.R')
source('functions/changepoint_histogram_plot.R')

# load result of LDA model selection -- LDA model is contained in variable called 'selected'



#' @title plot main combined results figure
#' @description makes multipart plot of species composition, LDA timeseries, and changepoint histogram
#'
#' @param ldamodel lda model object
#' @param rodent_data the original data that went into the lda model
#' @param topic_order vector: order to plot topics in topic species composition part
#' @param changepoint changepoint model object
#' @param color color of histogram plot
#'
combined_results_figure = function(ldamodel,rodent_data,topic_order,changepoint,color) {
  # topic composition bar plots
  ntopics = ldamodel@k
  dates = rodent_data$date
  
  composition = community_composition(ldamodel)
  # change column names to modern taxonomy of species
  colnames(composition)[colnames(composition)=='PB'] <- 'CB'
  colnames(composition)[colnames(composition)=='PH'] <- 'CH'
  colnames(composition)[colnames(composition)=='PP'] <- 'CP'
  colnames(composition)[colnames(composition)=='PI'] <- 'CI'
  # put columns in order of largest species to smallest
  composition = composition[,c('DS','DO','DM','CB','CH','PL','PM','PE','CP','CI','RF','RM','RO','BA','PF')]
  comp_plots = plot_community_composition_gg(composition,
                                             topic_order = topic_order,
                                             ylim=c(0,1))
  (figure_spcomp <- multi_panel_figure(
    width = c(30,30,30,30,30,30),
    height = c(50,50),
    panel_label_type = "none",
    column_spacing = 0, row_spacing = 0))
  figure_spcomp %<>% fill_panel(
    comp_plots[[1]],
    row = 1, column = 1:2)
  figure_spcomp %<>% fill_panel(
    comp_plots[[2]],
    row = 1, column = 3:4)
  figure_spcomp %<>% fill_panel(
    comp_plots[[3]],
    row = 1, column = 5:6)
  figure_spcomp %<>% fill_panel(
    comp_plots[[4]],
    row = 2, column = 2:3)
  figure_spcomp %<>% fill_panel(
    comp_plots[[5]],
    row = 2, column = 4:5)
  
  # plot LDA timeseries output
  timeseries_plot = plot_component_communities(ldamodel,ntopics,xticks = dates)
  
  # plot changepoint results
  histoplot = chpt_histogram_plot(changepoint, rodent_data, binwidth = .5,color)
  
  # combine into one figure
  (combined_fig 
    <- multi_panel_figure(
      width = c(5,200,5),
      height = c(100,60,60),
      panel_label_type = 'upper-alpha',
      column_spacing = 0))
  combined_fig %<>% fill_panel(
    figure_spcomp,
    row = 1, column = 2)
  combined_fig %<>% fill_panel(
    timeseries_plot,
    row = 2, column = 2)
  combined_fig %<>% fill_panel(
    histoplot,
    row = 3, column = 2)
  combined_fig
  
  
  return(combined_fig)
}



load("models/control_hg.Rdata")
fig_ctrl = combined_results_figure(selected,rodent_data,topic_order = c(3,5,2,4,1),changepoint,color='black')
fig_ctrl

save_multi_panel_figure(fig_ctrl,'figures/Results_fig_controls.tiff',dpi=600,compression='lzw')


load("models/exclosure_hg.Rdata")
fig_excl = combined_results_figure(selected,rodent_data,topic_order = c(5,4,1,2,3),changepoint,color='red')
fig_excl

save_multi_panel_figure(fig_excl,'figures/Results_fig_exclosures.tiff',dpi=600,compression='lzw')


# ===========================================
# comparing control and exclosure changepoints
load("models/control_hg.Rdata")
ctrl_changepoint <- changepoint
ctrl_dat <- rodent_data


load("models/exclosure_hg.Rdata")
excl_changepoint <- changepoint
excl_dat <- rodent_data

compare_chpt(ctrl_changepoint, ctrl_dat, excl_changepoint, excl_dat, .5)

summarize_cps(ctrl_changepoint$cps, prob = 0.95)
summarize_cps(excl_changepoint$cps, prob = 0.95)


# ============================================
# figure for exit seminar
plot_gamma2 = function(gamma_frame,topic_order,ylab='',colors=cbPalette) {
  ntopics = length(topic_order)
  g = ggplot2::ggplot(gamma_frame, aes(x=date,y=relabund,colour=community)) + 
    geom_line(size=1) +
    scale_y_continuous(name=ylab,limits=c(0,1)) +
    scale_x_date(name='') +
    theme(axis.text=element_text(size=12),
          axis.title=element_text(size=12),
          panel.background = element_rect(colour='white',fill='white'),
          panel.grid.major = element_line(colour = "gray90"),
          panel.grid.minor = element_line(colour = 'gray90'),
          panel.border=element_rect(colour='black',fill=NA),
          legend.position='right') +
    scale_colour_manual(name="Component\nCommunity",
                        breaks=as.character(topic_order),
                        values=colors[1:ntopics],
                        labels=as.character(seq(ntopics)))
  return(g)
}
plot_component_communities2 = function(ldamodel,ntopics,xticks,ylab='',topic_order = seq(ntopics)) {
  cbPalette <- c( "#e19c02","#999999", "#56B4E9", "#0072B2", "#D55E00", "#F0E442", "#009E73", "#CC79A7")
  z = posterior(ldamodel)
  ldaplot = data.frame(date = c(), relabund = c(), community = c())
  for (t in seq(ntopics)) {
    ldaplot = rbind(ldaplot, data.frame(date=xticks ,relabund=z$topics[,t], community = as.factor(rep(t,length(z$topics[,1])))))
  }
  g = plot_gamma2(ldaplot, topic_order, ylab, colors=cbPalette)
  return(g) 
}

ldatsplot = plot_component_communities2(selected,ntopics,xticks=dates,ylab='',topic_order = c(3,5,2,4,1))
ldatsplot
ggsave('C:/Users/EC/Desktop/lda_ts.png',ldatsplot,width=11,height=4)
# =============================================
# combined LDA: plot timeseries
#load('models/lda_c_and_e_sameLDA.Rdata') #controls and krat exclosures in same model
#timeseries_plot = plot_component_communities(selected,ntopics,xticks = rodent_data_all$date[rodent_data_all$plot_type == 'exclosure'],
#                                             select_samples = which(rodent_data_all$plot_type == 'exclosure'))


#plot_lda_edited(selected, time_data$date, select_samples = which(rodent_data_all$plot_type == 'exclosure'))
#ggsave('LDA_topic_ts_exclosures.png',plot=timeseries_plot,width=8,height=2.5)



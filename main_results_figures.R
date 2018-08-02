library(LDATS)
library(multipanelfigure)
library(dplyr)

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
#'
combined_results_figure = function(ldamodel,rodent_data,topic_order,changepoint) {
  # topic composition bar plots
  ntopics = ldamodel@k
  dates = rodent_data$date
  
  composition = community_composition(ldamodel)
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
  histoplot = chpt_histogram_plot(changepoint, rodent_data, binwidth = .5)
  
  # combine into one figure
  (combined_fig 
    <- multi_panel_figure(
      width = c(5,200,5),
      height = c(100,60,60),
      panel_label_type = 'none',
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



load("ctrl_time_gran_wt1.Rdata")
fig_ctrl = combined_results_figure(selected,rodent_data,topic_order = c(3,5,2,4,1),changepoint)
fig_ctrl

save_multi_panel_figure(fig_ctrl,'Results_fig_controls.tiff',dpi=600,compression='lzw')
#ggsave('Results_fig_controls2.png',plot=fig_ctrl,width=8,height=5)

load("excl_time_gran_wt1.Rdata")
fig_excl = combined_results_figure(selected,rodent_data,topic_order = c(5,4,1,2,3),changepoint)
fig_excl

save_multi_panel_figure(fig_excl,'Results_fig_exclosures.tiff',dpi=600,compression='lzw')


# ===========================================
# comparing control and exclosure changepoints
load("ctrl_time_gran_wt1.Rdata")
ctrl_changepoint <- changepoint
ctrl_dat <- rodent_data


load("excl_time_gran_wt1.Rdata")
excl_changepoint <- changepoint
excl_dat <- rodent_data

compare_chpt(ctrl_changepoint, ctrl_dat, excl_changepoint, excl_dat, 1/12)

summarize_cps(ctrl_changepoint$cps, prob = 0.95)
summarize_cps(excl_changepoint$cps, prob = 0.95)


# =============================================
# combined LDA: plot timeseries
#load('models/lda_c_and_e_sameLDA.Rdata') #controls and krat exclosures in same model
#timeseries_plot = plot_component_communities(selected,ntopics,xticks = rodent_data_all$date[rodent_data_all$plot_type == 'exclosure'],
#                                             select_samples = which(rodent_data_all$plot_type == 'exclosure'))


#plot_lda_edited(selected, time_data$date, select_samples = which(rodent_data_all$plot_type == 'exclosure'))
#ggsave('LDA_topic_ts_exclosures.png',plot=timeseries_plot,width=8,height=2.5)


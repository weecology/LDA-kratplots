library(fitdistrplus)
library(stats)
library(dplyr)
library(RCurl)
library(ggplot2)
# scripts for making supporting figures in the extreme events/ LDA project



# ==============================================
# Abundance figure in manuscript (Figure 2)

# total abundance
load("ctrl_time_gran_wt1.Rdata")
load("excl_time_gran_wt1.Rdata")
dat <- rodent_data

# data frame of abundance by period - restricted to only complete censuses
abund_dat = data.frame(timestep=dat$timestep, date=dat$date, n = rowSums(dat[,1:15]))
abund_dat$density = abund_dat$n/2 # density is in rodents/hectare: each plot is 1/4 hectare, there are 8 control plots, so total area covered by control plots is 2 hectares

# finding data in the lowest .15 fraction of the data. 
fitdistrplus::descdist(abund_dat$n, discrete=TRUE)
fit.negbin = fitdistrplus::fitdist(abund_dat$n, "nbinom")
plot(fit.negbin)
dist_size = fit.negbin$estimate[[1]]
dist_mu = fit.negbin$estimate[[2]]
crit_value = qnbinom(.15, size=dist_size, mu=dist_mu)
abund_dat$extreme = ifelse(abund_dat$n < crit_value, 1,0)



# in ggplot
chpts = data.frame(x1=c(as.Date('1983-12-01'),as.Date('1988-10-01'),as.Date('1998-09-01'),as.Date('2009-06-01')),
                   x2=c(as.Date('1984-07-01'),as.Date('1996-01-01'),as.Date('1999-12-01'),as.Date('2010-09-01')),
                   y1=c(-20,-20,-20,-20),y2=c(130,130,130,130))
ggplot(abund_dat,aes(x=date,y=log(density))) +
#  coord_cartesian(ylim=c(-10,60)) +
  #geom_rect(data=chpts, inherit.aes=F,aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2), alpha=0.5) +
  geom_line(size=1) +  
  geom_point(size=1.6, aes(fill = as.factor(abund_dat$extreme)),colour='black',pch=21) +
  #geom_hline(yintercept = mean(abund_dat$density),linetype=2) +
  labs(x='',y='rodent density\n(rodents per hectare)') +
  theme(axis.text=element_text(size=11),
        axis.title=element_text(size=12)) +
  scale_fill_manual(values = c('#000000',"#56B4E9")) +
  #annotate("text", x=as.Date('1994-01-01'), y=-3.5, label= "Drought",fontface=2,size=3) +
  #annotate("text", x=as.Date('1983-08-01'), y=-3.5, label= "Storm", fontface=2,size=3) +
  #annotate("text", x=as.Date('1999-08-01'), y=-3.5, label= "Storm", fontface=2,size=3) +
  #annotate("text", x=as.Date('2009-06-01'), y=-3.5, label= "Drought",fontface=2,size=3) +
  #geom_segment(aes(x=as.Date('1993-09-01'), xend=as.Date('1994-10-01'), y=-10, yend=-10),size=1) +
  #geom_segment(aes(x=as.Date('1993-09-01'), xend=as.Date('1993-09-01'), y=-12, yend=-8), size=1) +
  #geom_segment(aes(x=as.Date('1994-10-01'), xend=as.Date('1994-10-01'), y=-12, yend=-8), size=1) +
  #geom_segment(aes(x=as.Date('2009-01-01'), xend=as.Date('2009-12-31'), y=-10, yend=-10),size=1) +
  #geom_segment(aes(x=as.Date('2009-01-01'), xend=as.Date('2009-01-01'), y=-12, yend=-8), size=1) +
  #geom_segment(aes(x=as.Date('2009-12-31'), xend=as.Date('2009-12-31'), y=-12, yend=-8), size=1) +
  #geom_point(size=2, inherit.aes=F,aes(x=as.Date('1983-10-01'),y=-10),pch=15) +
  #geom_point(size=2, inherit.aes=F,aes(x=as.Date('1999-08-15'),y=-10),pch=15) +
  theme(legend.position = 'none') 

ggsave(filename='Abundance_ctrl.tiff',width=6,height=2.8,units='in',dpi=600,compression='lzw')



extreme = abund_dat[abund_dat$extreme==1,]
plot(abund_dat$date,log(abund_dat$density),xlab='',ylab='log(abundance)',pch=16)
lines(abund_dat$date,log(abund_dat$density))
points(extreme$date,log(extreme$density),col='red',pch=16)
abline(h=mean(log(abund_dat$density)),lty=2)


# =====================================================================
# For presentation

library(multipanelfigure)
source('functions/lda_plot_function.R')

# abundance lined up with LDA output
abund = ggplot(abund_dat,aes(x=date,y=log(density))) +
  #  coord_cartesian(ylim=c(-10,60)) +
  geom_line(size=1) +  
  geom_point(size=1.6, aes(fill = as.factor(abund_dat$extreme)),colour='black',pch=21) +
  labs(x='',y='rodent density\n(rodents per hectare)') +
  theme(axis.text=element_text(size=13),
        axis.title=element_text(size=13),
        legend.position = 'none',
        panel.background = element_rect(colour='white',fill='white'),
        panel.grid.major = element_line(colour = "gray90"),
        panel.grid.minor = element_line(colour = 'gray90'),
        panel.border=element_rect(colour='black',fill=NA)) +
  scale_fill_manual(values = c('#000000',"#56B4E9"))

# LDA time series plot
timeseries_plot = plot_component_communities(selected,ntopics=5,xticks = rodent_data$date)
timeseries_plot

(abund_fig 
  <- multi_panel_figure(
    width = c(5,200,5),
    height = c(60,60),
    panel_label_type = 'none',
    column_spacing = 0,
    row_spacing = 0))
abund_fig %<>% fill_panel(
  timeseries_plot,
  row = 1, column = 2)
abund_fig %<>% fill_panel(
  abund,
  row = 2, column = 2)
abund_fig

save_multi_panel_figure(abund_fig,'C:/Users/EC/Desktop/Abundance_timeseries.tiff',dpi=600,compression='lzw')

library(portalr)
library(ggplot2)
library(dplyr)


# create plot of C. baileyi population on control and kangaroo rat removal plots over time


dat = abundance('repo',shape='flat',level='Plot',time='date',min_plots=1)


pb = dplyr::filter(dat,species=='PB',
                   censusdate>as.Date('1995-07-20'),
                   censusdate<as.Date('2015-03-27'),
                   treatment %in% c('control','exclosure'))  %>%
  group_by(censusdate,treatment) %>%
  summarise(mean_abund=mean(abundance,na.rm=T))


pbplot = ggplot(pb,aes(x=censusdate,y=mean_abund,color=treatment)) +
  geom_line() +
  labs(x='',y='C. baileyi\nabundance') +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        panel.background = element_rect(colour='white',fill='white'),
        panel.grid.major = element_line(colour = "gray90"),
        panel.grid.minor = element_line(colour = 'gray90'),
        panel.border=element_rect(colour='black',fill=NA)) +
  scale_colour_manual(name = 'Plot type', values = c('black','red'),
                      breaks=c('control','exclosure'),
                      labels=c("Control", "Kangaroo rat\n removal")) +
  geom_vline(xintercept=as.Date('2010-01-15'),color='red',size=1.2) +
  geom_vline(xintercept=as.Date('2009-12-15'),color='black',size=1.2) +
  geom_vline(xintercept=as.Date('1999-07-15'),color='black',size=1.2) +
  geom_vline(xintercept=as.Date('1997-06-15'),color='red',size=1.2)
pbplot

# save to file
ggsave(filename='Baileys.tiff',pbplot,width=6,height=2,units='in',dpi=600,compression='lzw')

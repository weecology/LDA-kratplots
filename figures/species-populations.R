library(portalr)
library(ggplot2)
library(dplyr)
library(cowplot)

dat = abundance('repo',shape='flat',level='Plot',time='date',min_plots=1)

# ===============================================================
# populations of all species simultaneously
theme_set(theme_bw())
rodents_1 = filter(dat,censusdate>as.Date('1985-01-01'),
                   censusdate<as.Date('1995-01-01'),
                   treatment=='exclosure',
                   species %in% c('BA','DM','DO','DS','PB','PE','PF','PM','PP','RM','RF','RO','PH','PI','PL')) %>% 
  mutate(year=as.numeric(format(censusdate,'%Y')),
         month=as.numeric(format(censusdate,'%m'))) 
rodents_1$season = rodents_1$year
rodents_1$season[rodents_1$month>6] = rodents_1$season[rodents_1$month>6]+.5 
rodents_1 = rodents_1 %>%
  group_by(season,treatment,species) %>% 
  summarise(mean_abund=mean(abundance,na.rm=T)) %>%
  mutate(density = mean_abund*4)
# rename species based on modern taxonomy: PB=CB etc
rodents_1$species = plyr::revalue(rodents_1$species, c("PB"="CB", "PP"="CP", "PH"="CH", "PI"="CI")) 
rodents_1$species <- factor(rodents_1$species, levels = c('DS','DO','DM','CB','CH','PL','PM','PE','CP','CI','RF','RM','RO','BA','PF'))
krem = ggplot(rodents_1,aes(x=season,y=density,color=species)) + 
  geom_line() + 
  ggtitle('Kangaroo Rat Removal Plots') + 
  labs(x='',y='Abundance \n(individuals/hectare)') + 
  geom_vline(xintercept = 1990.5,size=1.5) +
  scale_x_continuous(breaks=c(1985:1995),labels=c(1985:1995))



rodents_2 = filter(dat,censusdate>as.Date('1985-01-01'),
                   censusdate<as.Date('1995-01-01'),
                   treatment=='control',
                   species %in% c('BA','DM','DO','DS','PB','PE','PF','PM','PP','RM','RF','RO','PH','PI','PL')) %>% 
  mutate(year=as.numeric(format(censusdate,'%Y')),
         month=as.numeric(format(censusdate,'%m'))) 
rodents_2$season = rodents_2$year
rodents_2$season[rodents_2$month>6] = rodents_2$season[rodents_2$month>6]+.5 
rodents_2 = rodents_2 %>%
  group_by(season,treatment,species) %>% 
  summarise(mean_abund=mean(abundance,na.rm=T)) %>%
  mutate(density = mean_abund*4)
# rename species based on modern taxonomy: PB=CB etc
rodents_2$species = plyr::revalue(rodents_2$species, c("PB"="CB", "PP"="CP", "PH"="CH", "PI"="CI")) 
rodents_2$species <- factor(rodents_2$species, levels = c('DS','DO','DM','CB','CH','PL','PM','PE','CP','CI','RF','RM','RO','BA','PF'))
ctrl = ggplot(rodents_2,aes(x=season,y=density,color=species)) + 
  geom_line() + 
  ggtitle('Control Plots') + 
  labs(x='',y='Abundance \n(individuals/hectare)') + 
  geom_vline(xintercept = 1990.5,size=1.5) +
  scale_x_continuous(breaks=c(1985:1995),labels=c(1985:1995))

  
# combine plots 
two_plots <- plot_grid(ctrl + theme(legend.position = 'none'),
                       krem + theme(legend.position = 'none'),
                       align = 'vh',
                       labels = c("A", "B"),
                       hjust = -1,
                       nrow = 2)
legend1 <- get_legend(ctrl)
pop_plots <- plot_grid(two_plots, legend1, rel_widths = c(3, .6))
pop_plots
ggsave('Populations_1990.png',pop_plots,width=6,height=6)

# one species at a time -----
get_sp_dat = function(dat,sp) {
  sp_dat = dplyr::filter(dat,species %in% sp,
                     censusdate>as.Date('1985-01-01'),
                     censusdate<as.Date('2005-12-31'),
                     treatment %in% c('control','exclosure'))  %>%
    mutate(year=as.numeric(format(censusdate,'%Y')),
           month=as.numeric(format(censusdate,'%m')))
  sp_dat$season = sp_dat$year
  sp_dat$season[sp_dat$month>6] = sp_dat$season[sp_dat$month>6]+.5
  sp_dat = sp_dat %>%
    group_by(season,treatment) %>%
    summarise(mean_abund=mean(abundance,na.rm=T))
  return(sp_dat)
}

plot_species = function(dat,ylabel) {
  spplot = ggplot(dat,aes(x=season,y=mean_abund,color=treatment)) +
    geom_line() +
    labs(x='',y=ylabel) +
    scale_colour_manual(name = 'Plot type', values = c('black','red'),
                        breaks=c('control','exclosure'),
                        labels=c("Control", "Kangaroo rat\n removal")) +
    theme(axis.text=element_text(size=12),
          axis.title=element_text(size=12),
          panel.background = element_rect(colour='white',fill='white'),
          panel.grid.major = element_line(colour = "gray90"),
          panel.grid.minor = element_line(colour = 'gray90'),
          panel.border=element_rect(colour='black',fill=NA)) +
    geom_vline(xintercept=1990.33,color='black',size=1.2)
  return(spplot)
}


# # plots of what subordinate species are doing around 1990 changepoint

pe = get_sp_dat(dat,'PE')
pf = get_sp_dat(dat,'PF')
pm = get_sp_dat(dat,'PM')
rm = get_sp_dat(dat,'RM')
pp = get_sp_dat(dat,'PP')
dm = get_sp_dat(dat,'DM')
do = get_sp_dat(dat,'DO')
ds = get_sp_dat(dat,'DS')
ba = get_sp_dat(dat,'BA')

rmpe = data.frame(season = pe$season,treatment=pe$treatment, mean_abund = pe$mean_abund+rm$mean_abund+pf$mean_abund+pm$mean_abund,pp$mean_abund+ba$mean_abund)
rmpeplot = plot_species(rmpe,'Small Granivores')
rmpeplot

peplot = plot_species(pe,'P. eremicus\nabundance')
peplot
pfplot = plot_species(pf,'P. flavus\nabundance')
pfplot
pmplot = plot_species(pm,'P. maniculatus\nabundance')
pmplot
rmplot = plot_species(rm,'R. megalotis\nabundance')
rmplot
baplot = plot_species(ba,'B. taylori')
baplot

ppplot = plot_species(pp,'C. penicillatus')
ppplot
dmplot = plot_species(dm,'D. merriami')
dmplot
doplot = plot_species(do,'D. ordii')
doplot
dsplot = plot_species(ds,'D. spectabilis')
dsplot

# save to file
#ggsave(filename='PE.tiff',peplot,width=6,height=2,units='in',dpi=600,compression='lzw')
#ggsave(filename='PF.tiff',pfplot,width=6,height=2,units='in',dpi=600,compression='lzw')
#ggsave(filename='PM.tiff',pmplot,width=6,height=2,units='in',dpi=600,compression='lzw')
#ggsave(filename='RM.tiff',rmplot,width=6,height=2,units='in',dpi=600,compression='lzw')
#ggsave(filename='RM_PE.tiff',rmpeplot,width=6,height=2,units='in',dpi=600,compression='lzw')


# focus on RM and PE
rm = rm %>% mutate(year=as.numeric(floor(season)))
rmbox = ggplot(rm,aes(x=as.factor(year),y=mean_abund, colour=treatment)) +
  geom_boxplot() #+
  #ggtitle('Kangaroo rat abundances 2013-2015') +
  #scale_colour_manual(values=cbPalette) +
  #labs(y = 'Count', x = NULL) +
  #scale_x_discrete(breaks=c("CC","EC","XC"),
  #                 labels=c("long-term\n control", "kangaroo rat\n removal", "rodent\n removal")) +
  #theme(legend.position = 'none')
rmbox




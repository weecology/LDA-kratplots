# populations of dominant (most abundant) species showed most pronounced differences before/after break points

library(dplyr)
library(portalr)
library(bfast)
library(ggplot2)

source('functions/get-data.R')

# ================================================
# functions ----

#' @title compare species populations before and after a given changepoint
#' @param dat_long rodent abundance data in long form
#' @param cp_timestep the timestep where the changepoint occurs
#' @param interval interval in months before/after changepoint for which to compare species populations
#' 
species_pop_change = function(dat_long, cp_timestep, interval) {
  # select the data around the changepoint
  dat_c_1 = dplyr::filter(dat_long,timestep>cp_timestep-interval, timestep<cp_timestep+interval)
  # make variable for before/after breakpoint
  dat_c_1$timeperiod = rep(NA)
  dat_c_1$timeperiod = ifelse(dat_c_1$timestep<cp_timestep, 1, 2)
  dat_c_1$timeperiod = as.factor(dat_c_1$timeperiod)
  print(ggplot(dat_c_1, aes(x=timestep, y=abundance, color=species)) +
    geom_line() +
    geom_vline(xintercept=cp_timestep))
  
  # before/after significance of each species
  species_change_significant = data.frame()
  for (sp in unique(dat_c_1$species)) {
    sp_c_1 = filter(dat_c_1, species==sp)
    
    summ_stats = plyr::ddply(sp_c_1, 'timeperiod', summarize,
                             mean=mean(abundance, na.rm=T),
                             sd = sd(abundance, na.rm=T))
    mean_before = summ_stats$mean[which(summ_stats$timeperiod==1)]
    mean_after = summ_stats$mean[which(summ_stats$timeperiod==2)]
    sd_before = summ_stats$sd[which(summ_stats$timeperiod==1)]
    sd_after = summ_stats$sd[which(summ_stats$timeperiod==2)]
    pct_change = (mean_after-mean_before)/mean_before
    sp.mod = lm(abundance~timeperiod, data=sp_c_1)
    A = anova(sp.mod)
    pval = A$`Pr(>F)`[1]
    species_change_significant = rbind(species_change_significant,cbind(sp,mean_before,mean_after,pct_change,pval))
  }
  species_change_significant$mean_before = as.numeric(as.character(species_change_significant$mean_before))
  return(species_change_significant[order(species_change_significant$mean_before,decreasing=T),])
}

# load rodent data from portalr
dat = get_rodent_lda_data(time_or_plots = 'time', treatment = 'control', type = 'granivores')
dat_long = gather(dat, species, abundance, BA:RO)

# load results of LDA/changepoint model to get changepoint locations -- control plots (these numbers are with reference to timestep from dat)
load("models/control_hg.Rdata")
ctrl_changepoint <- changepoint
c_summary <- LDATS::summarize_rhos(ctrl_changepoint$cps)
c_cp1 = c_summary$Mean[1]
c_cp2 = c_summary$Mean[2]
c_cp3 = c_summary$Mean[3]
c_cp4 = c_summary$Mean[4]

interval = 36 # number of months to compare before/after changepoint

species_pop_change(dat_long, c_cp1, interval)
species_pop_change(dat_long, c_cp2, interval)
species_pop_change(dat_long, c_cp3, interval)
species_pop_change(dat_long, c_cp4, interval)

# load results of LDA/changepoint model to get changepoint locations -- krat exclosure plots
dat_excl = get_rodent_lda_data(time_or_plots = 'time', treatment = 'exclosure', type = 'granivores')
dat_long_excl = gather(dat_excl, species, abundance, BA:RO)

load("models/exclosure_hg.Rdata")
excl_changepoint <- changepoint
e_summary <- LDATS::summarize_rhos(excl_changepoint$cps)
e_cp1 = e_summary$Mean[1]
e_cp2 = e_summary$Mean[2]

species_pop_change(dat_long_excl, e_cp1, interval)
species_pop_change(dat_long_excl, e_cp2, interval)

species_pop_change(dat_long_excl, c_cp4, interval)



# # ===================================================================
# dat$species = as.character(dat$species)
# targetsp = c('DS','DO','DM','PB','PH','PL','PM','PE','PP','PI','RF','RM','RO','BA','PF')
# 
# dat_means = aggregate(dat$abundance, by=list(species=dat$species, treatment=dat$treatment, period=dat$period), FUN=mean)
# 
# # load results of LDA/changepoint model to get changepoint locations -- control plots
# load("models/control_hg.Rdata")
# ctrl_changepoint <- changepoint
# c_summary <- LDATS::summarize_rhos(ctrl_changepoint$cps)
# 
# # select changepoint
# cp1 = c_summary$Mean[3]
# cp1 = 256.5 #cp3
# cp1 = 380.5 #cp4
# # select data
# dat_c_1 = dplyr::filter(dat,treatment=='control',period>cp1-24,period<cp1+24)
# dat_means_c_1 = dplyr::filter(dat_means,treatment=='control',period>cp1-24,period<cp1+24)
# # plot data and mean by species
# ggplot(dat_c_1, aes(x=period, y=abundance, color=species)) +
#   geom_jitter(alpha=.2) +
#   geom_line(data=dat_means_c_1, aes(x=period, y=x, color=species),size=2) +
#   geom_vline(xintercept=cp1)
# 
# # make variable for before/after breakpoint
# dat_c_1$timeperiod = rep(NA)
# dat_c_1$timeperiod = ifelse(dat_c_1$period<cp1,1,2)
# dat_c_1$timeperiod = as.factor(dat_c_1$timeperiod)
# 
# # before/after significance of each species
# species_change_significant = data.frame()
# for (sp in targetsp) {
#   sp_c_1 = filter(dat_c_1, species==sp)
#   sp_sum = aggregate(sp_c_1$abundance, by=list(period=sp_c_1$period, timeperiod=sp_c_1$timeperiod), FUN=sum)
#   summ_stats = plyr::ddply(sp_sum, 'timeperiod', summarize,
#                            mean=mean(x, na.rm=T),
#                            sd = sd(x, na.rm=T))
#   mean_before = summ_stats$mean[which(summ_stats$timeperiod==1)]
#   mean_after = summ_stats$mean[which(summ_stats$timeperiod==2)]
#   sd_before = summ_stats$sdn[which(summ_stats$timeperiod==1)]
#   sd_after = summ_stats$sd[which(summ_stats$timeperiod==2)]
#   sp.mod = lm(x~timeperiod, data=sp_sum)
#   A = anova(sp.mod)
#   pval = A$`Pr(>F)`[1]
#   species_change_significant = rbind(species_change_significant,cbind(sp,mean_before,mean_after,sd_before,sd_after,pval))
# }
# species_change_significant

# # ====================================================================
# # where is biggest one-month drop?
# sp_avg$diff1mo = c(NA,diff(sp_avg$x))
# sp_avg[sp_avg$diff1mo==min(sp_avg$diff1mo, na.rm=T),]
# 
# bfast.fit <- bfast(sp_avg$x, season="harmonic",h=0.15, max.iter=10)

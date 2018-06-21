library(dplyr)
library(portalr)
library(RCurl)

# Functions to download data using portalr and prepare it for LDATS
source('functions/get-data.R')


newdat = get_rodent_lda_data(time_or_plots = 'time', treatment = 'control', type = 'granivores')
olddat = read.csv('paper_dat.csv')


# Using LDATS ========================================================================
# run LDAs
lda_models = LDATS::parLDA(dat = select(newdat, -date), ntopics =  c(2,3,4,5,6),
                           nseeds = 200, ncores = 4)
# calculate AIC
lda_eval <- sapply(lda_models, quote(AIC)) %>% matrix(ncol = 1)

# get number of topics from each LDA model
topics = c()
for (n in seq(length(lda_eval))) {
  topics = c(topics,lda_models[[n]]@k)
}

AIC_topics = data.frame(aic = lda_eval,topics=topics)
new_new = boxplot(AIC_topics$aic~AIC_topics$topics,xlab='# of topics',ylab='AIC', main='new data / new method')

# find absolute min
AIC_topics[AIC_topics$aic==min(AIC_topics$aic),]

# find average min
aggregate(AIC_topics$aic,by=list(topics=AIC_topics$topics),FUN=mean)

# Old way ============================================================================
# copied from previous-work/rodent_LDA_analysis.r

source('previous-work/AIC_model_selection.R')
# alter function from above script so it returns all aic values not just min per seed
repeat_VEM_all = function(dat,seeds,topic_min,topic_max) {
  purrr::map_df(seeds, 
                ~ aic_model(dat,SEED=.x,topic_min,topic_max)) %>% 
    #filter(aic == min(aic))) %>% 
    return()
}

# repeat LDA model fit and AIC calculation with a bunch of different seeds
seeds = 2*seq(200)

best_ntopic = repeat_VEM_all(select(newdat, -date),
                         seeds,
                         topic_min=2,
                         topic_max=6)

new_old = boxplot(best_ntopic$aic~best_ntopic$k,xlab='# of topics',ylab='AIC',main='new data / old method')

# find absolute min
best_ntopic[best_ntopic$aic==min(best_ntopic$aic),]

# find average min
aggregate(best_ntopic$aic,by=list(topics=best_ntopic$k),FUN=mean)

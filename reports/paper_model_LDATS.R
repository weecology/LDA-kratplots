library(LDATS)
library(topicmodels)
library(RCurl)
library(multipanelfigure)
library(reshape2)


source('previous-work/rodent_data_for_LDA.r')
source('previous-work/AIC_model_selection.R')
source('previous-work/LDA_figure_scripts.R')
source('changepointmodel.r')
source('previous-work/LDA-distance.R')

dat <- read.csv('paper_dat.csv', stringsAsFactors = F)

dates <- dat[,1]
dat <- dat[,2:22]

seeds = 2*seq(200)

# repeat LDA model fit and AIC calculation with a bunch of different seeds to test robustness of the analysis
best_ntopic = repeat_VEM(dat,
                         seeds,
                         topic_min=2,
                         topic_max=6)

# histogram of how many seeds chose how many topics
hist(best_ntopic$k,breaks=c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5),xlab='best # of topics', main='')


# ==================================================================
# 2b. how different is species composition of 4 community-types when LDA is run with different seeds?
# ==================================================================
# get the best 100 seeds where 4 topics was the best LDA model
seeds_4topics = best_ntopic %>% 
  filter(k == 4) %>% 
  arrange(aic) %>% 
  head(100) %>% 
  pull(SEED)
 

# best seed for 4 is 
# choose seed with highest log likelihood for all following analyses
#    (also produces plot of community composition for 'best' run compared to 'worst')
best_seed = calculate_LDA_distance(dat,seeds_4topics, k =4)
mean_dist = unlist(best_seed)[2]
max_dist = unlist(best_seed)[3]

# ==================================================================
# 3. run LDA model
# ==================================================================
ntopics = 4
SEED = unlist(best_seed)[1]  # For the paper, I use seed 206

ldamodel= LDA(dat,ntopics, control = list(seed = SEED),method='VEM')

#### Prepare paper LDA for LDATS cpt ####

library(LDATS)
source('functions/run_changepoint_model.R')
dat$date <- as.Date(dates)

changepoint = run_rodent_cpt(rodent_data = dat, selected = ldamodel,
                             changepoints_vector = c(2, 3, 4, 5, 6))

save(dat, ldamodel, changepoint, file = 'models/paperLDA_LDATScpt.Rdata')


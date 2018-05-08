# # installing portalr as of May 7 2018 11:07 am
# 
# #devtools::install_github("weecology/portalr")
# 
# 
# library(tidyverse)
# 
# library(portalr)
# 
# dat <- abundance(path = "repo", clean = FALSE, 
#                         level = 'Plot', type = "Rodents", length = 'all', 
#                         unknowns = FALSE, fill_incomplete = F, shape = 'crosstab',
#                         time = 'period', effort = TRUE, min_plots = 0)
# 
# erica_controlplots = c(2,4,8,11,12,14,17,22)
# 
# dat2 <- dat %>%
#   filter(treatment == 'control', period %in% 1:436,
#          ntraps >= 1, plot %in% erica_controlplots) %>%
#   mutate(effort = 1) %>%
#   group_by(period) %>%
#   summarise_at(c(colnames(dat)[5:25], 'effort'), sum)
# 
# 
# for(i in 1:nrow(dat2)) {
#   thiseffort = dat2[i, 'effort']
#   for (j in 2:22) {
#   dat2[i,j] = round((dat2[i, j] / thiseffort) * 8)
#   }
# }
# 
# 
# compare = dat2[, 2:22]
# 
# source('LDA-distance.R')
# 
# # ===================================================================
# # 1. prepare rodent data
# # ===================================================================
# ericadat = create_rodent_table(period_first = 1,
#                           period_last = 436,
#                           selected_plots = c(2,4,8,11,12,14,17,22),
#                           selected_species = c('BA','DM','DO','DS','NA','OL','OT','PB','PE','PF','PH','PI','PL','PM','PP','RF','RM','RO','SF','SH','SO'))
# 
# 
# compare = compare - ericadat
# sum(compare)

get_exclosure_rodents = function() {
library(tidyverse)

library(portalr)

dat <- abundance(path = "repo", clean = FALSE, 
                 level = 'Plot', type = "Rodents", length = 'all', 
                 unknowns = FALSE, fill_incomplete = F, shape = 'crosstab',
                 time = 'period', effort = TRUE, min_plots = 0)


dat2 <- dat %>%
  filter(treatment == 'exclosure', period %in% 118:436,
         ntraps >= 1) %>%
  mutate(effort = 1) %>%
  group_by(period) %>%
  summarise_at(c(colnames(dat)[5:25], 'effort'), sum)


for(i in 1:nrow(dat2)) {
  thiseffort = dat2[i, 'effort']
  for (j in 2:22) {
    dat2[i,j] = round((dat2[i, j] / thiseffort) * 8)
  }
}

dat2 = dat2 [,2:22]

return(dat2)
}
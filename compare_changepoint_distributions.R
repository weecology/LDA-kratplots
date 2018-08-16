library(dplyr)
library(permute)

source('functions/changepoint_histogram_plot.R')
# comparing control and exclosure changepoints


# =============================================================
# load results of analysis run on hipergator
load("models/control_hg.Rdata")
ctrl_changepoint <- changepoint
ctrl_dat <- rodent_data


load("models/exclosure_hg.Rdata")
excl_changepoint <- changepoint
excl_dat <- rodent_data

# plot them
compare_chpt(ctrl_changepoint, ctrl_dat, excl_changepoint, excl_dat, binwidth=1/12)

# we're interested in the 4th changepoint from controls and the 2nd from exclosures
cp_ctrl = ctrl_changepoint$cps[,4]
cp_excl = excl_changepoint$cps[,2]


# changepoint overlap ----

# number of reps of each value of cp
ctrl_table = as.data.frame(table(cp_ctrl))
colnames(ctrl_table) <- c('cp','n_control')
ctrl_table$cp = as.character(ctrl_table$cp)
excl_table = as.data.frame(table(cp_excl))
colnames(excl_table) <- c('cp','n_excl')
excl_table$cp = as.character(excl_table$cp)

full_table = full_join(ctrl_table,excl_table,by='cp')
full_table[is.na(full_table)] <- 0

# find minimum of each count (represents area under both curves)
full_table <- full_table %>% rowwise() %>% mutate(min=min(c(n_control,n_excl)))

# what % of total changepoint estimates are under both curves
(2*sum(full_table$min))/(length(cp_ctrl)+length(cp_excl))


# compare the 1997 krat exclosure changepoint to 1999 control changepoint -----
cp_ctrl2 = ctrl_changepoint$cps[,3]
cp_excl2 = excl_changepoint$cps[,1]

# changepoint overlap ----
# number of reps of each value of cp
ctrl_table2 = as.data.frame(table(cp_ctrl2))
colnames(ctrl_table2) <- c('cp','n_control')
ctrl_table2$cp = as.character(ctrl_table2$cp)
excl_table2 = as.data.frame(table(cp_excl2))
colnames(excl_table2) <- c('cp','n_excl')
excl_table2$cp = as.character(excl_table2$cp)

full_table2 = full_join(ctrl_table2,excl_table2,by='cp')
full_table2[is.na(full_table2)] <- 0

# find minimum of each count (represents area under both curves)
full_table2 <- full_table2 %>% rowwise() %>% mutate(min=min(c(n_control,n_excl)))
# what % of total changepoint estimates are within the range of overlap

(2*sum(full_table2$min))/(length(cp_ctrl2)+length(cp_excl2))



# ====================================================================
# some tests -- are the changepoints the same?
# 
# # Kolmogorov-Smirnoff test on 2010 changepoint from both communities
# ks.test(cp_ctrl,cp_excl)
# 
# # wilcox test
# wilcox.test(cp_ctrl,cp_excl,alternative='two.sided')
# 
# # permutation test (following https://cran.r-project.org/web/packages/permute/vignettes/permutations.pdf)
# meanDif <- function(x,grp) {
#   abs(mean(x[grp == "C"]) - mean(x[grp == "E"]))
# }
# 
# ctrl_2010 = data.frame(cpt=cp_ctrl[1:1000], treatment=rep('C'))
# excl_2010 = data.frame(cpt=cp_excl[1:1000], treatment=rep('E'))
# 
# test = rbind(ctrl_2010,excl_2010)
# 
# # permutations
# Dchpoint <- numeric(length = 5000)
# N <- nrow(test)
# set.seed(42)
# for(i in seq_len(length(Dchpoint) - 1)) {
#   perm <- shuffle(N)
#   Dchpoint[i] <- with(test, meanDif(cpt, treatment[perm]))
#   }
# Dchpoint[5000] <- with(test, meanDif(cpt, treatment))
# 
# hist(Dchpoint, breaks='Sturges',main = "",
#      xlab = expression("Mean difference"))
# rug(Dchpoint[5000], col = "red", lwd = 2)
# 
# # conclusion: the means are different. but the difference is only 2 months. so...

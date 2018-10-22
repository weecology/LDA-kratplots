library(dplyr)

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
chpt_comparison = compare_chpt(ctrl_changepoint, ctrl_dat, excl_changepoint, excl_dat, binwidth=1/2)
ggsave(filename='figures/changepoint_comparison.tiff',chpt_comparison,width=6,height=2,units='in',dpi=600,compression='lzw')

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

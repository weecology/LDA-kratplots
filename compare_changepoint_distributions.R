library(dplyr)
library(permute)

# comparing control and exclosure changepoints


# =============================================================
# load results of analysis run on hipergator
load("models/control_hg.Rdata")
ctrl_changepoint <- changepoint
ctrl_dat <- rodent_data


load("models/exclosure_hg.Rdata")
excl_changepoint <- changepoint
excl_dat <- rodent_data

# we're interested in the 4th changepoint from controls and the 2nd from exclosures
cp_ctrl = ctrl_changepoint$cps[,4]
cp_excl = excl_changepoint$cps[,2]

# ====================================================================
# some tests -- are the changepoints the same?

# Kolmogorov-Smirnoff test on 2010 changepoint from both communities
ks.test(cp_ctrl,cp_excl)

# wilcox test
wilcox.test(cp_ctrl,cp_excl,alternative='two.sided')

# permutation test (following https://cran.r-project.org/web/packages/permute/vignettes/permutations.pdf)
meanDif <- function(x,grp) {
  mean(x[grp == "C"]) - mean(x[grp == "Ex"])
}

ctrl_2010 = data.frame(cpt=cp_ctrl, treatment=rep('C'))
excl_2010 = data.frame(cpt=cp_excl, treatment=rep('E'))

test = rbind(ctrl_2010,excl_2010)

# permutations
Dchpoint <- numeric(length = 5000)
N <- nrow(test)
set.seed(42)
for(i in seq_len(length(Dchpoint) - 1)) {
  perm <- shuffle(N)
  Dchpoint[i] <- with(test, meanDif(cpt, treatment[perm]))
  }
Dchpoint[5000] <- with(test, meanDif(cpt, treatment))

hist(Dchpoint, breaks='Sturges',main = "",
     xlab = expression("Mean difference"))
rug(Dchpoint[5000], col = "red", lwd = 2)

# conclusion: the means are different. but the difference is only 2 months. so...

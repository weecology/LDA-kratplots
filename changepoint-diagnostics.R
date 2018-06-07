library(LDATS)
load('models/excl_time_gran.Rdata')

str(changepoint)

plot(1:ncol(changepoint$lls_full), changepoint$lls_full[1, ], type = 'n')
lines(changepoint$lls_full[1, ], col = 'grey')
lines(changepoint$lls_full[2,], col = 'grey')
lines(changepoint$lls_full[3, ], col ='grey')
lines(changepoint$lls_full[4, ], col = 'grey')
lines(changepoint$lls_full[5, ], col = 'grey')
lines(changepoint$lls_full[6, ], col = 'grey')
lines(changepoint$lls, col = 'black')


plot(1:nrow(changepoint$cps), changepoint$cps[,1 ], type ='n')
lines(changepoint$cps[, 1], col = 'grey')
lines(x = 1:nrow(changepoint$cps), y = rep(mean(changepoint$cps[,1]), nrow(changepoint$cps)), col = 'red')

plot(1:nrow(changepoint$cps), changepoint$cps[,2 ], type ='n')
lines(changepoint$cps[,2], col = 'grey')
lines(x = 1:nrow(changepoint$cps), y = rep(mean(changepoint$cps[,2]), nrow(changepoint$cps)), col = 'red')

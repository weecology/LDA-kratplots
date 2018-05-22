plot_LDA <- function(x, ..., cols = NULL){
  
  gamma <- x@gamma
  beta <- exp(x@beta)
  nobs <- nrow(gamma)
  ntopics <- ncol(gamma)
  nwords <- ncol(beta)
  beta_order <- apply(beta, 2, order)
  beta_sorted <- apply(beta, 2, sort)
  
  if (length(cols) == 0){
    cols <- rgb(runif(ntopics), runif(ntopics), runif(ntopics))
  }
  if (length(cols) == 1){
    if (cols == "greys"){
      ggg <- runif(ntopics, 0, 0.8)
      cols <- rep(NA, ntopics)
      for (i in 1:ntopics){
        cols[i] <- rgb(ggg[i], ggg[i], ggg[i])
      }
    }
  }
  if (length(cols) > ntopics){
    cols <- cols[1:ntopics]
  }
  
  counter <- 1
  rect_mat <- matrix(NA, nrow = nwords * ntopics, ncol = 4)
  rect_col <- rep(NA, length = nwords * ntopics)
  for (i in 1:nwords){
    x1 <- i - 0.4
    x2 <- i + 0.4
    y1 <- 0
    y2 <- 0
    for (j in 1:ntopics){
      y1 <- y2
      y2 <- y1 + beta_sorted[j, i]
      rect_mat[counter, ] <- c(x1, y1, x2, y2)      
      rect_col[counter] <- cols[beta_order[j, i]]
      counter <- counter + 1
    }
  }
  
  par(fig = c(0, 1, 0, 0.7), mar = c(3.25, 4, 1, 1))
  plot(gamma[ , 1], type = "n", bty = "L", xlab = "", ylab = "", las = 1,
       ylim = c(0, 1))
  mtext(side = 1, "Observation", line = 2.2, cex = 1.25)
  mtext(side = 2, "Proportion", line = 2.8, cex = 1.25)
  for (i in 1:ntopics){
    points(gamma[ , i], col = cols[i], type = "l", lwd = 1)
  }
  
  par(fig = c(0, 0.85, 0.7, 1), new = TRUE, mar = c(1, 3, 1, 0))
  max_y <- max(rect_mat[,4]) * 1.05
  plot(1, 1, type = "n", bty = "L", xlab = "", ylab = "", las = 1,
       ylim = c(0, max_y), xlim = c(1, nwords), xaxt = "n", cex.axis = 0.75)  
  mtext(side = 2, "Total Proportion", line = 2.125, cex = 0.75)
  for(i in 1:(nwords * ntopics)){
    rect(rect_mat[i, 1], rect_mat[i, 2], rect_mat[i, 3], rect_mat[i, 4],
         col = rect_col[i])
  }
  axis(2, at = seq(0, max_y, 0.1), labels = FALSE, tck = -0.02)
  mtext(side = 1, at = seq(1, nwords, 1), text = x@terms, tck = 0, 
        cex = 0.5, line = 0)
  
  par(fig = c(0.85, 1, 0.7, 1), new = TRUE, mar = c(0, 0, 0, 0))
  plot(1, 1, type = "n", bty = "n", xlab = "", ylab = "", 
       xaxt = "n", yaxt = "n", ylim = c(0, 1), xlim = c(0,1))
  
  ypos <- (0.9 / ntopics) * (ntopics:1)
  ttext <- paste("Topic ", 1:ntopics, sep = "")
  for (i in 1:ntopics){
    text(ttext[i], x = 0.1, y = ypos[i], col = cols[i], adj = 0, cex = 0.75)
  }
  
}
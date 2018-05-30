library(dplyr)
library(ggplot2)

#' ggplot version of plot_community_composition
#' 
#' @param composition matrix of species composition of topics; as in output of community_composition()
#' @param topic_order order of topics -- for making this bar graph relate to the component community graph
#' @param ylim vector of limits for yaxis
#' 
#' @return barplots of the n component communities
#' 
#' 
#' 
plot_community_composition_gg = function(composition,topic_order,ylim,title=T) {
  cbPalette <- c( "#e19c02","#999999", "#56B4E9", "#0072B2", "#D55E00", "#F0E442", "#009E73", "#CC79A7")
  
   topics = dim(composition)[1]
  community = c()
  for (j in 1:topics) {community=append(community,rep(j,length(composition[j,])))}
  relabund = c()
  for (j in 1:topics) {relabund=append(relabund,composition[j,])}
  species=c()
  for (j in 1:topics) {species=append(species,colnames(composition))}
  comp = data.frame(community = community,relabund=relabund,species=factor(species, levels = colnames(composition)))
  grass = comp %>%
    filter(species %in% c('BA','PH','DO','DS','PF','PL','PM','RF','RO','RM','SH','SF','SO'))
  p = list()
  j = 1
  for (i in topic_order) {
    if (j == 1) {ylabel='% Composition'} else {ylabel=''}
    x <- ggplot(data=comp[comp$community==i,], aes(x=species, y=relabund)) +
      geom_bar(stat='identity',fill=cbPalette[i])  +
      geom_bar(data=grass[grass$community==i,],aes(x=species,y=relabund),fill=cbPalette[i],stat='identity',alpha=0,size=1,color='black') +
      theme(axis.text=element_text(size=10),
            panel.background = element_blank(),
            panel.border=element_rect(colour='black',fill=NA),
            axis.text.x = element_text(angle = 90,hjust=0,vjust=.5),
            plot.margin = unit(c(0,1,0,0),"mm"),
            axis.text.y = element_text(angle=0,size=9,vjust=.5,hjust=.5),
            plot.title = element_text(hjust = 0.5)) +
      scale_x_discrete(name='') +
      scale_y_continuous(name=ylabel,limits = ylim) +
      geom_hline(yintercept = 0)  +
      if (title==T) {ggtitle(paste('Community-type',j))} else {ggtitle('')}
    
    p[[j]] <- x
    j=j+1
  }
  
  return(p)
}



#' Make table of species composition of topics
#' 
#' @param ldamodel  object of class LDA_VEM created by the function LDA in topicmodels package
#' 
#' @return table of species composition of the topics in ldamodel, 3 decimal places
#' 
#' @example community_composition(ldamodel)

community_composition = function(ldamodel) {
  return(structure(round(exp(ldamodel@beta), 3), dimnames = list(NULL, ldamodel@terms)))
}


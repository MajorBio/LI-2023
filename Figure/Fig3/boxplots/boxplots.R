#!/usr/bin/env Rscript
setwd("./")


# Libraries
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(dplyr)
library(ggplot2)
library(ggpubr)

kf<-read.csv("kf.csv",header=T)

kfa<-kf[,c(2,8)]


kfaa<-kfa[-which(kfa$chrA01_3098245 %in% "NN"),]


compare_means(ASV3382 ~ chrA01_3098245,  data = kfaa,
              ref.group = ".all.", method = "t.test")


for (i in 2:7) {

  kfaa<-kf[-which(kf[,i] %in% "NN"),c(i,8)]
  lists<-list()
  ty<-unique(kfaa[,1])
  la<- list( c(1, 2), c(1, 3), c(2, 3) )
  for (j in 1:3) {
    lists[[j]]<-ty[la[[j]]]
  }
  #Visualize the expression profile
  p<-ggboxplot(kfaa, x = colnames(kfaa)[1], y = "ASV3382", color = "black",
               add = "jitter", legend = "none") +
    rotate_x_text(angle = 45) +
    geom_hline(yintercept = mean(kfaa[,2]), linetype = 2)+ # Add horizontal line at base mean
    stat_compare_means(method = "anova",label.y = max(kfaa[,2])*1.5 )+        # Add global annova p-value
    stat_compare_means(comparisons = lists,label = "p.signif", method = "t.test",
                       ref.group = ".all.")+ylab("Relative abundance")

  pdf(paste(colnames(kfaa)[1],".pdf",sep=""),width = 3,height = 5)
  print(p)
  dev.off()

  #png(paste(colnames(kfaa)[1],".png",sep=""),width = 1000,height = 800)
  #print(p)
  #dev.off()

}


yl<-read.csv("yl.csv",header=T)

yla<-yl[,c(2,7)]

compare_means(ASV3382 ~ chrA01_3098245,  data = kfaa,
              ref.group = ".all.", method = "t.test")


for (i in 2:6) {
  #ylaa<-yl[-which(yl[,i] %in% "NN"),c(i,7)]

  if(length(which(yl[,i] %in% "NN")) >0){
    ylaa<-yl[-which(yl[,i] %in% "NN"),c(i,7)]
  }else{
    ylaa<-yl[,c(i,7)]
  }

  #kfaa<-kf[-which(kf[,i] %in% "NN"),c(i,8)]
  lists<-list()
  ty<-unique(ylaa[,1])
  la<- list( c(1, 2), c(1, 3), c(2, 3) )
  for (j in 1:3) {
    lists[[j]]<-ty[la[[j]]]
  }
  #Visualize the expression profile
  p<-ggboxplot(ylaa, x = colnames(ylaa)[1], y = "ASV3382", color = "black",
               add = "jitter", legend = "none") +
    rotate_x_text(angle = 45) +
    geom_hline(yintercept = mean(ylaa[,2]), linetype = 2)+ # Add horizontal line at base mean
    stat_compare_means(method = "anova",label.y = max(ylaa[,2])*1.5 )+        # Add global annova p-value
    stat_compare_means(comparisons = lists,label = "p.signif", method = "t.test",
                       ref.group = ".all.")+ylab("Relative abundance")

  pdf(paste(colnames(ylaa)[1],".pdf",sep=""),width = 3,height = 5)
  print(p)
  dev.off()

  #png(paste(colnames(kfaa)[1],".png",sep=""),width = 1000,height = 800)
  #print(p)
  #dev.off()

}





setwd("D:\\PROJECT\\linannan\\R")


#if (!require("BiocManager", quietly = TRUE))
 # install.packages("BiocManager")
#BiocManager::install("ComplexHeatmap")
#devtools::install_github("jokergoo/circlize")

library(ComplexHeatmap)
library(circlize)
library(RColorBrewer)
library(gridBase)
#color <- grDevices::colors()[grep("gr(a|e)y", grDevices::colors(), invert = T)]
#rcolor <- color[sample(1:length(color), length(color))]

load("circos_heatmap.RData")

#WGCNA
#dat<-read.csv("ASV_WGCNA.csv")

dat1<-as.matrix(dat[,-1])
rownames(dat1)<-dat[,1]
max(dat1)
min(dat1)

col_fun1 <-colorRamp2(c(-0.6,-0.4,-0.2,0,0.2,0.4,0.5,0.6),colorspace::diverge_hsv(8) )#c("blue","green")


dat2<-as.matrix(dat[,1])
rownames(dat2)<-dat[,1]
colnames(dat2)<-"ASV"

modul<-as.matrix(dat$ASV)
modul<-as.matrix(c(1:203),203,1)
rownames(modul)<-dat$ASV
colnames(modul)<-"ASV"
col_gene_type = structure(dat$ASV, names = unique(dat$ASV))

#datp<-read.csv("ASV_GP.csv",header = T)

dat3<-as.matrix(datp[,-1])
rownames(dat3)<-datp[,1]
max(dat3)
min(dat3)

col_fun2 <-colorRamp2(c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.8),
                      colorspace::diverge_hsv(8))


#datrad_kf<-read.csv("rads.csv",header = T)

dat4<-as.matrix(datrad_kf[,-1])
rownames(dat4)<-datrad_kf[,1]
max(dat4)
min(dat4)


col_fun3<-colorRamp2(c(0,0.0006,0.0012,0.01,0.02,0.03,0.05,0.07),
                     colorspace::diverge_hsv(8))


#datpre_kf<-read.csv("prevalence.csv",header = T)

dat5<-as.matrix(datpre_kf[,-1])
rownames(dat5)<-datpre_kf[,1]
max(dat5)
min(dat5)


col_fun4<-colorRamp2(c(0,0.1,0.2,0.3,0.4,0.5,0.55,0.6),
                     colorspace::diverge_hsv(8))

#datrad_yl<-read.csv("yl.rad.csv",header = T)

dat6<-as.matrix(datrad_yl[,-1])
rownames(dat6)<-datrad_yl[,1]
max(dat6)
min(dat6)



col_fun5<-colorRamp2(c(0,0.0002,0.0006,0.002,0.008,0.01,0.02,0.045),
                     colorspace::diverge_hsv(8))

#datpre_yl<-read.csv("yl.prevalence.csv",header = T)

dat7<-as.matrix(datpre_yl[,-1])
rownames(dat7)<-datpre_yl[,1]
max(dat7)
min(dat7)


col_fun6<-colorRamp2(c(0,0.1,0.2,0.3,0.4,0.5,0.55,0.6),
                     colorspace::diverge_hsv(8))


#legends
lgd = Legend(title = "", col_fun = col_fun1,direction = "vertical",pch = 18)
lgd1 = Legend(title = "", col_fun = col_fun2,direction =  "vertical",pch = 18)
lgd2 = Legend(title = "", col_fun = col_fun3,direction =  "vertical",pch = 18)
lgd3 = Legend(title = "", col_fun = col_fun4,direction =  "vertical",pch = 18)
lgd4 = Legend(title = "", col_fun = col_fun5,direction =  "vertical",pch = 18)
lgd5 = Legend(title = "", col_fun = col_fun6,direction =  "vertical",pch = 18)


circlize_plot = function() {

  #circos.heatmap(modul, col =col_gene_type , rownames.side = "outside",
           #      rownames.cex = 0.7,rownames.col=col_gene_type,
             #    track.height = 0.03)

  #circos.clear()

  circos.heatmap(dat1,  col = col_fun1,
                 #rownames.col = 1:nrow(mat1) %% 10 + 1,
                 #rownames.cex = runif(nrow(mat1), min = 0.3, max = 2),
                 cluster = FALSE, track.height = 0.25)
  #circos.heatmap(dat1,  col = col_fun1,
                 #rownames.col = 1:nrow(mat1) %% 10 + 1,
                 #rownames.cex = runif(nrow(mat1), min = 0.3, max = 2),
                 #cluster = FALSE, track.height = 0.25,rownames.side = "outside")
  circos.heatmap(dat3,  col = col_fun2,
                 #rownames.col = 1:nrow(mat1) %% 10 + 1,
                 #rownames.cex = runif(nrow(mat1), min = 0.3, max = 2),
                 cluster = FALSE, track.height = 0.05)
  circos.heatmap(dat4,  col = col_fun3,
                 #rownames.col = 1:nrow(mat1) %% 10 + 1,
                 #rownames.cex = runif(nrow(mat1), min = 0.3, max = 2),
                 cluster = FALSE, track.height = 0.05)

  circos.heatmap(dat5,  col = col_fun4,
                 #rownames.col = 1:nrow(mat1) %% 10 + 1,
                 #rownames.cex = runif(nrow(mat1), min = 0.3, max = 2),
                 cluster = FALSE, track.height = 0.05)
  circos.heatmap(dat6,  col = col_fun5,
                 #rownames.col = 1:nrow(mat1) %% 10 + 1,
                 #rownames.cex = runif(nrow(mat1), min = 0.3, max = 2),
                 cluster = FALSE, track.height = 0.05)
  circos.heatmap(dat7,  col = col_fun6,
                 #rownames.col = 1:nrow(mat1) %% 10 + 1,
                 #rownames.cex = runif(nrow(mat1), min = 0.3, max = 2),
                 cluster = FALSE, track.height = 0.05)
  #d <- dist(dat1)
  # Hierarchical clustering dendrogram
  #hc <- as.dendrogram(hclust(d))
  #max_height = max(sapply(hc, function(x) attr(x, "height")))
  #circos.track(ylim = c(0, max_height), bg.border = NA, track.height = 0.3,
               #panel.fun = function(x, y) {
                 #dend = hc
                 #circos.dendrogram(dend, max_height = max_height)
               #})
  #row_ind = sample(203, 203)
  #pos = circos.heatmap.get.x(row_ind)
  #anno = rep("no", 203)
  #anno[row_ind] = "yes"
  #circos.heatmap(anno, col = c("no" = "purple", "yes" = "white"), track.height = 0.01)

  #circos.labels(pos$sector, pos$x, labels = rownames(dat5),cex = 0.3)
  #text(0, 0, 'rownames.side = "outside"')
  circos.clear()
}


pdf("circos.heatmap.pdf",width = 12,height = 7,onefile = T)

plot.new()
circle_size = unit(1, "snpc") # snpc unit gives you a square region

pushViewport(viewport(x = 0, y = 0.5, width = circle_size, height = circle_size,
                      just = c("left", "center")))
par(omi = gridOMI(), new = TRUE)
circlize_plot()
upViewport()


h = dev.size()[2]
lgd_list = packLegend(lgd, lgd1,lgd2, lgd3,lgd4, lgd5, max_height = unit(0.9*h, "inch"))
draw(lgd_list, x = circle_size, just = "left")

dev.off()

circos.clear()

graphics.off()


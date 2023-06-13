#!/usr/bin/env Rscript
setwd("./")

library("CMplot")

KF.linear <- read.table("KF/ASV3382/ASV3382.assoc.linear", header = T)
YL.linear <- read.table("YL/ASV3382/ASV3382.assoc.linear", header = T)

KF.linear$log10P <- -log10(KF.linear$P)
YL.linear$log10P <- log10(YL.linear$P)

KF.linear$SNP2 <- paste("KF", KF.linear$SNP, sep = "_")
YL.linear$SNP2 <- paste("YL", YL.linear$SNP, sep = "_")

total <- data.frame(SNP = c(KF.linear$SNP2, YL.linear$SNP2),
                    Chromosome = c(KF.linear$CHR, YL.linear$CHR),
                    Position = c(KF.linear$BP, YL.linear$BP),
                    ASV3382 = c(KF.linear$log10P, YL.linear$log10P))


#total<-total[-which(is.na(total[,4])),]

total<-total[-which(total[,4] %in% "Inf"),]

total<-total[-which(total[,4] %in% "-Inf"),]

min(total$ASV3382)

max(total$ASV3382)

total$SNP<-as.factor(total$SNP)

SNPs <- total[abs(total[,4])>5.037157, ]

SNPs <- SNPs[abs(SNPs[,2]) ==c(1,9), 1]

SNPs<-SNPs[c(1,7,8)]
SNPs<-c(SNPs,"KF_chr9:28105728")

chr<-read.csv("chr.csv",header=F)


CMplot(total, type = "p", plot.type = "m", LOG10 = F, threshold =c(5.10902,-5.037157),
       cex = 1,amplify = T,chr.labels = chr$V1,
       #threshold.lty=c(2,2), threshold.lwd=c(1,1), threshold.col=c("black","red"),
       ylim = c(-8, 8),chr.labels.angle=45,
       highlight=SNPs,
       #highlight.col=c("red"),
       #highlight.cex=1,#highlight.pch=c(15:17),
       highlight.text=SNPs,
       #highlight.text.col=c("green"),
       #       threshold.col = "gray35", threshold.lwd = 1, threshold.lty = 2, amplify = F,
       file = "jpg", memo = "",
       dpi = 2000,
       file.output = T, verbose = T,
       width = 14, height = 6,
       ylab = expression(-log[10](italic(P))),
       cex.lab = 1,
       #       highlight = plot_data[plot_data$trait <= 0.00005, 1],
       #highlight.col = "red",
       #       highlight.cex = 0.2,
       col = c("darkorange4", "goldenrod"))


CMplot(total, type = "p", plot.type = "m", LOG10 = F, threshold =c(5.10902,-5.037157),
       cex = 1,amplify = T,chr.labels = chr$V1,
       #threshold.lty=c(2,2), threshold.lwd=c(1,1), threshold.col=c("black","red"),
       ylim = c(-8, 8),chr.labels.angle=45,
       highlight=SNPs,
       #highlight.col=c("red"),
       #highlight.cex=1,#highlight.pch=c(15:17),
       highlight.text=SNPs,
       #highlight.text.col=c("green"),
       #       threshold.col = "gray35", threshold.lwd = 1, threshold.lty = 2, amplify = F,
       file = "pdf", memo = "",
       dpi = 2000,
       file.output = T, verbose = T,
       width = 14, height = 6,
       ylab = expression(-log[10](italic(P))),
       cex.lab = 1,
       #       highlight = plot_data[plot_data$trait <= 0.00005, 1],
       #highlight.col = "red",
       #       highlight.cex = 0.2,
       col = c("darkorange4", "goldenrod"))





KF.linear <- read.table("KF/ASV723/ASV723.assoc.linear", header = T)
YL.linear <- read.table("YL/ASV723/ASV723.assoc.linear", header = T)

KF.linear$log10P <- -log10(KF.linear$P)
YL.linear$log10P <- log10(YL.linear$P)

KF.linear$SNP2 <- paste("KF", KF.linear$SNP, sep = "_")
YL.linear$SNP2 <- paste("YL", YL.linear$SNP, sep = "_")

total <- data.frame(SNP = c(KF.linear$SNP2, YL.linear$SNP2),
                    Chromosome = c(KF.linear$CHR, YL.linear$CHR),
                    Position = c(KF.linear$BP, YL.linear$BP),
                    ASV723= c(KF.linear$log10P, YL.linear$log10P))

total<-total[-which(is.na(total[,4])),]
total<-total[-which(total[,4] %in% "-Inf"),]
total<-total[-which(total[,4] %in% "Inf"),]

min(total$ASV723)
max(total$ASV723)

total$SNP<-as.factor(total$SNP)

SNPs <- total[abs(total[,4])>5.037157, 1]

SNPs<-SNPs[c(3,95,96,97)]


CMplot(total, type = "p", plot.type = "m", LOG10 = F, threshold =c(5.10902,-5.037157),
       cex = 1,amplify = T,chr.labels = chr$V1,
       #threshold.lty=c(2,2), threshold.lwd=c(1,1), threshold.col=c("black","red"),
       ylim = c(-8, 8),chr.labels.angle=45,
       highlight=SNPs,
       #highlight.col=c("red"),
       #highlight.cex=1,#highlight.pch=c(15:17),
       highlight.text=SNPs,
       #highlight.text.col=c("green"),
       #       threshold.col = "gray35", threshold.lwd = 1, threshold.lty = 2, amplify = F,
       file = "jpg", memo = "",
       dpi = 2000,
       file.output = T, verbose = T,
       width = 14, height = 6,
       ylab = expression(-log[10](italic(P))),
       cex.lab = 1,
       #       highlight = plot_data[plot_data$trait <= 0.00005, 1],
       #highlight.col = "red",
       #       highlight.cex = 0.2,
       col = c("darkorange4", "goldenrod"))



CMplot(total, type = "p", plot.type = "m", LOG10 = F, threshold =c(5.10902,-5.037157),
       cex = 1,amplify = T,chr.labels = chr$V1,
       #threshold.lty=c(2,2), threshold.lwd=c(1,1), threshold.col=c("black","red"),
       ylim = c(-8, 8),chr.labels.angle=45,
       highlight=SNPs,
       #highlight.col=c("red"),
       #highlight.cex=1,#highlight.pch=c(15:17),
       highlight.text=SNPs,
       #highlight.text.col=c("green"),
       #       threshold.col = "gray35", threshold.lwd = 1, threshold.lty = 2, amplify = F,
       file = "pdf", memo = "",
       dpi = 2000,
       file.output = T, verbose = T,
       width = 14, height = 6,
       ylab = expression(-log[10](italic(P))),
       cex.lab = 1,
       #       highlight = plot_data[plot_data$trait <= 0.00005, 1],
       #highlight.col = "red",
       #       highlight.cex = 0.2,
       col = c("darkorange4", "goldenrod"))






KF.linear <- read.table("KF/ASV407/ASV407.assoc.linear", header = T)
YL.linear <- read.table("YL/ASV407/ASV407.assoc.linear", header = T)

KF.linear$log10P <- -log10(KF.linear$P)
YL.linear$log10P <- log10(YL.linear$P)

KF.linear$SNP2 <- paste("KF", KF.linear$SNP, sep = "_")
YL.linear$SNP2 <- paste("YL", YL.linear$SNP, sep = "_")

total <- data.frame(SNP = c(KF.linear$SNP2, YL.linear$SNP2),
                    Chromosome = c(KF.linear$CHR, YL.linear$CHR),
                    Position = c(KF.linear$BP, YL.linear$BP),
                    ASV407= c(KF.linear$log10P, YL.linear$log10P))

total<-total[-which(is.na(total[,4])),]
total<-total[-which(total[,4] %in% "-Inf"),]
total<-total[-which(total[,4] %in% "Inf"),]

min(total$ASV407)

max(total$ASV407)


total$SNP<-as.factor(total$SNP)

SNPs <- total[abs(total[,4])>5.037157, ]

SNPs <- total[which(total$Chromosome %in% "11"), ]

write.csv(SNPs,file = "SNPs.csv",quote=F)

SNPs-read.csv("SNPs.csv",header = T)
SNPs<-c("KF_chr11:11345309","YL_chr11:11154892")



CMplot(total, type = "p", plot.type = "m", LOG10 = F, threshold =c(5.10902,-5.037157),
       cex = 1,amplify = T,chr.labels = chr$V1,
       #threshold.lty=c(2,2), threshold.lwd=c(1,1), threshold.col=c("black","red"),
       ylim = c(-10, 10),chr.labels.angle=45,
       highlight=SNPs,
       #highlight.col=c("red"),
       #highlight.cex=1,#highlight.pch=c(15:17),
       highlight.text=SNPs,
       #highlight.text.col=c("green"),
       #       threshold.col = "gray35", threshold.lwd = 1, threshold.lty = 2, amplify = F,
       file = "jpg", memo = "",
       dpi = 2000,
       file.output = T, verbose = T,
       width = 14, height = 6,
       ylab = expression(-log[10](italic(P))),
       cex.lab = 1,
       #       highlight = plot_data[plot_data$trait <= 0.00005, 1],
       #highlight.col = "red",
       #       highlight.cex = 0.2,
       col = c("darkorange4", "goldenrod"))



CMplot(total, type = "p", plot.type = "m", LOG10 = F, threshold =c(5.10902,-5.037157),
       cex = 1,amplify = T,chr.labels = chr$V1,
       #threshold.lty=c(2,2), threshold.lwd=c(1,1), threshold.col=c("black","red"),
       ylim = c(-10, 10),chr.labels.angle=45,
       highlight=SNPs,
       #highlight.col=c("red"),
       #highlight.cex=1,#highlight.pch=c(15:17),
       highlight.text=SNPs,
       #highlight.text.col=c("green"),
       #       threshold.col = "gray35", threshold.lwd = 1, threshold.lty = 2, amplify = F,
       file = "pdf", memo = "",
       dpi = 2000,
       file.output = T, verbose = T,
       width = 14, height = 6,
       ylab = expression(-log[10](italic(P))),
       cex.lab = 1,
       #       highlight = plot_data[plot_data$trait <= 0.00005, 1],
       #highlight.col = "red",
       #       highlight.cex = 0.2,
       col = c("darkorange4", "goldenrod"))







KF.linear <- read.table("KF/ASV5542/ASV5542.assoc.linear", header = T)
YL.linear <- read.table("YL/ASV5542/ASV5542.assoc.linear", header = T)

KF.linear$log10P <- -log10(KF.linear$P)
YL.linear$log10P <- log10(YL.linear$P)

KF.linear$SNP2 <- paste("KF", KF.linear$SNP, sep = "_")
YL.linear$SNP2 <- paste("YL", YL.linear$SNP, sep = "_")

total <- data.frame(SNP = c(KF.linear$SNP2, YL.linear$SNP2),
                    Chromosome = c(KF.linear$CHR, YL.linear$CHR),
                    Position = c(KF.linear$BP, YL.linear$BP),
                    ASV5542= c(KF.linear$log10P, YL.linear$log10P))

total<-total[-which(is.na(total[,4])),]
total<-total[-which(total[,4] %in% "-Inf"),]
total<-total[-which(total[,4] %in% "Inf"),]
min(total$ASV5542)

max(total$ASV5542)

total$SNP<-as.factor(total$SNP)

SNPs <- total[abs(total[,4])>5.037157, 1]

SNPs<-c("KF_chr14:46302504","KF_chr15:1794892","YL_chr14:45586169","YL_chr15:2498143")

CMplot(total, type = "p", plot.type = "m", LOG10 = F, threshold =c(5.10902,-5.037157),
       cex = 1,amplify = T,chr.labels = chr$V1,
       #threshold.lty=c(2,2), threshold.lwd=c(1,1), threshold.col=c("black","red"),
       ylim = c(-11.5, 10),chr.labels.angle=45,
       highlight=SNPs,
       #highlight.col=c("red"),
       #highlight.cex=1,#highlight.pch=c(15:17),
       highlight.text=SNPs,
       #highlight.text.col=c("green"),
       #       threshold.col = "gray35", threshold.lwd = 1, threshold.lty = 2, amplify = F,
       file = "pdf", memo = "",
       dpi = 2000,
       file.output = T, verbose = T,
       width = 14, height = 6,
       ylab = expression(-log[10](italic(P))),
       cex.lab = 1,
       #       highlight = plot_data[plot_data$trait <= 0.00005, 1],
       #highlight.col = "red",
       #       highlight.cex = 0.2,
       col = c("darkorange4", "goldenrod"))


CMplot(total, type = "p", plot.type = "m", LOG10 = F, threshold =c(5.10902,-5.037157),
       cex = 1,amplify = T,chr.labels = chr$V1,
       #threshold.lty=c(2,2), threshold.lwd=c(1,1), threshold.col=c("black","red"),
       ylim = c(-11.5, 10),chr.labels.angle=45,
       highlight=SNPs,
       #highlight.col=c("red"),
       #highlight.cex=1,#highlight.pch=c(15:17),
       highlight.text=SNPs,
       #highlight.text.col=c("green"),
       #       threshold.col = "gray35", threshold.lwd = 1, threshold.lty = 2, amplify = F,
       file = "jpg", memo = "",
       dpi = 2000,
       file.output = T, verbose = T,
       width = 14, height = 6,
       ylab = expression(-log[10](italic(P))),
       cex.lab = 1,
       #       highlight = plot_data[plot_data$trait <= 0.00005, 1],
       #highlight.col = "red",
       #       highlight.cex = 0.2,
       col = c("darkorange4", "goldenrod"))




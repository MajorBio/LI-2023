#!/usr/bin/env Rscript
library('getopt');
options(bitmapType='cairo')
spec = matrix(c(
	'pheno','p',1,'character',
	'bed','b', 1,'character',
	'kinship','k', 1,'character',
	'threshold','s',2,'numeric',
	'out','o',1,'character',
	'help','h',0,'logical'
	), byrow=TRUE, ncol=4);
opt = getopt(spec);
print_usage <- function(spec=NULL){
	cat(getopt(spec, usage=TRUE));
	cat("Usage example: \n");
	cat("
Usage example:
	Rscript GWAS.R

Usage:
	--pheno	the input pheno file
	--bed	the input bed file
	--kinship	the kinship file
	--threshold	default 0.05
	--out	the out filename
	--help	usage\n"
	);
	q(status=1);
}

if ( !is.null(opt$help)) { print_usage(spec) }
if ( is.null(opt$pheno)) { print_usage(spec) }
if ( is.null(opt$bed)){ print_usage(spec) }
if ( is.null(opt$kinship)){ print_usage(spec) }
if ( is.null(opt$threshold)){ opt$threshold=0.05 }
if ( is.null(opt$out)){ print_usage(spec) }

suppressMessages(library(CMplot))

# FaSTLMM model
fastlmm <- function(pheno,path){
	trit <- cbind(pheno[,1],pheno)
	write.table(trit,"pheno.txt", row.names=FALSE,col.names=FALSE,quote=FALSE,sep="\t")
	system(paste("fastlmmc",
		     "-bfile",paste(path,"pop",sep="/"), "-bfilesim", paste(path,"pop",sep="/"), "-pheno", "pheno.txt", "-out",
		     paste(opt$out,"FaSTLMM.txt", sep="."), sep=" "))
	FastlmmData <- read.table(paste(opt$out,"FaSTLMM.txt",sep='.'),header=TRUE)
	FastlmmPlotData <- data.frame(FastlmmData$SNP,FastlmmData$Chromosome,FastlmmData$Position,FastlmmData$Pvalue)
	names(FastlmmPlotData) <- c('SNP','CHR','BP','P')
	return(FastlmmPlotData)
}
# GEMMALMM model
gemmalmm <- function(path){
	system(paste("gemma-0.98.1",
		     "-bfile", paste(path,"pop",sep="/"), "-maf", "0.0001", "-miss", "0.4", "-lmm", "1", "-k", opt$kinship, "-o",opt$out))
	GemmalmmData <- read.table(paste(path, "/output/",opt$out,".assoc.txt",sep=""),header=TRUE)
	GemmalmmPlotData <- data.frame(GemmalmmData$rs,GemmalmmData$chr,GemmalmmData$ps,GemmalmmData$p_wald)
	names(GemmalmmPlotData) <- c('SNP','CHR','BP','P')
	return(GemmalmmPlotData)
}
# draw manhattan and Q-Qplot
draw <- function(plotdata, method,thres){
	#manhattan
	CMplot(plotdata,type="p",plot.type="m",LOG10=TRUE,threshold=thres,file="jpg",
	       memo=paste(method, opt$out, sep="."),file.output=TRUE,verbose=TRUE)
	CMplot(plotdata,type="p",plot.type="m",LOG10=TRUE,threshold=thres,file="pdf",
	       memo=paste(method, opt$out, sep="."),file.output=TRUE,verbose=TRUE)
	#Q-Q
	CMplot(plotdata,plot.type="q",box=TRUE,file="jpg",memo=paste(method, opt$out, sep="."),
	       conf.int=TRUE,conf.int.col=NULL,threshold.col="red",threshold.lty=2,file.output=TRUE,verbose=TRUE)
	CMplot(plotdata,plot.type="q",box=TRUE,file="pdf",memo=paste(method, opt$out, sep="."),
	       conf.int=TRUE,conf.int.col=NULL,threshold.col="red",threshold.lty=2,file.output=TRUE,verbose=TRUE)
}

pheno <- read.table(opt$pheno,header=TRUE)

# add pheno to .fam
path <- getwd()
setwd(path)
#print(path)
#li <- unlist(strsplit(opt$bed, '/'))
fam <- read.table(paste(opt$bed,'fam',sep="."))
new_fam <- cbind(fam[,1:5],pheno[,2])
write.table(new_fam,paste("pop",'fam',sep="."),col.names=FALSE,row.names=FALSE,quote=FALSE)

#calculate threshold
snp <- read.table(paste(opt$bed,'.bim',sep=""),header=FALSE)
num <- dim(snp)[1]
thres <- opt$threshold/num

#modeling and drawing
gemmalmmplotdata <- gemmalmm(path)
draw(gemmalmmplotdata,'GEMMALMM',thres)
print("GEMMALMM Done!")
fastlmmplotdata <- fastlmm(pheno,path);
draw(fastlmmplotdata,'FaSTLMM',thres);
print("FaSTLMM Done！")

save.image(paste(opt$out,'.RData',sep=""))


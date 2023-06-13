#/usr/bin/env Rscript
.libPaths(c("./R/library/","./R3.5/"))

library('getopt')
options(bitmapType='cairo')
spec = matrix(c(
		'vcf','v',1,'character',
		'outdir','o',1,'character',
		'prefix','p',1,'character',
		'help','h',0,'logical'
		),byrow=TRUE, ncol=4);
opt = getopt(spec)
print_usage <- function(spec=NULL){
	cat(getopt(spec, usage=TRUE))
	cat("Usage example: \n")
	cat("
Usage example:
	Rscript vcf2num.R
Usage:
	--vcf vcf
	--outdir outdir
	--prefix prefix name for out
	--help usage\n")
	q(status=1)
}

if ( !is.null(opt$help)) { print_usage(spec) }
if ( is.null(opt$vcf)) { print_usage(spec) }
if ( is.null(opt$outdir)) { print_usage(spec) }
if ( is.null(opt$prefix)) { print_usage(spec) }

setwd(opt$outdir)
library(rMVP)
MVP.Data.VCF2MVP(opt$vcf, out=opt$prefix, threads=1)
geno <- attach.big.matrix(paste(opt$prefix,"geno.desc",sep='.'))
map <- read.table(paste(opt$prefix,"geno.map",sep='.'),header=T,stringsAsFactors=F)
samples <- read.table(paste(opt$prefix,"geno.ind",sep='.'),header=F,stringsAsFactors=F)
dat <- as.data.frame(geno[,])
# dat[is.na(dat)] <- 0
# new_dat <- cbind(map$SNP,dat)
dat_imu <- matrix(nrow=dim(dat)[1],ncol=dim(dat)[2])
for(i in 1:dim(dat)[1]){
	line <- as.numeric(dat[i,])
	aver <- mean(line,na.rm=TRUE)
	line[is.na(line)] <- aver
	dat_imu[i,] <- line
}
new_dat <- cbind(map$SNP,dat_imu)
colnames(new_dat) <- c("snpid",samples[,1])
write.table(new_dat,paste(opt$prefix,'SNP.txt',sep='.'),col.names=T,row.names=F,sep='\t',quote=F)
snpsloc <- map[,1:3];names(snpsloc)<-c("snpid","chr","pos")
write.table(snpsloc,paste(opt$prefix,'snpsloc.txt',sep='.'),col.names=T,row.names=F,sep='\t',quote=F)
save.image(paste(opt$prefix,"RData",sep="."))
print("This-work-has-been-completed!")
proc.time()

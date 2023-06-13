#!/usr/bin/env Rscript
library('getopt');
options(bitmapType='cairo')
spec = matrix(c(
	'pheno','p',1,'character',
	'help','h',0,'logical'
	), byrow=TRUE, ncol=4);
opt = getopt(spec);
print_usage <- function(spec=NULL){
	cat(getopt(spec, usage=TRUE));
	cat("Usage example: \n");
	cat("
Usage example:
	Rscript trait.R

Usage:
	--pheno	the input pheno file
	--help	usage\n"
	);
	q(status=1);
}
if ( !is.null(opt$help)) { print_usage(spec) }
if ( is.null(opt$pheno)) { print_usage(spec) }

trait <- read.table(opt$pheno,header=T)
if (file.exists('trit') == F){
    dir.create('trit',recursive = TRUE)
}
for (i in 2:dim(trait)[2]){
  dat <- trait[,c(1,i)]
  file = colnames(trait)[i]
  write.table(dat,paste('trit',file,sep='/'),quote=F,col.names=T,row.names=F)
}
print("successful!")

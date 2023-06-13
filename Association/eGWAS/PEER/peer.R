#!/usr/bin/env Rscript
suppressMessages(library("getopt"))
options(bitmapType='cairo')
spec = matrix(c(
    'expression','e',1,'character',
    'num','n',2,'numeric',
    'covariate','c',2,'numeric',
    'help','h',0,'logical'
    ), byrow=TRUE, ncol=4);
opt = getopt(spec);
print_usage <- function(spec=NULL){
  cat(getopt(spec, usage=TRUE));
  cat("Usage example: \n");
  cat("Usage example:
    Rscript indel_len.r --i  --o
    Usage:
    --expression	must	matrix of counts
    --num	selectable	calculate the nume of factor, default 40
    --covariate	selectable	the nume for covariates, default 20
    --help		usage\n"
    );
  q(status=1);
}

if ( !is.null(opt$help)) {print_usage(spec)}
if ( is.null(opt$expression)){print_usage(spec)}
if ( is.null(opt$num)){opt$num = 40}
if ( is.null(opt$covariate)){opt$covariate = 20}

suppressMessages(library("peer"))

dat <- read.table(opt$expression, header=T,row.names=1,sep='\t',stringsAsFactors=F)
dat <- t(dat)
model = PEER()
PEER_setPhenoMean(model,as.matrix(dat))
PEER_setNk(model,opt$num)
PEER_getNk(model)

# MORE TIME
PEER_update(model)

factors = PEER_getX(model)

colname <- c("id",rownames(dat))
rowname <- paste("cova", 1:dim(factors)[2],sep="")
covariates <- data.frame(rowname, t(factors))
colnames(covariates) <- colname

write.table(covariates,"covariates_all.xls",sep="\t",col.names=T,row.names=F,quote=F)
write.table(covariates[1:opt$covariate,],"covariates_20.xls",sep="\t",col.names=T,row.names=F,quote=F)
save.image("peer.RData")
proc.time()

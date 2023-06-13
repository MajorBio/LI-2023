#!/usr/bin/env Rscript

library("metagenomeSeq")
####################################################################################################
args <- commandArgs(T)
print(args[1])
print(args[2])
data <- read.table(args[1], sep = "\t", header = T, row.names = 1)
data <- as.data.frame(t(data))
####################################################################################################
##cumNorm：Cumulative sum scaling normalization
##Calculates each column's quantile and calculates the sum up to and including that quantile.

##cumNormMat: Cumulative sum scaling factors.
##Calculates each column's quantile and calculates the sum up to and including that quantile.

##cumNormStat: Cumulative sum scaling percentile selection
##Calculates the percentile for which to sum counts up to and scale by. cumNormStat might be deprecated one day. Deviates from methods in Nature Methods paper by making use row means for generating reference.

metaSeqObject <- newMRexperiment(data) 
metaSeqObject_CSS <- cumNorm(metaSeqObject, p = cumNormStatFast(metaSeqObject))
OTU_read_count_CSS <- data.frame(MRcounts(metaSeqObject_CSS, norm = T, log = T))

#OTU_read_count_CSS <- as.data.frame(t(OTU_read_count_CSS))
#OTU_read_count_CSS <- data.frame(sample = rownames(OTU_read_count_CSS), OTU_read_count_CSS, row.names = NULL)

##Ranks.
#r <- rank(u)

##Apply transformation.
#out <- stats::qnorm((r - k) / (n - 2 * k + 1))

RBINT <- function(x){
  r <- rank(x)
  k <- 3/8
  n <- length(r)
  out <- stats::qnorm((r - k) / (n - 2 * k + 1))
  return(out)
}

OTU_read_count_CSS_RBINT <- apply(OTU_read_count_CSS, 1, RBINT)
OTU_read_count_CSS_RBINT <- data.frame(sample = rownames(OTU_read_count_CSS_RBINT), OTU_read_count_CSS_RBINT, row.names = NULL)
####################################################################################################
write.table(OTU_read_count_CSS_RBINT, args[2], row.names = F, col.names = T, sep = "\t", quote = F)

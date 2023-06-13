#!/usr/bin/env Rscript3.6
.libPaths("./R/x86_64-pc-linux-gnu-library/3.6/")
library('getopt');
options(bitmapType='cairo')
spec = matrix(c(
	'snps','s',1,'character',
	'expressions','e',1,'character',
	'covariates','c',2,'character',
	'snpspos','l', 2,'character',
	'genespos','g',2,'character',
	'outdir','o',1,'character',
	'threshold','t',2,'numeric',
	'distance','d',2,'numeric',
	'model','m',2,'character',
	'help','h',0,'logical'
	), byrow=TRUE, ncol=4);
opt = getopt(spec);
print_usage <- function(spec=NULL){
	cat(getopt(spec, usage=TRUE));
	cat("Usage example: \n");
	cat("
Usage example:
	Rscript eqtl.R

Usage:
	--snps	the snps file
	--expressions	the expressions file
	--covariates	the covariates file
	--snpspos	snps position file
	--genespos	genes position file
	--threshold	threshold, defaule 1e-2
	--distance	distance, default 1e6
	--model	model, such as ANOVA/A, LINEAR/L, LINEAR_CROSS/C, default LINEAR
	--outdir	outdir
	--help	usage\n"
	);
	q(status=1);
}

if ( !is.null(opt$help)) { print_usage(spec) }
if ( is.null(opt$snps)) { print_usage(spec) }
if ( is.null(opt$expressions)){ print_usage(spec) }
if ( is.null(opt$threshold)){ opt$threshold = 0.05 }#
if ( is.null(opt$distance)){ opt$distance = 1e6 }
if ( is.null(opt$model)){ opt$model = 'L' }
if ( is.null(opt$outdir)){ print_usage(spec) }
# if ( is.null(opt$covariates)){ print_usage(spec) }

#setwd(opt$outdir)
suppressMessages(library(MatrixEQTL))

if(opt$model == 'L'){
	useModel = modelLINEAR;
}else if(opt$model == 'A'){
	useModel = modelANOVA
}else if(opt$model == 'C'){
	useModel = modelLINEAR_CROSS
}

snps = SlicedData$new();
snps$fileDelimiter = "\t";      # the TAB character
snps$fileOmitCharacters = "NA"; # denote missing values;
snps$fileSkipRows = 1;          # one row of column labels
snps$fileSkipColumns = 1;       # one column of row labels
snps$LoadFile(opt$snps);

gene = SlicedData$new();
gene$fileDelimiter = "\t";      # the TAB character
gene$fileOmitCharacters = "NA"; # denote missing values;
gene$fileSkipRows = 1;          # one row of column labels
gene$fileSkipColumns = 1;       # one column of row labels
gene$LoadFile(opt$expressions);
# errorCovariance = numeric();
pvOutputThreshold = opt$threshold
cvrt = SlicedData$new();
cvrt$fileDelimiter = "\t";      # the TAB character
cvrt$fileOmitCharacters = "NA"; # denote missing values;
cvrt$fileSkipRows = 1;          # one row of column labels
cvrt$fileSkipColumns = 1;       # one column of row labels
if(length(opt$covariates)>0) {
	cvrt$LoadFile(opt$covariates);
}


if (!is.null(opt$snpspos) & !is.null(opt$genespos)){
output_file_name_cis = tempfile();
output_file_name_tra = tempfile();

cisDist = opt$distance;
snpspos = read.table(opt$snpspos, header = TRUE, stringsAsFactors = FALSE);
genepos = read.table(opt$genespos, header = TRUE, stringsAsFactors = FALSE);
pvOutputThreshold_cis = opt$threshold/dim(snpspos)[1];
pvOutputThreshold_tra = opt$threshold/dim(snpspos)[1];
meq = Matrix_eQTL_main(
	snps = snps,
	gene = gene,
	cvrt = cvrt,
	output_file_name = output_file_name_tra,
	pvOutputThreshold = pvOutputThreshold_tra,
	useModel = useModel,
	# errorCovariance = errorCovariance,
	verbose = TRUE,
	output_file_name.cis = output_file_name_cis,
	pvOutputThreshold.cis = pvOutputThreshold_cis,
	snpspos = snpspos,
	genepos = genepos,
	cisDist = cisDist,
	pvalue.hist = "qqplot",
	min.pv.by.genesnp = FALSE,
	noFDRsaveMemory = FALSE);
unlink(output_file_name_tra);
unlink(output_file_name_cis);
write.csv(meq$cis$eqtl, paste(opt$outdir,'cis.eqtl.csv',sep=''),row.names=F,quote=F)
write.csv(meq$trans$eqtl, paste(opt$outdir,'trans.eqtl.csv',sep=''),row.names=F,quote=F)
save.image("meq.RData")
meh = Matrix_eQTL_main(
	snps = snps,
        gene = gene,
        cvrt = cvrt,
        output_file_name = output_file_name_tra,
        pvOutputThreshold = pvOutputThreshold_tra,
	useModel = useModel,
        # errorCovariance = numeric(),
	verbose = TRUE,
	output_file_name.cis = output_file_name_cis,
	pvOutputThreshold.cis = pvOutputThreshold_cis,
	snpspos = snpspos,
	genepos = genepos,cisDist = cisDist,
	pvalue.hist = 100,
	min.pv.by.genesnp = FALSE,
	noFDRsaveMemory = FALSE);
## Results:
# write.csv(meq$cis$eqtl, paste(opt$outdir,'cis.eqtl.csv',sep=''),quote=F)
# write.csv(meq$trans$eqtl, paste(opt$outdir,'trans.eqtl.csv',sep=''),quote=F)
# cat('Analysis done in: ', meq$time.in.sec+meh$time.in.sec, ' seconds', '\n');
}else{
	output_file_name = tempfile();
	meq = Matrix_eQTL_engine(snps = snps,gene = gene,cvrt = cvrt,
		output_file_name = output_file_name,pvOutputThreshold = pvOutputThreshold,
		useModel = useModel,
		# errorCovariance = errorCovariance,
		verbose = TRUE,
		pvalue.hist = TRUE,min.pv.by.genesnp = FALSE,noFDRsaveMemory = FALSE);
	meh = Matrix_eQTL_engine(
		snps = snps,
		gene = gene,
		cvrt = cvrt,
		output_file_name = output_file_name,
		pvOutputThreshold = pvOutputThreshold,
		useModel = useModel,
		# errorCovariance = numeric(),
		verbose = TRUE,
		pvalue.hist = 100);
	unlink( filename );
	unlink(output_file_name);
	write.csv(meq$all$eqtls,paste(opt$outdir,'eqtl.csv',sep=''),row.names=F,quote=F)
# cat('Analysis done in: ', meq$time.in.sec+meh$time.in.sec, ' seconds', '\n');
}
save.image("calculat.RData")
## Plot the Q-Q plot
png(paste(opt$outdir,"Q-Q.png",sep=''))
plot(meq)
dev.off()

pdf(paste(opt$outdir,"Q-Q.pdf",sep=''))
plot(meq)
dev.off()

## Plot the histogram plot
png(paste(opt$outdir,"histogram.png",sep=''))
plot(meh,col="grey")
dev.off()

## Plot the histogram plot
pdf(paste(opt$outdir,"histogram.pdf",sep=''))
plot(meh,col="grey")
dev.off()

save.image("eQTL.RData")

#!/bin/bash

##
shell_script_path=`pwd`


## input file
snp=$1
phe=$2
outdir=$3
if [ ! -d $outdir ]; then
	mkdir -p $outdir
fi

# data preparation
Rscript ./OTU_CSS_normalization_Log_transition.R $phe ${snp}.norm.txt

#plink --vcf ${snp}.vcf --make-bed --out $snp --allow-extra-chr --allow-no-sex 

perl ./generate_plink_pheno_file.pl ${snp}.fam ${snp}.norm.txt ${snp}.phe.plink.continue

head -n 1 $phe | sed 's/\t/\n/g' | awk '$1 != "sample" {printf $1"\n"}' > ${snp}.phe.plink.continue.id

#plink --bfile $snp --pca 4 --out ${snp}.PC04 --allow-extra-chr --allow-no-sex

# Plink GWAS
#-- total OTU number
total=`wc -l ${snp}.phe.plink.continue.id | cut -d ' ' -f 1`
#-- run one by one
for i in $(seq 1 $total); do
	name=`head -n $i ${snp}.phe.plink.continue.id | awk '{print $1}' | tail -n 1`
	spt_dir=$outdir/$name
	mkdir $spt_dir

	# GWAS in Logistic model
	plink --bfile $snp --pheno ${snp}.phe.plink.continue --mpheno $i --linear --out $spt_dir/$name --allow-extra-chr --allow-no-sex

	# 
	if [ ! -f $spt_dir/$name.assoc.linear ]; then
		echo "$name" >> $outdir/0_unplot_list.txt
		continue
	fi

	# format type of p-value
	echo "SNP CHROM BP P" > $spt_dir/$name.assoc.linear.for_plot.txt
	tail -n +2 $spt_dir/$name.assoc.linear | perl -ne '@tmp=split; $tmp[8] = 1e-10 if ($tmp[8] eq "0"); print "si$tmp[0]:$tmp[2] $tmp[0] $tmp[2] $tmp[8]\n" if ($tmp[4] eq "ADD")' >> $spt_dir/$name.assoc.linear.for_plot.txt

	# plot GWAS result
	cat > $spt_dir/$name.assoc.linear.CMplot.r <<EOF
	library(CMplot)
	df <- read.table("$name.assoc.linear.for_plot.txt", header=T)
	CMplot(df, plot.type = "m", LOG10=TRUE, cex=0.4, threshold=7.78E-6, threshold.lty=2, threshold.col="black",  amplify=TRUE, signal.col="red", signal.cex=1,width=14, bin.size=1e6, chr.den.col=c("darkgreen", "yellow", "red"), verbose=TRUE, height=5, file="pdf", memo="$name.assoc.linear")
	EOF

	cd $spt_dir
	Rscript $name.assoc.linear.CMplot.r
	cd $shell_script_path

done







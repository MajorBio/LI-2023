#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($vcf,$expression,$out,$prefix,$gff,$dsh);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"vcf:s"=>\$vcf,
	"gff:s"=>\$gff,
	"out:s"=>\$out,
	"prefix:s"=>\$prefix,
	"matrix:s"=>\$expression,
	"dsh:s"=>\$dsh,
	) or &USAGE;
&USAGE unless ($out);
$dsh||="work_sh";
$out=ABSOLUTE_DIR($out);

mkdir "$out/step03.eQTL" if (!-d "$out/step03.eQTL");
mkdir "$out/$dsh" if (!-d "$out/$dsh");
my $fout="$out/step03.eQTL";

open SH,">$out/work_sh/03.eqtl.sh";
print SH "cd $fout && Rscript $Bin/bin/vcf2num.R ";
print SH " -v $vcf -o $fout -p $prefix && ";
print SH "python $Bin/bin/gff2geneloc.py -g $gff -o $fout && ";
#print SH "export R_LIBS=;export R_HOME=;export RHOME=;/mnt/ilustre/centos7users/dna/.env/R-3.6.1/bin/Rscript ";
print SH "Rscript ";
print SH "$Bin/bin/eqtl.R -s $fout/$prefix.SNP.txt -e $expression -l $fout/$prefix.snpsloc.txt ";
print SH " -g $fout/$prefix.geneloc.txt -o $fout \n";
close SH;

my $job="qsub-slurm.pl --Resource mem=100G --CPU 3 $out/work_sh/03.eqtl.sh";
`$job`;
#######################################################################################
print STDOUT "\nDone. Total elapsed time : ",time()-$BEGIN_TIME,"s\n";
#######################################################################################
sub ABSOLUTE_DIR #$pavfile=&ABSOLUTE_DIR($pavfile);
{
	my $cur_dir=`pwd`;chomp($cur_dir);
	my ($in)=@_;
	my $return="";
	if(-f $in){
		my $dir=dirname($in);
		my $file=basename($in);
		chdir $dir;$dir=`pwd`;chomp $dir;
		$return="$dir/$file";
	}elsif(-d $in){
		chdir $in;$return=`pwd`;chomp $return;
	}else{
		warn "Warning just for file and dir \n$in";
		exit;
	}
	chdir $cur_dir;
	return $return;
}
sub USAGE {#
        my $usage=<<"USAGE";
Contact:        meng.luo\@majorbio.com;
Script:			$Script
Description:

	eg: perl -int filename -out filename 
	
Usage:
  Options:

	-trt trt file name
	-out output file name 
	-dsh work shell name
	-h         Help

USAGE
        print $usage;
        exit;
}

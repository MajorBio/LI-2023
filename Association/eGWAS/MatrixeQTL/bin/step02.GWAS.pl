#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$out,$dsh);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"trt:s"=>\$fin,
	"out:s"=>\$out,
	"dsh:s"=>\$dsh,
	) or &USAGE;
&USAGE unless ($out);
$dsh||="work_sh";
$out=ABSOLUTE_DIR($out);
$fin=ABSOLUTE_DIR($fin);
mkdir "$out/step02.GWAS" if (!-d "$out/step02.GWAS");
mkdir "$out/$dsh" if (!-d "$out/$dsh");
my $fout="$out/step02.GWAS";
open In,$fin;

open SH,">$out/work_sh/02.gwas.sh";
while (<In>) {
	chomp;
	print SH "mkdir -p $fout/$_ && cd $fout/$_ && ln -s $out/step01.prepare.data/pop.bed && ln -s $out/step01.prepare.data/pop.bim ";
	print SH " && Rscript $Bin/bin/GWAS.R ";
	print SH  "-p $out/step01.prepare.data/trit/$_ -b $out/step01.prepare.data/pop -o $_ -k  $out/step01.prepare.data/pop.cXX.txt\n";
}
close SH;
close In;
my $job="qsub-slurm.pl --Resource mem=30G --CPU 1 $out/work_sh/02.gwas.sh";
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

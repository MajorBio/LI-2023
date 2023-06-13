#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($vcf,$fout,$trtlist,$gff,$trait,$dsh,$eqtl,$prefix,$expression,$step,$stop);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"vcf:s"=>\$vcf,
	"outdir:s"=>\$fout,
	"list:s"=>\$trtlist,
	"trait:s"=>\$trait,
	"gff:s"=>\$gff,
	"prefix:s"=>\$prefix,
	"matrix:s"=>\$expression,
	"eqtl:s"=>\$eqtl,
	"dsh:s"=>\$dsh,
	"step:s"=>\$step,
	"stop:s"=>\$stop,
			) or &USAGE;
&USAGE unless ($vcf and $fout);
$dsh||="work_sh";
$vcf=ABSOLUTE_DIR($vcf);
$trait=ABSOLUTE_DIR($trait);
$trtlist=ABSOLUTE_DIR($trtlist);
mkdir $fout if (!-d $fout);
$fout=ABSOLUTE_DIR($fout);
mkdir "$dsh" if (!-d "$dsh");
#$dsh=ABSOLUTE_DIR($dsh);
$step||=1;
$stop||=-1;
my $tmp=time();

open Log,">$fout/$dsh/GWAS.pipeline.$tmp.log";
#print "$fout/$dsh/GWAS.pipeline.$tmp.log";die;
if ($step == 1) {
	print Log "########################################\n";
	print Log "prepare data\n",my $time=time();
	print Log "########################################\n";
	my $job="perl $Bin/bin/step01.prepare.data.pl -out $fout  -vcf $vcf -trait $trait -dsh $dsh";
	print Log "$job\n";
	`$job`;
	print Log "$job\tdone!\n";
	print Log "########################################\n";
	print Log "Done and elapsed time : ",time()-$time,"s\n";
	$step++ unless($step == $stop);
}

if ($step == 2) {
	print Log "########################################\n";
	print Log "GWAS(FaSTLMM,GEMMA,GLMM,LMM,LM)\n",my $time=time();
	print Log "########################################\n";
	my $job="perl $Bin/bin/step02.GWAS.pl -out $fout -trt $trtlist -dsh $dsh";
	print Log "$job\n";
	`$job`;
	print Log "$job\tdone!\n";
	print Log "########################################\n";
	print Log "Done and elapsed time : ",time()-$time,"s\n";
	$step++ unless($step == $stop);
}

if ($step ==3 && defined $eqtl) {
	print Log "########################################\n";
	print Log "eQTL MatrixEQTL\n",my $time=time();
	print Log "########################################\n";
	my $job="perl $Bin/bin/step03.eQTL.pl -out $fout -vcf $vcf -gff $gff -prefix $prefix -matrix $expression -dsh $dsh";
	print Log "$job\n";
	`$job`;
	print Log "$job\tdone!\n";
	print Log "########################################\n";
	print Log "Done and elapsed time : ",time()-$time,"s\n";
	$step++ unless($step == $stop);
}

close Log;
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

	eg: perl $Script -vcf pop.YL.185.recode.vcf -outdir ./ -list list -trait PCA.txt -dsh work_sh -step 2
	
Usage:
  Options:
	-vcf vcf filename
	-outdir output dir
	-list trait name list 
	-trait trait file name
	-gff gff file name 
	-matrix expression matrix
	-prefix the prefix name (eg, YL)
	-dsh work shell name
	-h         Help

USAGE
        print $usage;
        exit;
}

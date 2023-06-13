#!/usr/bin/perl

use strict;
use warnings;

open (INFAM, "<$ARGV[0]") or die "$!";
open (INPHENO, "<$ARGV[1]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";

my @order = ();
my %fam = ();
while (<INFAM>) {
	chomp (my $data = $_);
	my @data = split (/\s+/, $data);
	push (@order, $data[1]);
}
close (INFAM);

my %pheno = ();
while (<INPHENO>) {
	chomp (my $data = $_);
	next if ($data =~ /^sample/);
	my @data = split (/\t/, $data);
	my $sample_id = shift @data;

#	my @temp = ();
#	map {if ($_ != 0) {push (@temp, 2)} else {push (@temp, 1)}} @data;

	$pheno{$sample_id} = join ("\t", @data);
}
close (INPHENO);

foreach my $order (@order) {
	print OUT "$order\t$order\t$pheno{$order}\n";
}
close (OUT);






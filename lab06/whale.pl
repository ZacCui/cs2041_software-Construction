#!/usr/bin/perl -w

use strict;

(! $ARGV[0]) && exit 0;

my $name = join " ",$ARGV[0];
my $pod_ctr = 0;
my $ind_ctr = 0;
while (my $line = <STDIN>){
	#chomp $line;
	my @split_line = split / /, $line;
	my $curr_num = shift @split_line;
	my $curr_name = join " ", @split_line;
	if("$curr_name" =~ "$name"){
		$pod_ctr += 1; 
		$ind_ctr += $curr_num;
	}
}
print "$name observations: $pod_ctr pods, $ind_ctr individuals\n";

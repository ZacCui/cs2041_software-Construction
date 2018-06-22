#!/usr/bin/perl -w
use strict;

if(@ARGV == 1){
	($ARGV[0] < 1) and exit 1;
	my %dic = ();
	while(my $line = <STDIN>){
		chomp $line;
		$dic{$line}++;
	}
	foreach my $line (keys %dic){
		if($dic{$line} == $ARGV[0]){
			print "Snap: $line\n";
		}
	}
}

#!/usr/bin/perl -w

use strict;

for my $arg (@ARGV){
	open F, '<', $arg or die "Cannot open $arg \n";
	my @a = <F>;
	close F;
	foreach my $line (@a){
		$line =~ s/[aeiou]//gi;
	}
	open OUT, '>', $arg or die "Write to $arg failed!\n";
	print OUT @a;
	close OUT;
	
}

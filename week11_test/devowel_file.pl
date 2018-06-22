#!/usr/bin/perl -w

use strict;

foreach my $arg (@ARGV){
	open F, '<', $arg or die "Cannot open $arg";
	my @a = <F>;
	close F;
	foreach my $line (@a){
		$line =~ s/[aeiou]//gi;
	}
	open my $b, '>', $arg or die "Cannot write to $arg";
	print $b @a;
	close $b;
}

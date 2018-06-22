#!/usr/bin/perl -w
use strict;

if (@ARGV == 2){
	open F, '<', $ARGV[1] or die "Cannot open $ARGV[1]";
	my @a = <F>;
	($ARGV[0] > @a or $ARGV[0] < 1) and exit 1;
	print $a[$ARGV[0]-1];
	close F;
}

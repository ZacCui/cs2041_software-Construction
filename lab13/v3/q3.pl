#!/usr/bin/perl -w

use strict;

open F, '<', $ARGV[0] or die "Cannot open $ARGV[0]\n";
my @a = <F>;
close F;
foreach my $line (@a){
	print $line if($line =~ s/($ARGV[1])/\($&\)/g);
}


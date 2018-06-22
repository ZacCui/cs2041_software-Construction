#!/usr/bin/perl -w
use strict;

my %dic = ();
my @a = ();
foreach my $arg(@ARGV){
	next if exists $dic{$arg};
	push @a, $arg;
	$dic{$arg} = 1;		
}
print join ' ', @a, "\n";

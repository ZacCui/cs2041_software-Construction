#!/usr/bin/perl -w
use strict;

exit 0 if !@ARGV;
my %seen;
my @print_list;
foreach my $arg (@ARGV){
	push @print_list, $arg if(! exists $seen{$arg});
	$seen{$arg} = 1 if(! exists $seen{$arg});
}

print join ' ',@print_list;

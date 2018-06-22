#!/usr/bin/perl -w
use strict;
my @a=();
my $line;
while($line = <STDIN>){
	chomp $line;
	$line =~ s/\d//g;
	push(@a,$line);
}
foreach my $line (@a){
	print "$line\n";
}	


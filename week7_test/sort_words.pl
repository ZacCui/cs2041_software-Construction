#!/usr/bin/perl -w
use strict;
my @array = ();
print @array;
while(my $line = <STDIN>){
	chomp $line;
	$line  =~ s/ +/ /g;
	my @temp = split / /,$line;
	@temp = sort{$a cmp $b} @temp;
	@temp = join ' ', @temp;
	push(@array, @temp);
	push(@array,"\n");
}
print @array;

#!/usr/bin/perl -w

use strict;
my %pod = ();
my %ind = ();
my @name = ();
my %dic = ();

while(my $line = <STDIN>){
	chomp $line;
	my @split_line = split / /, $line;
	my $curr_num = shift @split_line;
	my $curr_name = join " ", @split_line;
	$curr_name =~ tr/A-Z/a-z/;
	$curr_name =~ s/ +/ /g;
	$curr_name =~ s/^ //;
	$curr_name =~ s/s$//g;
	$pod{$curr_name} += 1;
	$ind{$curr_name} += $curr_num;
	if(!$dic{$curr_name}){
		push(@name, $curr_name);
		$dic{$curr_name} = 1; 
	}
}


@name = sort @name;

foreach my $name (@name){
	print "$name observations: $pod{$name} pods, $ind{$name} individuals\n";
}

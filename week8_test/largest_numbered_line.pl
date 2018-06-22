#!/usr/bin/perl -w

use strict;

my %dic = ();
while(my $line = <STDIN>){
	my $temp = $line;
	$line =~ s/[^\d\.-]/ /gi;
	$line =~ s/\.0* $/ /g;
	$line =~ s/-\./-0\./g;
	$line =~ s/ \./0./g;
	$line =~ s/-+/-/g;
	$line =~ s/- / /g;
	#print "$line\n";
	next if ($line !~ /\d/);
	my @a = $line =~ /(-?\d+\.?\d*) /g;
	#print "======\n";
	#print join " " ,@a;
	@a = sort{$b <=> $a}(@a);
	my $key = shift @a;
	if(! exists $dic{$key}){ 
		my @b;
		push @b, $temp;
		$dic{$key}= \@b; 
	}else{
		push @{$dic{$key}}, $temp;
	}
}

foreach my $key(sort{$b <=> $a} keys %dic){
	print @{$dic{$key}};
	last;
}

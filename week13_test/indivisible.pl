#!/usr/bin/perl -w
use strict;
my %a ;
while( my $line = <STDIN>){
	my @b = $line =~ /(\d+)/g;
	foreach my $num (@b){
		my $flag = 1;
		foreach my $key(keys %a){
			if($num%$key == 0 or $key%$num == 0 ){
				$a{$num} = 0 if($num > $key);
				$a{$key} = 0 if($num <= $key);
			}
		}
		$a{$num} = 1 if(! exists $a{$num});
	}
}
foreach my $key (sort {$a <=> $b} keys %a){
	print "$key " if($a{$key});
}
print"\n";

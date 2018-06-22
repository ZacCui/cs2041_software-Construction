#!/usr/bin/perl -w

use strict;

while(my $line = <STDIN>){
	my @a = $line =~ /(\d+\.\d+)/g;
	foreach my $num (@a){
		$num =~ /(\d+)\.(\d)/;
		$num = $1;
		$num = $1+1 if($2>=5);
		$line =~ s/(\d+\.\d+)/$num/;
	}
	print $line;
}

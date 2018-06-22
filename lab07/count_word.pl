#!/usr/bin/perl -w
use strict;

(!$ARGV[0]) and exit 1;

my $count = 0;
while(my $line = <STDIN>){
	chomp $line;
	my @a = split /[^a-z]/i, $line;
	foreach my $word (@a){
		if(lc($word) eq $ARGV[0]){
			$count++;
		}
	} 
}
print "$ARGV[0] occurred $count times\n";

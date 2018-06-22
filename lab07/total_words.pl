#!/usr/bin/perl -w
use strict;

sub total(){
	my $num = 0;
	while(my $line = <STDIN>){
		chomp $line;
		my @b = ();
		my @a = split /[^a-z]/i, $line;
		foreach my $word(@a){
			if($word =~ /[a-z]+/i){
				$num++;
			}
		}
	}
	return $num;

}

my $num = total();
print "$num words\n";

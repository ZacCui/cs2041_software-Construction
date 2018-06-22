#!/usr/bin/perl -w

foreach my $n (@ARGV){
	push @a, $n;
}
@a = sort{$a <=> $b} @a;
$mid = ($#a+1)/2;
print "$a[$mid]\n";

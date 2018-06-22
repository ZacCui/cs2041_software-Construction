#!/usr/bin/perl -w

@a = <STDIN>;
while(@a){
	$index = rand($#a);
	print "$a[$index]";
	splice(@a, $index, 1);
}

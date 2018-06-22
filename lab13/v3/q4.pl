#!/usr/bin/perl -w

while($line = <>){
	$line =~ s/\|(\w+), (.*?)\|/\|$2, $1\|/;
	print $line;
}

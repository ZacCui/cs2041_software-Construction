#!/usr/bin/perl -w

use strict;

my $url_p = "http://www.handbook.unsw.edu.au/postgraduate/courses/2017/$ARGV[0].html";
my $url_u = "http://www.handbook.unsw.edu.au/undergraduate/courses/2017/$ARGV[0].html";
open F, '-|', "wget -q -O- $url_u $url_p" or die;
while (my $line = <F>) {
	if($line =~ /Prerequisite/){		
		$line =~ s/<\/p>.*// ;
		my @a = $line =~ /[A-Z]{4}[0-9]{4}/g;
		foreach my $data  (@a) {
			print "$data\n";
		} 
	}
}
close F;


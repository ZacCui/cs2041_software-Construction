#!/usr/bin/perl -w

use strict;
my @list=();
my $url = "http://timetable.unsw.edu.au/2017/$ARGV[0]KENS.html";
open F, '-|', "wget -O- -q $url" or die "Cannot open $url";
my @a = <F>;
@list = grep {/$ARGV[0] *[0-9]{4}/} @a;
foreach my $line (@list){
	$line =~ s/<.*?>//g;
	$line =~ s/^\s+//g;
	print $line if( $line =~ /$ARGV[0] *[0-9]{4}/);
}
close F;

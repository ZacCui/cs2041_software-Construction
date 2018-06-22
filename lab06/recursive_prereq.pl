#!/usr/bin/perl -w

use strict;
(!@ARGV) && exit 0;
my $r_flag;
my @array=();
my %dic = ();
foreach my $arg (@ARGV) {
    	if ($arg eq "-r") {
		$r_flag = 1;    
	}else{
		push @array, $arg;
	}
}

foreach my $course (@array){
	my $url_p = "http://www.handbook.unsw.edu.au/postgraduate/courses/2017/$course.html";
	my $url_u = "http://www.handbook.unsw.edu.au/undergraduate/courses/2017/$course.html";
	open F, '-|', "wget -q -O- $url_u $url_p" or die;
	while (my $line = <F>) {
        	if($line =~ /Prerequisite/){
                	$line =~ s/<\/p>.*// ;
                	my @a = $line =~ /[A-Z]{4}[0-9]{4}/g;
			foreach my $code (@a){
				next if($dic{$code});
				push(@array,$code) if($r_flag);
				$dic{$code} = 1;
			}
       		}
	}
	close F;
}
foreach my $pre (sort keys %dic){
	print "$pre\n";
}

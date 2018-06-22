#!/usr/bin/perl -w

use strict;
my @timetable = ();
my %dic = ();
my $time;
my $period;
my $lec_flag;
foreach my $arg(@ARGV){
	my $url = "http://timetable.unsw.edu.au/2017/$arg.html";
	open F, '-|', "wget -O- -q $url" or die "Cannot open $url";
	my @a = <F>;
	foreach my $line (@a){
		chomp $line;
		if($line =~/<td class=\"data\"><.*>Lecture.*<\/td>/ && (!$lec_flag)){
			$lec_flag = 1;
			$line =~ s/.*\#//g;
			$line =~ s/-.*//g;
			$line =~ s/\s//g;
			$period = $line;
		}
		$lec_flag = 0 if ($line =~/<td class=\"data\">.*WEB.*/);
		if($lec_flag && $line =~ /<td class=\"data\">\w{3} [0-9]{2}:.*<\/td>/){
			$line =~ s/<.*?>//g;
			$line =~ s/\s+//;
			$time = $line;
			$lec_flag = 0;
			if(! exists $dic{"$arg : $period $time\n"}){
				push @timetable, "$arg : $period $time\n";
				$dic{"$arg : $period $time\n"} = 1;
			}
		}
	}
	$lec_flag = 0;
}
print @timetable;


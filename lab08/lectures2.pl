#!/usr/bin/perl -w

use strict;

my @code = ();
my @timetable = ();
my %dic = ();
my $time;
my $period;
my $d_flag;
my $t_flag;
foreach my $arg(@ARGV){
	if($arg eq "-d"){
		$d_flag = 1;
	}elsif($arg eq "-t"){
		$t_flag = 1;
	}else{
		push @code,$arg;
	}
}
foreach my $arg(@code){
	my $url = "http://timetable.unsw.edu.au/2017/$arg.html";
	open F, '-|', "wget -O- -q $url" or die "Cannot open $url";
	my @a = <F>;
	my $lec_flag;
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
}
my @list=();
if($d_flag or $t_flag){
	foreach my $line(@timetable){
		chomp $line;
		my @a;
		$line =~ /([A-Z]{4}[0-9]{4}) : (S[1-2])/;
		my $course = $1;
		my $semester = $2;
		@a = $line =~ /([A-Z][a-z]{2}) ([0-9]{2}):[0-9]{2} - ([0-9]{2}):/g;
		my @b = ();
		for(my $i = 0; $i < $#a; $i += 3){
			my $day =$a[$i];
			if($a[$i+1] =~ /0[0-9]/){$a[$i+1] =~ s/0//g;} 
			while($a[$i+1] < $a[$i+2]){
				if(exists $dic{"$semester $course $day $a[$i+1]\n"}){
					$a[$i+1]++;
					next;
				}
				push @list,"$semester $course $day $a[$i+1]\n";
				$dic{"$semester $course $day $a[$i+1]\n"} =1;
				$a[$i+1]++;
			}
		}
	}
	if($d_flag){
		print @list;
	}else{
		my @f = ();
		foreach my $line(@list){
			$f[1] = 1 if ($line =~ /^S1/);
			$f[2] = 1 if ($line =~ /^S2/);
		}
		foreach my $s(1..2){
		next if !$f[$s];
		print "S$s    ";
		my %table = ("Mon" => 1, "Tue"=> 2, "Wed"=> 3, "Thu"=> 4,"Fri"=> 5);
		for my $key (sort {$table{$a}<=> $table{$b} } keys %table){
			print "   $key";
		}
		print "\n0";
		my @a = ();
		foreach my $i (9..20){
			my @b = ("$i:00 ",0,0,0,0,0);
			foreach my $line(@list){
                        	chomp $line;
                        	my @c =split " ",$line;
                        	if ($c[0] eq "S$s"){
                 	        	$b[$table{$c[2]}]++ if $i == $c[3] ;
				}
        	        }
			push @a, \@b;
		}
		foreach my $ref(@a){
			foreach my $v (@{$ref}){
				if ($v =~ /:/){
					print $v;
				}elsif($v !~ /0/){
					print "    $v ";
				}else{
					print "      ";
				}
			}
			print "\n";
		}
		}
	}
}else{
	print @timetable;
}

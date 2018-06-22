#!/usr/bin/perl -w
use strict;
use List::MoreUtils qw(uniq);

(!@ARGV) and exit 1;
my %count=();
my %total=();
my %log=();
sub main(){
	my $d_flag = 0;
	my @args;
	foreach my $arg (@ARGV){
		if($arg eq "-d"){
			$d_flag = 1;	
		}else{
			push(@args,$arg); 
		}
	}
	read_data();
	foreach my $file (@args){
		open F, '<' , $file or die "Cannot open the $file";
		my @a = <F>;
		get_log($file,@a);
		close F;
	}
	if($d_flag){
		foreach my $file (sort keys %log){
			foreach my $art (sort { $log{$file}{$b} <=> $log{$file}{$a} } keys %{$log{$file}}){
				printf "$file: log_probability of %.1f for $art\n", $log{$file}{$art};
			}
		}
	}	
	foreach my $file (sort keys %log){
                foreach my $art (sort { $log{$file}{$b} <=> $log{$file}{$a} } keys %{$log{$file}}){
                        printf "$file most resembles the work of $art (log-probability=%.1f)\n", $log{$file}{$art};
                	last;
		}
        }

}
sub read_data{
	 foreach my $file (glob "lyrics/*.txt") {
                open F, '<', $file or die "Cannot open the $file";
                my @a = <F>;
                my $name = $file;
                $name =~ s/.*\///g;
                $name =~ s/\..*//g;
                $name =~ s/_/ /g;
                store_data(\%count, \$name, \%total,@a);
                close F;
        }
}

sub store_data(){
	my ($count,$name,$total,@a) = @_;
	foreach my $line (@a){
		chomp $line;
		my @b = split /[^a-z]/i, $line;
		for my $word (@b){
			if($word =~ /Andrew/i){
				print "$word\n";
			}
			$count->{$$name}{lc($word)}++ if (lc($word) =~ /[a-z]/i);
			$total->{$$name}++ if (lc($word) =~ /[a-z]/i);
		}
	}
}

sub get_log(){
	my($name,@a) = @_;
	foreach my $line (@a){
		chomp $line;
                my @b = split /[^a-z]/i, $line;
		foreach my $word (@b){
                        next if (! $word =~ /[a-z]/i);
			next if (! $word =~ /\S/);
                        foreach my $key (keys %count){
                                if(exists $count{$key}{lc($word)}){
                                        $log{$name}{$key} += log(($count{$key}{lc($word)}+1)/$total{$key});
                                }else{
                                        $log{$name}{$key} += log((1)/$total{$key});
                                }
                        }                 
               }

	}
}

main();


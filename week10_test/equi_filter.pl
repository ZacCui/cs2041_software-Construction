#!/usr/bin/perl -w

use strict;

my @list = ();
my @temp =();
my %dic = ();
while(my $line = <STDIN>){
	chomp $line;
	@temp = ();
	my @a = split /\s+/, $line;
	foreach my $word (@a){
		%dic = ();
		my $flag = 0;
		my @b = split /\s*/, $word;
		foreach my $w (@b){
			$flag = 1 if(exists $dic{lc($w)});
			$dic{lc($w)}++;
		}
		my %count;   
        	foreach my $key (sort keys %dic){
                	$count{$dic{$key}} = 1;
	        }
		my $size = keys %count; 
		push @temp, "$word" if(!$flag || $size == 1);
	}
	@temp = join ' ', @temp; 
	push @temp, "\n";
	my $str = [@temp]; 
	push @list, $str;
}

foreach my $line (@list){
	print @$line;
}




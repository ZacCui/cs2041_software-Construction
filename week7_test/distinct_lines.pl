#!/usr/bin/perl -w
use strict;
exit 1 if (!@ARGV);

my %dic=();
my $distinct = 0;
my $len = 0;
my $flag = 0;
while (my $line = <STDIN>){
	chomp $line;
	$line =~ s/ +/ /g;
	$line =~ s/ *//;
	#print "Debug: $line\n";
	$distinct++ if(! exists $dic{lc($line)});
	$dic{lc($line)} = 1;
	$len++;
	 if($ARGV[0] == $distinct){
                $flag = 1;
                last;
        }
}
if($flag){
	print "$distinct distinct lines seen after $len lines read.\n"
}else{
	print "End of input reached after $len lines read - $ARGV[0] different lines not seen.\n"
}

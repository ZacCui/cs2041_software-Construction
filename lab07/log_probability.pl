#!/usr/bin/perl -w
use strict;
(@ARGV != 1) and exit 1;

sub main(){
        foreach my $file (glob "lyrics/*.txt") {
                open F, '<', $file or die "Cannot open the $file";
                my @a = <F>;
                my $total = total(@a);
                my $times = count($ARGV[0], @a);
                my $rate = log(($times+1)/$total);
                my $name = $file;
                $name =~ s/.*\///g;
                $name =~ s/\..*//g;
                $name =~ s/_/ /g;
                printf "log((%d+1)/%6d) = %8.4f %s\n",$times,$total,$rate,$name; 
                close F;
        }
}
sub count(){
        my($match, @a) = @_;
        my $count = 0;
        foreach my $line (@a){
                my @b = split /[^a-z]/i, $line;
                for my $word(@b){
                        $count++ if(lc($word) eq lc($match));
                }
        }
        return $count;
}
sub total(){
        my $total = 0;
        foreach my $line (@_){
                my @a = split /[^a-z]/i, $line; 
                foreach my $word(@a){
                        $total++ if ($word =~ /[a-z]/i);
                }
        }
        return $total;
}

main();
 

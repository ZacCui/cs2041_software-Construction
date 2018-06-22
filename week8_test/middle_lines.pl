#!/usr/bin/perl -w
use strict;

exit 0 if !@ARGV;
exit 0 if $ARGV[0] eq "/dev/null";
open F , '<', $ARGV[0] or die "Cannot open $ARGV[0]";
my @a = <F>;
if(($#a+1) % 2 == 1){
	print $a[$#a/2];
}else{
	print "$a[$#a/2]$a[($#a/2)+1]";
}

close F;

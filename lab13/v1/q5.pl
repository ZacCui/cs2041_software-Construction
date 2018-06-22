#!/usr/bin/perl -w

use strict;
my @a = <STDIN>;
foreach my $line (@a){
	$line = $a[$1-1] if($line =~ /^#(\d+)/ );
}
print @a;

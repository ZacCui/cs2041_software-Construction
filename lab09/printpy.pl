#!/usr/bin/perl -w

use strict;

exit 0 if !@ARGV;
my @out = ();
push @out, "#!/usr/bin/python3 \n\n";
push @out, "import sys\n";
foreach my $line (@ARGV){
	chomp $line;
	$line =~ s/\\(\w+)/\\\\$1/g;
	$line =~ s/\n/\\n/g;
	$line =~ s/\r/\\r/g;
	$line =~ s/\t/\\t/g;
	$line =~ s/"/\\"/g;
	$line =~ s/^/print("/;
	$line =~ s/$/")\n/;
	push @out, $line;
}
print @out;

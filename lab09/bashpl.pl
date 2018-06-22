#!/usr/bin/perl -w

use strict;

exit 0 if ! @ARGV;

open F , '<', $ARGV[0] or die "Cannot open $ARGV[0]\n";
my @out = ();

while(my $line = <F>){
	$line = "#!/usr/bin/perl -w\n" if($line =~ /\#!\/bin/);
	$line =~ s/(\s*)do/$1\{/g  if($line =~ /^\s*do$/ );
        $line =~ s/(\s*)done/$1\}/g  if($line =~ /^\s*done$/ );
	$line =~ s/(\s*)then/$1\{/g  if($line =~ /^\s*then$/ );
	$line =~ s/(\s*)fi/$1\}/g  if($line =~ /^\s*fi$/ );
	$line =~ s/(\s*)else/$1\}else{/g if($line =~ /^\s*else$/ );
	$line =~ s/(\s*)elif/$1\}elsif/g if($line =~ /^\s*elif$/ );
	if($line =~ /\w+\=/i){
		$line =~ s/(\s*)/$1\$/;
		$line =~ s/\n$/;\n/g;
	}
	if($line =~ /\$?\(\(.*\)\)/){
		$line =~ s/\$?\((\(.*\))\)/$1/g;
		$line =~ s/\(\s*(\w+)\s*([\+\-\*!~<>=\/%]{1,2})/\(\$$1 $2/g;
		$line =~ s/([\+\-\*!~<>=\/]{1,2})\s*([\w+]+)/$1 \$$2/g;
		$line =~ s/\$(\d+)/$1/g;
		$line =~ s/=\((.*)\)/= $1/g;
	}
	if($line =~ /echo/){
		$line =~ s/echo /print "/g;
		$line =~ s/\n$/\\n";\n/g;
	}	
	push @out, $line;
}

close F;

print @out;

#!/usr/bin/perl -w
foreach $arg (@ARGV) {
    if ($arg eq "--version") {
        print "$0: version 0.1\n";
        exit 0;
    }elsif($arg =~ /^-[0-9]+/) {
	$index = $arg ;
	$index =~ s/-//;
    }else {
        push @files, $arg;
    }
}
foreach my $f (@files) {
    open F, '<', $f or die "$0: Can't open $f: $!\n";
    # process F
    @array = <F>;
    if($#files > 1){
	print "==> $f <==\n"
    }
    if($index){   
	$offset = ($index > $#array) ? 0 : $#array - $index +1;
    }else{
    	$offset = ($#array > 9) ? $#array - 9 : 0;
    }

    foreach my $data (@array[$offset..$#array]){
	print $data;
    }
    close F;
}

if(@ARGV == 0){
    @a = <STDIN>;
    for($i = ($#a > 9) ? $#a - 9 : 0; $i <= $#a; ++$i){
    	 print $a[$i];
    }
}

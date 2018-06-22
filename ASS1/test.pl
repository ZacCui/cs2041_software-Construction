#!/usr/bin/perl -w
# written by andrewt@cse.unsw.edu.au as a 2041 lecture example
# run as count_first_names.py enrollments
# count how many people enrolled have each first name


while( $line = <>){
	$fields = split(/'|'/ , $line);
	$student_number = $fields[1];
	if( student_number $in %already_counted){
		next;
	}
	$already_counted{$student_number} = 1;
	$full_name = $fields[2];
	$full_name =~ /.*,\s+(\S+)/;
	if( $m){
		$first_name = $m.group(1);
		if( first_name $in %fn){
		}
			$fn{$first_name} += 1;
		else{
		}
			$fn{$first_name} = 1;

	}
}
foreach $first_name (sorted(fn.keys())){
	print "There are %2d people with the first name %s"%($fn{$first_name}," ",$first_name), "\n";
}

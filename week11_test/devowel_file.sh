#!/bin/sh

for arg in $@
do
	data=`cat $arg | sed 's/[aeiou]//gi'`
	printf "$data\n" > $arg
done

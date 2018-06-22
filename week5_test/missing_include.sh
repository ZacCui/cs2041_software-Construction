#!/bin/sh

SAVE=IFS
IFS=$(echo -en "\n\b")
for file in $@
do
	names=`cat $file | egrep "#include" | egrep -o "\".*\"" | sed "s/\"//g"`
	for name in $names
	do
		[ ! -e $name ] && echo "$name included into $file does not exist"
	done
done
IFS=SAVE

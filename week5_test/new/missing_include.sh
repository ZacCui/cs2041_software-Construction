#!/bin/sh

save= $IFS
IFS=$(echo -en "\n\b")
for file in $@
do
	files=`egrep '^#include\s*\"' $file | egrep -o '\w+\.\w+'`
	for name in $files
	do
		if [ ! -e $name ]
		then
			echo "$name included into $file does not exist"
		fi
	done
done

IFS=$save

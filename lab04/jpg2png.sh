#!/bin/sh

jpg="*.jpg"
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for file in $jpg
do
	[ ! -r $file ] && exit 1
	base=$(basename $file)
	name=${base%.*}
	png=$name.png
	if [ -r $png ]
	then
		echo "$png already exists"
	else
		convert $file $png && rm $file
	fi
done
IFS=$SAVEIFS

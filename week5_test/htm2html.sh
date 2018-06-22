#!/bin/sh

SAVE=IFS
IFS=$(echo -en "\n\b")
data=*.htm
for file in $data
do
	[  ! -r $file ] && continue
	base=$(basename $file)
	name=${base%.*}
	[ -r "$name.html" ] && echo "$name.html exists" && exit 1
	mv $file $name.html
done
IFS=SAVE

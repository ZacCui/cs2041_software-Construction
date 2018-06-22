#!/bin/sh

save=$IFS
IFS=$(echo -en "\n\b")

for file in *.htm
do
	[[ ! -e $file ]] && echo "No $file"&&continue
	base=$(basename $file)
	name=${base%.*}
	html=$name.html
	[  -e $html ] && echo "$html exists" && exit 1
	mv $file $html
done

IFS=$save

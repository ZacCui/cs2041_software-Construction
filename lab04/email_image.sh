#!/bin/sh

[ "$#" = "0" ] && exit 1
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for file in $@
do
	[ ! -r $file ] && echo "$file not exists" && continue
	display $file
	echo "Address to e-mail this image to?"
	while read address
	do
		addr="$address" ; break
	done
	echo "Message to accompany image?"
	while read message
	do
		mess="$message" ; break
	done
	base=$(basename $file)
	name=${base%.*}
	echo "$mess" |mutt -s "$name" -e 'set copy=no' -a $file -- "$addr"
	echo "$file sent to $addr"
done
IFS=$SAVEIFS

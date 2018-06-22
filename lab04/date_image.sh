#!/bin/sh
[ "$#" = "0" ] && exit 1
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for file in $@
do
	[ ! -r $file ] && echo "$file not exists" && continue
	curr_time=`ls -l "$file" | cut -d' ' -f6,7,8`
	time_format=`find penguins.jpg -maxdepth 0 -printf "%TY%Tm%Td%TH%TM\n"`
	convert -gravity south -pointsize 36 -draw "text 0,10 '$curr_time'" "$file" "$file"	
	touch -t "$time_format" "$file"
done
IFS=$SAVEIFS

#!/bin/sh
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for file in $@
do
	#echo $file
	dir="$file/"
	album=`echo $file | sed -E "s/.*\///g"`
	#echo $album
	year=`echo $file | sed -E "s/.*, //g"`
	#echo $year
	for content in $(ls $file)
	do
		#echo $content
		title=`echo $content | egrep -o "[-].*[-]" | sed -E "s/.?-.?//g"`
                #echo $title
		artist=`echo $content | sed -e "s/.*- //g;s/.mp3//"`
                #echo $artist
		track=`echo $content | sed -e "s/ -.*//g"`
		#echo $track
		#echo "$dir$content"
		id3 -t $title "$dir$content" > /dev/null
		id3 -T $track "$dir$content" > /dev/null
		id3 -a $artist "$dir$content" > /dev/null
		id3 -y $year "$dir$content" > /dev/null
		id3 -A $album "$dir$content" > /dev/null
	done
done
IFS=$SAVEIFS

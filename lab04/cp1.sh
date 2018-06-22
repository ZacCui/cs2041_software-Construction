#!/bin/sih

[ ! "$#" = "1" ] && exit 1

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
path="$1"
for file in $(ls $path)
do
	name=`echo $file |sed -E 's/:$//g'`
	if [ -d $name ]
	then
		echo $name
		dir="$name/"
		album=` echo $name | sed -E "s/.*\///g"`
		year=`echo $name | sed -E "s/.*, //g"`
		echo $year
		continue
	else
		title=`echo $name | egrep -o "[-].*[-]" | sed -E "s/.?-.?//g"`
		artist=`echo $name | sed -e "s/.*- //g;s/.mp3//"`
		track=`echo $name | sed -e "s/ -.*//g"`
	fi
	id3 -t $title "$dir$name" > /dev/null
	id3 -T $track "$dir$name" > /dev/null
	id3 -a $artist "$dir$name" > /dev/null
	id3 -A $album "$dir$name" > /dev/null
	id3 -y "$year" "$dir$name" > /dev/null
done
IFS=$SAVEIFS

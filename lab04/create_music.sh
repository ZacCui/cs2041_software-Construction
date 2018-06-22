#!/bin/sh

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
dir=`wget -q -O- 'https://en.wikipedia.org/wiki/Triple_J_Hottest_100?action=raw' |
cat -A |
egrep "style=\"text-align:center; vertical-align:middle" |
sed -E  "s/.*\[\[//g;s/\]\].*//g;s/\|.*//g" |
egrep -v "of"`
for name in $dir
do
	[ ! -d created_music ] && mkdir created_music
	mkdir ./created_music/"$name"
done
IFS=$SAVEIFS





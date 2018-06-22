#!/bin/sh

[ $# -ne 3 ] && exit 0
[ -e "$3" ] && rm "$3" 
for(( i = $1; i <= $2; ++i ))
do
	echo $i >> "$3"
done

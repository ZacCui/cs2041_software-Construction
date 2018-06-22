#!/bin/sh

[[ $# -eq 0 ]] && echo "quit" &&exit 0

if [ $# -eq 2 ]
then
	[[ $1 -lt 0 ]] && echo "cannot process negative number" && exit 0
	for ((i=0;i<$1;i++))
	do
		echo $2
	done
else
	echo "Args not crrect"
fi

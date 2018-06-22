#!/bin/sh

argc1="$1"
argc2="$2"
integer='^[0-9]+'

if test "$#" -ne 2
then
	echo "Usage: ./echon.sh <number of lines> <string>"
elif [[ $argc1 =~ $integer ]]
then
	for ((i=0;i<$argc1;i++))
        do
                echo "$2"
        done
else
	echo "./echon.sh: argument 1 must be a non-negative integer"
fi

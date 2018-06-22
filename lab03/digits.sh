#!/bin/sh
while read data
do
	echo $data | tr '[0-4]' '<' | tr '[6-9]' '>'
done

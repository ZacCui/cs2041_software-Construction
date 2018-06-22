#!/bin/sh

data=$1

cat $data | egrep "COMP[29]041" |
uniq |
cut -d'|' -f3|
egrep -o ", [A-Z][a-z]+" |
sed "s/, //g" |
sort |
uniq -c |
sort -n -k1 |
tail -1 |
egrep -o -i "[a-z]+"

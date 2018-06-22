#!/bin/sh

egrep 'COMP[29]041' $1 | cut -d\| -f3 | 
sed 's/\s*$//g'|
egrep -o ', \w+'  |
sort | uniq -c |
sort -nr | head -1 |
sed 's/.*, //'

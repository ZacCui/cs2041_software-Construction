#!/bin/sh
#grep 'F$'|cut -d\| -f2|sort|uniq

egrep -o '[0-9]{7}' | sort | uniq

#!/usr/bin/python

import sys, re

line = sys.stdin.readline()
line=re.sub('[0-4]','<',line)
line=re.sub('[6-9]','>',line)
print line,

#!/usr/bin/python3

import sys

if len(sys.argv) < 2:
	sys.exit(1)
dic = {}
for line in sys.argv:
	if line == sys.argv[0]:
		continue
	if line not in dic:
		print(line,end=' ')
		dic[line] = 1
print()


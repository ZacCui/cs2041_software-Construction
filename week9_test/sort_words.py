#!/usr/bin/python3

import sys

for line in sys.stdin.readlines():
	list = line.split()
	print(*sorted(list),end='')
	print()

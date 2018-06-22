#!/usr/bin/python3

import sys, re, glob
first = 0
last = len(sys.argv[1]) - 1
arr = list(sys.argv[1])
a = arr[0]
b = arr[-1]
flag = False
while first <= last:
	while not re.match('[a-z]',a,re.I):
		first += 1
		a = arr[first]
	while not re.match('[a-z]',b,re.I):
		last -= 1
		b = arr[last]
	if a.lower() != b.lower():
		print("False")
		flag = True
		break
	first += 1
	last -= 1
	a = arr[first]
	b = arr[last]

if not flag:
	print("True")

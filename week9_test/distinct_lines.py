#!/usr/bin/python3

import sys,re

if len(sys.argv) < 2:
	sys.exit(1)

dic = {}
num = int(sys.argv[1])
count = 0
for line in sys.stdin.readlines():
	if len(dic) == num:
		break
	line=re.sub('\s+',"",line)
	dic[line.lower()]=1
	count += 1

if(len(dic) == num):
	print("%d distinct lines seen after %d lines read." % (num, count))
else:
	print("End of input reached after %d lines read -  %d different lines not seen." % (count,num))

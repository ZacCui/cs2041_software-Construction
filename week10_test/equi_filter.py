#!/usr/bin/python3

import sys,re
dic = {}
list = []
for line in sys.stdin.readlines():
	temp=[]
	a = re.split('\s+',line)
	for word in a:
		dic = {}
		flag = 0;
		for char in word:
			if char not in  dic:
				dic[char.lower()] = 1
			else:
				dic[char.lower()] += 1
				flag = 1
		count = {}
		for i in dic:
			count[dic[i]] = 1;
		if (not flag or len(count)) == 1:
			temp.append(word)
	str = ' '.join(temp)
	print(str)
	

#!/usr/bin/python3

import sys, re

for file in sys.argv[1:]:
	f = open(file,'r')
	data = f.read()
	data = re.sub('[aeiouAEIOU]','',data)
	F = open(file,'w')
	F.write(data)
	f.close()
	F.close()


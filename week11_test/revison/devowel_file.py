#!/usr/bin/python3

import sys, re

for file in sys.argv[1:]:
	with open(file) as f:
		content = f.read()
	content = re.sub('[aeiuo]','',content,flags=re.I)
	with open(file,"w") as f:
		f.write(content)

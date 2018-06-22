#!/usr/bin/python

import sys,re,glob,math,operator
from collections import defaultdict
if len(sys.argv) < 1:
    sys.exit(1)

total = defaultdict(float)
count = defaultdict(float)
log = defaultdict(float)
list = []
song = defaultdict(float)
for filename in glob.iglob('./lyrics/*.txt'):
	file = open(filename,"r")
	filename = re.sub('.*/','',filename)
	filename = re.sub('.txt','',filename)
	filename = re.sub('_',' ',filename)
	for line in file:
		for word in re.split("[^a-zA-Z]",line):
			if(word == ""): continue
			count[filename,word.lower()] += 1
			total[filename] += 1.0
	file.close() 

for file,word in count:
	log[file,word] = math.log((count[file,word]+1)/total[file])

for arg in sys.argv:
	if(arg == "-d"):
		d_flag = 1;
	elif(arg == sys.argv[0]):
		continue
	else:
		list.append(arg)
for arg in list:
	file = open(arg,"r")
	for line in file:
		for word in re.split("[^a-zA-Z]",line):
			if(word == ""): continue
			for file in total:
				if(log[file,word.lower()]):					
					song[arg,file] += log[file,word.lower()]
				else:
					song[arg,file] += math.log((1)/total[file])

for a in sorted(song,  key=lambda x: (x[0], x[1] ), reverse=True):
	print a

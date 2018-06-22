#!/usr/bin/python3

import sys
a = list(map(int,sys.argv[1:]))
a = sorted(a)
mid = len(a)//2
print(a[mid])

#! /usr/bin/env python3

import gzip
import sys

out = gzip.open(sys.argv[2], 'wt')

l = 1
with gzip.open(sys.argv[1], 'rt') as fhand:
	i = 1
	for line in fhand:
		if i%4 == 1:
			out.write('@M00900:62:000000000-A2CYG:1:1101:18016:2491 1:N:0:13\n')
			l += 1
		else:
			out.write(line)
		i += 1
out.close()

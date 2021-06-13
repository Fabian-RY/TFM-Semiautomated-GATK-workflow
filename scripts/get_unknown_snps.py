# -*- coding: utf-8 -*-
"""
Created on Tue Mar 23 10:47:29 2021

@author: fabia
"""

import sys
import gzip

file = sys.argv[1]
out = sys.argv[2]

fout = open(out, 'w')

with gzip.open(file, 'rt') as fhand:
    for line in fhand:
        if line.startswith('#'):
            fout.write(line)
        else:
            data = line.split('\t')
            if data[2] == '.':
                fout.write(line)
            else:
                continue
fout.close()

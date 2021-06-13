#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  9 09:48:55 2020

@author: fabian
"""

import sys
import math
from collections import defaultdict

import matplotlib.pyplot as plt

def get_exome_positions(bedhandler):
    """
        Read the bedfile with the exome sequences position
        
        Input: Handler of a bedfile 
    """
    exome_positions = defaultdict(list) # Dict with keyword-values as chr#-exome position((1,2), (3,4))
    for line in bedhandler:
        chr_, start, end = line.strip("\n").split("\t")
        exome_positions[chr_].append((int(start), int(end)))
    return exome_positions

if __name__ == '__main__':
    exomebedfile = sys.argv[1]
    exomebed = get_exome_positions(open(exomebedfile))
    lengths = list()
    for chr_ in exomebed:
        for start, end in exomebed[chr_]:
            lengths.append(math.log(int(end-start)))

    lengths = list(i for i in lengths if i >= 1 and i <= 10)
    plt.hist(lengths)
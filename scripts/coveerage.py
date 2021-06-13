#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 26 11:35:19 2021

@author: fabian
"""

import matplotlib.pyplot as plt
import sys

data = list()

with open(sys.argv[1]) as fhand:
    for line in fhand:
        data.append(int(line.strip()))

plt.hist(data, 50, density=False, facecolor='g', alpha=0.75)
plt.show()
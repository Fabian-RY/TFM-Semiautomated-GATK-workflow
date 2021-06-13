#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 25 10:29:04 2021

@author: fabian
"""

import gzip
import sys

DPs = list()

with open(sys.argv[1], 'r') as vcfhand:
    for line in vcfhand:
        if line.startswith('#'):
            continue
        else:
            line = line.split()[7]
            elements = line.split(';')
            for element in elements:
                if 'DP' in element:
                    print(element)
                    DP = element.split('=')[1]
                    DPs.append(DP)
                    
with open(sys.argv[2], 'w') as DPhand:
    for item in DPs:
        print(item, file=DPhand, end='\n')

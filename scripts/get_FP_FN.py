#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 17 12:33:35 2021

@author: fabian
"""

import sys
import gzip

diff_file = sys.argv[1]
vcf1 = sys.argv[2]
vcf2 = sys.argv[3]

FP = list()
FN = list()
common = list()

with open(diff_file) as diff:
    for line in diff:
        data = line.strip('\n').split('\t')
        pos1 = data[1]
        pos2 = data[2]
        chrom = data[0]
        if pos1 == '.': # FN
            FN.append((chrom, pos2))
        elif pos2 == '.': # FP
            FP.append((chrom, pos1))
        else:
            common.append((chrom, pos1))
            
print(len(FP))
print(len(FN))
print(len(common))

vcf1hand = gzip.open(vcf1, 'rt')
vcf2hand = gzip.open(vcf2, 'rt')
vcfcommon = open('common.vcf', 'w')
vcfFP = open('FP.vcf', 'w')
vcfFN = open('FN.vcf', 'w')

for line in vcf1hand:
    if line.startswith('#'):
        vcfcommon.write(line)
        vcfFP.write(line)
        continue
    data = line.strip('\n').split('\t')
    chrom, pos = data[0], data[1]
    if (chrom, pos) in common:
        vcfcommon.write(line)
    elif (chrom, pos) in FP:
        vcfFP.write(line)
    
for line in vcf2hand:
    if line.startswith('#'):
        vcfFN.write(line)
        continue
    data = line.strip('\n').split('\t')
    chrom, pos = data[0], data[1]
    if (chrom, pos) in FN:
        vcfFN.write(line)
        
vcf1hand.close()
vcf2hand.close()
vcfcommon.close()
vcfFP.close()
vcfFN.close()
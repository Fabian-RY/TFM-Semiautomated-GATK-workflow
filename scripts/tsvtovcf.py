#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Feb 15 10:24:24 2021

@author: fabian

Turns a illumina tsv report file into a vcf file for comparisons

"""

import sys
import gzip

class SNP:
    
    def __init__(self, chr_, pos, id_, ref,  alt, qual = '500', filter_ = 'PASS', info = [], samples = []):
        self.chr = chr_
        self.id = id_
        self.pos = pos
        self.ref = ref
        self.alt = alt
        self.qual = qual
        self.filter = filter_
        self.info = info
        self.samples = samples

    def __eq__(self, snp):
        return self.chr == snp.chr and self.pos == snp.pos

from_ = sys.argv[1]
to = sys.argv[2]

if to.endswith('.gz'): op = gzip.open
else: op = open

with open(from_) as fhread:
    fhwrite = op(to, 'wt')
    fhwrite.write('##fileformat=VCFv4.2')
    fhwrite.write("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n")
    for line in fhread:
        if line.startswith('#'): continue
        line = line.split('\t')
        snp = SNP(line[1], line[2], '.', line[3], line[4], info=[['AF', line[5]], ['DP', line[6]]])
        fhwrite.write('\t'.join([snp.chr, snp.pos, snp.id, snp.ref, snp.alt, snp.qual, snp.filter]))
        fhwrite.write('\t'+snp.info[0][0]+'='+snp.info[0][1]+';'+snp.info[1][0]+'='+snp.info[1][1]+';')
        fhwrite.write('\n')
    fhwrite.close()
        
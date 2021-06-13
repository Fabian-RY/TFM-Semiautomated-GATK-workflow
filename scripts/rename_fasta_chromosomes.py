#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  9 18:51:15 2020

@author: fabian
"""

import sys
import gzip
from collections import OrderedDict

genome = sys.argv[1]

def get_fasta_genome(fastahandler):
    seqs = OrderedDict()
    seq = ""
    name = ""
    for line in fastahandler:
        line = line.strip('\n')
        if line.startswith('>'):
            name = line[1:]
            seqs[name] = seq
            seq = ""
        else:
            seq += line
    seqs[name] = seq
    return seqs

i = 1
seqs = OrderedDict()
for key, value in get_fasta_genome(gzip.open(genome, 'rt')).items():
    seqs['chr'+str(i)] = value

with gzip.open('eexome.fa.gz', 'wt') as gfhand:
    for chr_, seq in seqs.items():
        gfhand.write(">"+chr_+'\n')
        gfhand.write(seq+'\n')
        i += 1
gfhand.close()
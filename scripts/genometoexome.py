#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  7 10:09:23 2020

@author: fabian
"""

import sys
from collections import defaultdict, OrderedDict
import gzip

from Bio import SeqIO, Seq

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

def get_seq_equivalence(fhand):
    a = dict()
    for line in fhand:
        line = line.strip('\n').split()
        a[line[1]] = line[0]
    return a

if __name__ == '__main__':
    bedfilename = sys.argv[1] # Getting the bed file from the command-line
    genomefilename = sys.argv[2] # Geting the genome file from the commandline
    correspondence = "chrs.txt"
    exomefilename = sys.argv[3] # Getting the exome file name from the command line
    print("This script assumes that the chromosome are ordered inside the fasta file to assing a more readable name. Be careful with that!")
    with open(bedfilename) as bedhand:
        exome = get_exome_positions(bedhand)
    with open(correspondence) as fhand:
        corresp = get_seq_equivalence(fhand)
    genome = SeqIO.parse(gzip.open(genomefilename, 'rt'), 'fasta')
    exomefhand = gzip.open(exomefilename, "wt") 
    for seq in genome:
        if seq.id in corresp:
            print(seq.id, corresp[seq.id])
        else:
            continue
        exons = exome[corresp[seq.id]]
        i = 1
        for start, end in exons:
            seq_ = seq[start:end+1]
            seq_.id = corresp[seq.id]+'-'+str(i)+'-'+str(end-start)+'pb'+'-'+str(start)+'-'+str(end)
            i += 1
            SeqIO.write(seq_, exomefhand, 'fasta')
        print(f"{len(exons)} exons in {corresp[seq.id]}")
    exomefhand.close()

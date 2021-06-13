#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 17 10:31:46 2021

@author: fabian
"""

import sys
import gzip
from collections import defaultdict

def is_indel(ref, alt):
    return not len(ref) == len(alt)

def is_transversion(ref, alt):
    if is_indel(ref, alt): 
        return False
    elif (ref == 'A' or ref == 'G') and (alt == 'T' or alt == 'C'):
        return True
    elif (ref == 'T' or ref == 'C') and (alt == 'A' or alt == 'G'):
        return True
    else:
        return False

def print_sumary(name, mutations, transitions, 
                 transversions, discarded, indels):
    print('Variants in  {}:'.format(name))
    print('Total transitions: {}:'.format(transitions))
    for pair in mutations_count:
        if not is_transversion(pair[0], pair[1]) and not is_indel(pair[0], pair[1]):
            print('{} -> {}\t{}'.format(pair[0], pair[1], mutations_count[pair]))
    print()
    print('Total transversions {}:'.format(transversions))
    for pair in mutations_count:
        if is_transversion(pair[0], pair[1]) and not is_indel(pair[0], pair[1]):
            print('{} -> {}\t{}'.format(pair[0], pair[1], mutations_count[pair]))
    print()
    print('Total Indels: {}'.format(indels))
    for pair in mutations_count:
        if is_indel(pair[0], pair[1]):
            print('{} -> {}\t{}'.format(pair[0], pair[1], mutations_count[pair]))

    print()
    print('Discarded due to multiple aligning: {}'.format(discarded))

if __name__ == '__main__':
    mutations_count = defaultdict(int)
    indels_count = defaultdict(int)
    transitions = 0
    transversions = 0
    indels = 0
    discarded = 0
    vcffilename = sys.argv[1]
    
    if vcffilename.endswith('.vcf'):
        fhand = open(vcffilename)
    elif vcffilename.endswith('.vcf.gz'):
        fhand = gzip.open(vcffilename, 'rt')
    else:
        print("Input must be .vcf or .vcf.gz", file=sys.stderr)
        sys.exit(1)
    
    for line in fhand:
        if line.startswith('#'):
            continue
        variant_data = line.strip('\n').split('\t')
        ref_allele = variant_data[3]
        alt_allele = variant_data[4]
        if ',' in alt_allele:
            discarded += 1
            continue
        elif not is_indel(ref_allele, alt_allele):
            mutations_count[(ref_allele, alt_allele)] += 1
            if is_transversion(ref_allele, alt_allele):
                transversions += 1
            else: transitions += 1
        else:
            mutations_count[(ref_allele, alt_allele)] += 1
            indels += 1
    print_sumary(sys.argv[1], mutations_count, 
                 transitions, transversions, discarded, indels)
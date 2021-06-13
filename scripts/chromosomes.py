# -*- coding: utf-8 -*-
"""
Created on Fri Nov 27 12:33:36 2020

@author: fabia
"""

def count_chromosomes(fhand):
    chromosomes = 0
    bases = 0
    for line in fhand:
        if not line.startswith('>'):
            bases += len(line.strip('\n'))
            pass
        elif 'chromosome' not in line and line.startswith('>'):
            return bases
        else:
            print(f'Bases till now: {bases}')

with open('GCA_002077035.3_NA12878_prelim_3.0_genomic.fna') as handler:
    bases = count_chromosomes(handler)
    print(bases)
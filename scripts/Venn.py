#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  2 10:10:46 2021

@author: fabian
"""

import sys
import gzip

class VCF:
    
    def __init__():
        pass


def check_equals(illumina, gatk):
    counter = 0
    for snp in illumina:
        for snp2 in gatk:
            if snp == snp2:
                counter += 1
                break
    return counter

class SNP:
    
    def __init__(self, chr_, pos, id_, ref, alt, info = [], samples = []):
        self.chr = chr_
        self._id = id_
        self.pos = pos
        self.ref = ref
        self.alt = alt
        self.info = info
        self.samples = samples

    def __eq__(self, snp):
        return self.chr == snp.chr and self.pos == snp.pos


from matplotlib_venn import venn2
from matplotlib import pyplot as plt


venn2(subsets = (15, 10, 5), set_labels = ('Illumina', 'GATK'))
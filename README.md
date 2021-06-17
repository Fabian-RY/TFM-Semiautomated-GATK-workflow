# TFM-Semiautomated-GATK-workflow

This repository include any data and scripts related to the project "A semiautomated Targeted-sequencing workflow to improve performance of variants in clinical samples" It is divided in several folders

## bed files

The bed files are hosted here. The high confidence exome regions bed file can be downloaded from the NIST server [here](A semiautomated Targeted-sequencing workflow to improve performance of variants in clinical samples). The Illumina trusight bed file and Amplicon panel bed file are hosted here. 

## Scripts

Different scripts used at any moment in the project, to change file format or anything needed in the moment. 

## Graphic_scripts

R scripts to obtain the graphincs included in the mansucript, and the data needed to replicate them

## Pipeline.sh

The GATK pipeline used to compare results with Dragen protocol. It depends on the necesarry programs to be installed and tho have the path in the script:

### Sotware needed
  - Java
  - Trimmomatic
  - Burrows-wheeler aligner (BWA)
  - The genome analysis Toolkit
  - snpEff (and desired databased for your genome downloaded and ready)
  - picard

### Databases/files neded
  - The reference genome to align the samples
  - The dbsnp vcf database to get the id
  - The clinvar vcf database to get the clinical relevant data.
  - 

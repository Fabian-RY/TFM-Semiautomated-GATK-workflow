library("rmarkdown")
library('vcfR')
library(stringr)

args = args = c('/home/fabian/Descargas/bams/193700_exome.bam', '/home/fabian/Descargas/bad_snps.vcf', '/home/fabian/Descargas/bad_indel.vcf') #commandArgs(trailingOnly=TRUE)
bam = args[1]
vcf_snp = args[2]
vcf_indel = args[3]
bed_file = args[4]
snps <- vcfR::read.vcfR(vcf_snp)
indels <- vcfR::read.vcfR(vcf_indel)

###### Number of variants

depth
cov
num_reads_
paired
num_variants
num_transversions
num_transitions

############## Variants
dbsnpid <- c()
clinvarID <- c()

for (i in vcfR::getID(snps)){
  ids <- unlist(strsplit(i, ';'))
  dbsnpid <- append(dbsnpid, ids[1])
  clinvarID <- append(clinvarID, ids[-1])
}
clinvarID <- append(clinvarID, NA)
ALTs <- unlist(vcfR::getALT(snps))
REFs <- unlist(vcfR::getREF(snps))
CHROM <- unlist(vcfR::getCHROM(snps))
POS <- unlist(vcfR::getPOS(snps))
infor <- unlist(vcfR::getINFO(snps))
variants <- data.frame(dbsnpid, clinvarID, CHROM, POS, REFs, ALTs, check.rows = FALSE)
variants <- variants[order(variants$CHROM, variants$POS), ]


render( input="report_template.rmd", output_file=paste0("/media/fabian/Osiris2/TFM/scripts/report.pdf") )

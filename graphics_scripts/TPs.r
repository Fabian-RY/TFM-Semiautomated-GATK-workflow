library(ggplot2)

csv_path <- '/home/fabian/Documentos/TPs.csv'
snps <- read.csv(csv_path)

## True positive grpah:
## Proportion of common variants in both dataset to those in the gold dataset

snps <- snps[1:24, ]
snps$Notes <- factor(snps$Notes, levels = c('Non-filtered', 'DP > 10', 'DP > 30'))
ref <- snps$Reference..SNP

ggplot(snps, aes(x = Sample, y = TP/ref, fill = Notes)) + 
  geom_bar(position="dodge", stat = "identity") + ggtitle("Proportion of true positives") +
  xlab('Sample ID') + ylab('Proportion of TP found that were present in gold dataset')


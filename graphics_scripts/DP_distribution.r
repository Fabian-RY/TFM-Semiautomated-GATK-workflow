library(ggplot2)

csv_path <- '/media/fabian/Osiris2/TFM/variants/Exomes/variants/FP_DP.txt'
snps <- read.csv(csv_path, header = FALSE )
ggplot(data=snps, aes(V1)) + geom_histogram(bins= 100) + geom_vline(xintercept=30) + scale_x_continuous(n.breaks = 5) +
  ggtitle('Distribution of SNPs by DP') + xlab('Read Depth') + ylab('Number of variants')
  

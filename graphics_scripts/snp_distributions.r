library(ggplot2)

csv_path <- '/home/fabian/Documentos/Snp_indel_dist.csv'
snps <- read.csv(csv_path)
samples <- snps$Sample
samle <- c(rep(as.character(samples), 2))
num_snps <- snps[, 3]
num_indels <-snps[, 4]
values <- c(num_snps, num_indels)
variant <- c(rep('SNP', length(samle)/2), rep('Indel', length(samle)/2))
called <- c(rep(as.integer(snps[, 2]), 2))
snps <- data.frame(samle, values, variant, called)

ggplot(snps, aes(x = samle, y = values, fill = variant)) + 
  geom_bar(stat = "identity") + ggtitle("Variants per sample") + 
  theme(plot.title = element_text(lineheight=.8, face="bold")) +
  geom_text(aes(x = samle, y = called-values + 50, label = values))+
  geom_text(aes(x = samle, y = called + 100, label = called)) +
  xlab('Sample ID') + ylab('Number of variants per sample')

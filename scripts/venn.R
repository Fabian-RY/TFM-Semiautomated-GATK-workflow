library("VennDiagram")
grid.newpage()
draw.pairwise.venn(area1 = 1982 +25026, area2= 2963+25026, cross.area= 25026, alpha=0.2,
                   col='black', fill=c('yellow', 'red'), category= c('GIST', 'GATK'),
                   euler.d = TRUE, scaled=TRUE)


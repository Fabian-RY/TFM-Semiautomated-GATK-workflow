library(ggplot2)

data <- read.csv("/media/fabian/Osiris2/TFM/Reuniones/panel.csv", header= TRUE, sep=";")

ggplot(data, aes(x = Recall, y = Precision, color=as.factor(Sample), size=1000)) +
  geom_point() + ggtitle("Precision and recall for variants in Trusigh gene panel")+
  xlim(0.7, 1) + ylim(0, 1) + geom_hline(yintercept=1, linetype="dashed", color = "red")+
  geom_vline(xintercept=1, linetype="dashed", color = "red")

  
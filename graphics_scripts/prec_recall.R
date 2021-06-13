library(ggplot2)

data = read.csv('/media/fabian/Osiris2/TFM/Reuniones/Resultados gatk.csv', header = TRUE)

data.frame(data)

ggplot(data = data, aes(x = Recall, y = Precision, shape = as.character(Minlen)))  +  geom_point() + theme_minimal() +
  scale_color_brewer(palette = "Set2") +
  labs(x = "Recall", y = "Precision") +
  ggtitle("Acuracy of calling varying length trimming on quality control",
          "Being to sctrict lose ")  

###################################3333

data <- read.csv('/media/fabian/Osiris2/TFM/R graphics/germinal.csv', header = TRUE)
data
valid <- data[!is.na(data$Recall), ]
valid

ggplot(data = data, aes(x = Recall, y = Precision, shape = as.character(Sample)))  +  geom_point() + theme_minimal() +
  scale_color_brewer(palette = "Set2") +
  labs(x = "Recall", y = "Precision") +
  ggtitle("Acuracy of calling varying length trimming on quality control",
          "Being to sctrict lose ")
boxplot(data[, 4:5])
ggplot(data, aes(x = Parameter, y = Value)) + ylim(0.9, 1) +         # Applying ggplot function
  geom_boxplot() + labs(title='Precision and recall for Germline variant SNV calling', subtitle='In Exome datasets')

# plotting_defaults.R
library(ggplot2)

theme_set(theme_classic())

black <- "#000000" # Use color hex codes for consistency
grey <- "#808080"

# you can store ggplot functions in varibles for later use!
theme_and_axis_nolegend <- theme(legend.position = "None",
                                 text = element_text(size=25, face = "bold"),
                                 axis.text = element_text(size = 18, face = "bold", color = black),
                                 axis.line = element_line(color = black, size = 0.6))

theme_and_axis_legend <- theme(text = element_text(size=25, face = "bold"),
                               legend.title = element_blank(),
                               legend.background = element_blank(),
                               axis.text = element_text(size = 18, face = "bold", color = black),
                               axis.line = element_line(color = black, size = 0.6))

custom_annotation_size <- 8
pt_alpha <- 0.6
pt_stroke <- 1
line_size <- 1.5
ecdf_pt_size <- 5
pt_size <- 2
narrow_jitter_width <- 0.25
barplot_width <- 0.5
ctrl_color <- scale_color_manual(values = c(black, grey)) 
# and so on... 
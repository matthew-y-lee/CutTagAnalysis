library(dplyr)
library(stringr)
library(ggplot2)
library(viridis)
library(GenomicRanges)
#library(chromVAR) ## For FRiP analysis and differential analysis
#library(DESeq2) ## For differential analysis section
library(ggpubr) ## For customizing figures
library(corrplot) ## For correlation plot
#library(bowtie2)

## Plots distribution of fragment sizes
## ==== RUN ./fragmentsize.sh TO GET FRAGMENT SIZES ===== ##

projPath='/Users/matthewlee/Desktop/Columbia/Sequencing'
sampleList = c("SMC1-2", "Gro-1", "Gro-2", "CtBP-1", "CtBP-2", "FLAG-1", "FLAG-2", "Ubx-1", "Ubx-2")
proteinList = c("SMC1", "Gro", "CtBP", "FLAG", "Ubx")

fragLen = c()
for(protein in sampleList){
  protInfo = strsplit(protein, "-")[[1]]
  fragLen = read.table(paste0(projPath, "/alignment/sam/fragmentLen/", protein, "_fragmentLen.txt"), header = FALSE) %>% mutate(fragLen = V1 %>% as.numeric, fragCount = V2 %>% as.numeric, Weight = as.numeric(V2)/sum(as.numeric(V2)), Protein = protInfo[1], Replicate = protInfo[2], sampleInfo = protein) %>% rbind(fragLen, .) 
}
fragLen$sampleInfo = factor(fragLen$sampleInfo, levels = sampleList)
fragLen$Protein = factor(fragLen$Protein, levels = proteinList)
## Generate the fragment size density plot (violin plot)
fig5A = fragLen %>% ggplot(aes(x = sampleInfo, y = fragLen, weight = Weight, fill = Protein)) +
  geom_violin(bw = 5) +
  scale_y_continuous(breaks = seq(0, 800, 50)) +
  scale_fill_viridis(discrete = TRUE, begin = 0.1, end = 0.9, option = "magma", alpha = 0.8) +
  scale_color_viridis(discrete = TRUE, begin = 0.1, end = 0.9) +
  theme_bw(base_size = 20) +
  ggpubr::rotate_x_text(angle = 20) +
  ylab("Fragment Length") +
  xlab("")

fig5B = fragLen %>% ggplot(aes(x = fragLen, y = fragCount, color = Protein, group = sampleInfo, linetype = Replicate)) +
  geom_line(size = 1) +
  scale_color_viridis(discrete = TRUE, begin = 0.1, end = 0.9, option = "magma") +
  theme_bw(base_size = 20) +
  xlab("Fragment Length") +
  ylab("Count") +
  coord_cartesian(xlim = c(0, 500))

ggarrange(fig5A, fig5B, ncol = 2)

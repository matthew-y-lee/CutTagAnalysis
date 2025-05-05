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

projPath='/Users/matthewlee/Desktop/Columbia/Sequencing'
## ==== ALIGN TO DM6 GENOME ==== ####
## Need to run ./align.sh first on both 'fly' and 'e_coli' genomes

## Path to the project and sample list
sampleList = c("SMC1-2", "Gro-1", "Gro-2", "CtBP-1", "CtBP-2", "FLAG-1", "FLAG-2", "Ubx-1", "Ubx-2")
proteinList = c("SMC1", "Gro", "CtBP", "FLAG", "Ubx")

## Collect the alignment results from the bowtie2 alignment summary files
alignResult = c()
for(hist in sampleList){
  alignRes = read.table(paste0(projPath, "/alignment/sam/bowtie2_summary/", hist, "_bowtie2.txt"), header = FALSE, fill = TRUE)
  alignRate = substr(alignRes$V1[6], 1, nchar(as.character(alignRes$V1[6]))-1)
  histInfo = strsplit(hist, "-")[[1]]
  alignResult = data.frame(Protein = histInfo[1], Replicate = histInfo[2], 
                           SequencingDepth = alignRes$V1[1] %>% as.character %>% as.numeric, 
                           MappedFragNum_dm6 = alignRes$V1[4] %>% as.character %>% as.numeric + alignRes$V1[5] %>% as.character %>% as.numeric, 
                           AlignmentRate_dm6 = alignRate %>% as.numeric)  %>% rbind(alignResult, .)
}
alignResult$Protein = factor(alignResult$Protein, levels = proteinList)
alignResult %>% mutate(AlignmentRate_dm6 = paste0(AlignmentRate_dm6, "%"))

## ==== SPIKE IN GENOME ==== ##
spikeAlign = c()
for(hist in sampleList){
  spikeRes = read.table(paste0(projPath, "/alignment/sam/bowtie2_summary/", hist, "_E_coli_bowtie2.txt"), header = FALSE, fill = TRUE)
  alignRate = substr(spikeRes$V1[6], 1, nchar(as.character(spikeRes$V1[6]))-1)
  histInfo = strsplit(hist, "-")[[1]]
  spikeAlign = data.frame(Protein = histInfo[1], Replicate = histInfo[2], 
                          SequencingDepth = spikeRes$V1[1] %>% as.character %>% as.numeric, 
                          MappedFragNum_spikeIn = spikeRes$V1[4] %>% as.character %>% as.numeric + spikeRes$V1[5] %>% as.character %>% as.numeric, 
                          AlignmentRate_spikeIn = alignRate %>% as.numeric)  %>% rbind(spikeAlign, .)
}
spikeAlign$Protein = factor(spikeAlign$Protein, levels = proteinList)
spikeAlign %>% mutate(AlignmentRate_spikeIn = paste0(AlignmentRate_spikeIn, "%"))

alignSummary = left_join(alignResult, spikeAlign, by = c("Protein", "Replicate", "SequencingDepth")) %>%
  mutate(AlignmentRate_dm6 = paste0(AlignmentRate_dm6, "%"), 
         AlignmentRate_spikeIn = paste0(AlignmentRate_spikeIn, "%"))

# === GRAPH ==== #
## Generate sequencing depth boxplot
fig3A = alignResult %>% ggplot(aes(x = Protein, y = SequencingDepth/1000000, fill = Protein)) +
  geom_boxplot() +
  geom_jitter(aes(color = Replicate), position = position_jitter(0.15)) +
  scale_fill_viridis(discrete = TRUE, begin = 0.1, end = 0.9, option = "magma", alpha = 0.8) +
  scale_color_viridis(discrete = TRUE, begin = 0.1, end = 0.9) +
  theme_bw(base_size = 18) +
  ylab("Sequencing Depth per Million") +
  xlab("") + 
  ggtitle("A. Sequencing Depth")

fig3B = alignResult %>% ggplot(aes(x = Protein, y = MappedFragNum_dm6/1000000, fill = Protein)) +
  geom_boxplot() +
  geom_jitter(aes(color = Replicate), position = position_jitter(0.15)) +
  scale_fill_viridis(discrete = TRUE, begin = 0.1, end = 0.9, option = "magma", alpha = 0.8) +
  scale_color_viridis(discrete = TRUE, begin = 0.1, end = 0.9) +
  theme_bw(base_size = 18) +
  ylab("Mapped Fragments per Million") +
  xlab("") +
  ggtitle("B. Alignable Fragment (dm6)")

fig3C = alignResult %>% ggplot(aes(x = Protein, y = AlignmentRate_dm6, fill = Protein)) +
  geom_boxplot() +
  geom_jitter(aes(color = Replicate), position = position_jitter(0.15)) +
  scale_fill_viridis(discrete = TRUE, begin = 0.1, end = 0.9, option = "magma", alpha = 0.8) +
  scale_color_viridis(discrete = TRUE, begin = 0.1, end = 0.9) +
  theme_bw(base_size = 18) +
  ylab("% of Mapped Fragments") +
  xlab("") +
  ggtitle("C. Alignment Rate (dm6)")

fig3D = spikeAlign %>% ggplot(aes(x = Protein, y = AlignmentRate_spikeIn, fill = Protein)) +
  geom_boxplot() +
  geom_jitter(aes(color = Replicate), position = position_jitter(0.15)) +
  scale_fill_viridis(discrete = TRUE, begin = 0.1, end = 0.9, option = "magma", alpha = 0.8) +
  scale_color_viridis(discrete = TRUE, begin = 0.1, end = 0.9) +
  theme_bw(base_size = 18) +
  ylab("Spike-in Alignment Rate") +
  xlab("") +
  ggtitle("D. Alignment Rate (E.coli)")

ggarrange(fig3A, fig3B, fig3C, fig3D, ncol = 2, nrow=2, common.legend = TRUE, legend="bottom")
print(fig3D) #print individual panels since y axis labels are too big

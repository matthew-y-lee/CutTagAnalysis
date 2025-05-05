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

## Plot reproducibilty matrix between sample replicates
## ===== RUN ./reproducibility.sh ====== ###

projPath='/Users/matthewlee/Desktop/Columbia/Sequencing'
sampleList = c("SMC1-2", "Gro-1", "Gro-2", "CtBP-1", "CtBP-2", "FLAG-1", "FLAG-2", "Ubx-1", "Ubx-2")
proteinList = c("SMC1", "Gro", "CtBP", "FLAG", "Ubx")

reprod = c()
fragCount = NULL
for(protein in sampleList){
  
  if(is.null(fragCount)){
    fragCount = read.table(paste0(projPath, "/alignment/bed/bins/", protein, "_bowtie2.fragmentsCount.bin500.bed"), header = FALSE) 
    colnames(fragCount) = c("chrom", "bin", protein)
  }else{
    fragCountTmp = read.table(paste0(projPath, "/alignment/bed/bins/", protein, "_bowtie2.fragmentsCount.bin500.bed"), header = FALSE)
    colnames(fragCountTmp) = c("chrom", "bin", protein)
    fragCount = full_join(fragCount, fragCountTmp, by = c("chrom", "bin"))
  }
}

M = cor(fragCount %>% select(-c("chrom", "bin")) %>% log2(), use = "complete.obs") 

corrplot(M, method = "color", outline = T, addgrid.col = "darkgray", order="hclust", addrect = 3, rect.col = "black", rect.lwd = 3,cl.pos = "b", tl.col = "indianred4", tl.cex = 1, cl.cex = 1, addCoef.col = "black", number.digits = 2, number.cex = 1, col = colorRampPalette(c("midnightblue","white","darkred"))(100))
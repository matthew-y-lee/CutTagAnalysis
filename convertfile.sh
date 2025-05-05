#!/bin/bash

projPath="/Users/matthewlee/Desktop/Columbia/Sequencing"
declare -a sampleName=("SMC1-2" "Gro-1" "Gro-2" "CtBP-1" "CtBP-2" "FLAG-1" "FLAG-2" "Ubx-1" "Ubx-2")

for sample in "${sampleName[@]}"; do
	echo "Processing $sample..."
	samtools view -bS -F 0x04 $projPath/alignment/sam/${sample}_bowtie2.sam > $projPath/alignment/bam/${sample}_bowtie2.mapped.bam
	bedtools bamtobed -i $projPath/alignment/bam/${sample}_bowtie2.mapped.bam -bedpe > $projPath/alignment/bed/${sample}_bowtie2.bed
	awk '$1==$4 && $6-$2 < 1000 {print $0}' $projPath/alignment/bed/${sample}_bowtie2.bed > $projPath/alignment/bed/${sample}_bowtie2.clean.bed
	cut -f 1,2,6 $projPath/alignment/bed/${sample}_bowtie2.clean.bed | sort -k1,1 -k2,2n -k3,3n  >$projPath/alignment/bed/${sample}_bowtie2.fragments.bed
done


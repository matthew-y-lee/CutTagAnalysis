#!/bin/bash

projPath="/Users/matthewlee/Desktop/Columbia/Sequencing"
declare -a sampleName=("SMC1-2" "Gro-1" "Gro-2" "CtBP-1" "CtBP-2" "FLAG-1" "FLAG-2" "Ubx-1" "Ubx-2")

for sample in "${sampleName[@]}"; do
        echo "Processing $sample..."
	binLen=500
	awk -v w=$binLen '{print $1, int(($2 + $3)/(2*w))*w + w/2}' $projPath/alignment/bed/${sample}_bowtie2.fragments.bed | sort -k1,1V -k2,2n | uniq -c | awk -v OFS="\t" '{print $2, $3, $1}' |  sort -k1,1V -k2,2n  >$projPath/alignment/bed/bins/${sample}_bowtie2.fragmentsCount.bin$binLen.bed

done

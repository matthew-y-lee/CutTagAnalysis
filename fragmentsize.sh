#!/bin/bash

projPath='/Users/matthewlee/Desktop/Columbia/Sequencing'
declare -a proteinNames=("SMC1-2" "Gro-1" "Gro-2" "CtBP-1" "CtBP-2" "FLAG-1" "FLAG-2" "Ubx-1" "Ubx-2")

for protein in "${proteinNames[@]}"
do
	echo "Processing $protein..."
	samtools view -F 0x04 $projPath/alignment/sam/${protein}_bowtie2.sam | awk -F'\t' 'function abs(x){return ((x < 0.0) ? -x : x)} {print abs($9)}' | sort | uniq -c | awk -v OFS="\t" '{print $2, $1/2}' >$projPath/alignment/sam/fragmentLen/${protein}_fragmentLen.txt
done
echo "Finished"

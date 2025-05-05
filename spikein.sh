#!/bin/bash

spikeInRef="/Users/matthewlee/Desktop/Columbia/Sequencing/Escherichia_coli_K_12_MG1655_NCBI_2001-10-15/Escherichia_coli_K_12_MG1655/NCBI/2001-10-15/Sequence/Bowtie2Index/genome"

chromSize="/Users/matthewlee/Desktop/Columbia/Sequencing/Drosophila_melanogaster_UCSC_dm6/Drosophila_melanogaster/UCSC/dm6/dm6.chrom.sizes.txt"

projPath="/Users/matthewlee/Desktop/Columbia/Sequencing"
cores=8
declare -a input1=("/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_2-ds.31ee6f4909db41bab9f8d0eef375aaf6/2_2_S2_L001_R1_001.fastq.gz"\
 "/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_3-ds.315fcdeec57a44d2824f6e232870bc66/2_3_S3_L001_R1_001.fastq.gz"\
 "/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_4-ds.914e75c61ab141aaafbc17fe31993b73/2_4_S4_L001_R1_001.fastq.gz"\
 "/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_5-ds.7ad3afa268a74755b744046ab7302659/2_5_S5_L001_R1_001.fastq.gz"\
 "/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_6-ds.193e6b2a30dd4bbe8873c60cfb16a0d3/2_6_S6_L001_R1_001.fastq.gz"\
 "/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_7-ds.0b285e3dee2742e784bb5fee153779bc/2_7_S7_L001_R1_001.fastq.gz"\
 "/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_8-ds.db94b2a1cfae437da8056bf5aeb68571/2_8_S8_L001_R1_001.fastq.gz"\
 "/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_9-ds.8cffc8f7ef324b84ae5c615a7128e9cc/2_9_S9_L001_R1_001.fastq.gz"\
 "/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_10-ds.766cf15e362a49ff972bec8073abf6ac/2_10_S10_L001_R1_001.fastq.gz")

declare -a input2=("/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_2-ds.31ee6f4909db41bab9f8d0eef375aaf6/2_2_S2_L001_R2_001.fastq.gz"\
 "/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_3-ds.315fcdeec57a44d2824f6e232870bc66/2_3_S3_L001_R2_001.fastq.gz" \
"/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_4-ds.914e75c61ab141aaafbc17fe31993b73/2_4_S4_L001_R2_001.fastq.gz" \
"/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_5-ds.7ad3afa268a74755b744046ab7302659/2_5_S5_L001_R2_001.fastq.gz" \
"/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_6-ds.193e6b2a30dd4bbe8873c60cfb16a0d3/2_6_S6_L001_R2_001.fastq.gz" \
"/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_7-ds.0b285e3dee2742e784bb5fee153779bc/2_7_S7_L001_R2_001.fastq.gz" \
"/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_8-ds.db94b2a1cfae437da8056bf5aeb68571/2_8_S8_L001_R2_001.fastq.gz" \
"/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_9-ds.8cffc8f7ef324b84ae5c615a7128e9cc/2_9_S9_L001_R2_001.fastq.gz" \
"/Users/matthewlee/Desktop/Columbia/Sequencing/20250317-448120842/BCLConvert_03_25_2025_21_02_02Z-813375582/2_10-ds.766cf15e362a49ff972bec8073abf6ac/2_10_S10_L001_R2_001.fastq.gz")

declare -a proteinName=("SMC1-2" "Gro-1" "Gro-2" "CtBP-1" "CtBP-2" "FLAG-1" "FLAG-2" "Ubx-1" "Ubx-2")

for i in "${!input1[@]}"; do
#	bowtie2 --end-to-end --very-sensitive --no-overlap --no-dovetail --no-mixed --no-discordant --phred33 -I 10 -X 700 -p ${cores} -x ${spikeInRef} -1 ${input1[i]} -2 ${input2[i]} -S $projPath/alignment/sam/${proteinName[i]}_bowtie2_spikeIn.sam &> $projPath/alignment/sam/bowtie2_summary/${proteinName[i]}_bowtie2_spikeIn.txt
	seqDepthDouble=`samtools view -F 0x04 $projPath/alignment/sam/${proteinName[i]}_bowtie2_spikeIn.sam | wc -l`
	seqDepth=$((seqDepthDouble/2))	
	echo "$seqDepth	for ${proteinName[i]}"
	echo $seqDepth >$projPath/alignment/sam/bowtie2_summary/${histName}_bowtie2_spikeIn.seqDepth
	if [[ "$seqDepth" -gt "1" ]]; then
		mkdir -p $projPath/alignment/bedgraph
		scale_factor=`echo "10000 / $seqDepth " | bc -l`
		echo "Scale factor for ${proteinName[i]} is $scale_factor"
#		bedtools genomecov -bg -scale $scale_factor -i $projPath/alignment/bed/${proteinName[i]}_bowtie2.fragments.bed -g /Users/matthewlee/Desktop/Columbia/Sequencing/Drosophila_melanogaster_UCSC_dm6/Drosophila_melanogaster/UCSC/dm6/dm6.chrom.sizes.txt > $projPath/alignment/bedgraph/${proteinName[i]}_bowtie2.fragments.normalized.bedgraph
	fi
done

#!/bin/bash
# ==== takes seacr files and converts to bedgraph for visualization, then find intersection with dm6 gtf for gene annotations

seacr_path="/Users/matthewlee/Desktop/Columbia/Sequencing/SEACR/*"
seacr_annotated="/Users/matthewlee/Desktop/Columbia/Sequencing/SEACR_annotated"
chrom_file="/Users/matthewlee/Desktop/Columbia/Sequencing/Drosophila_melanogaster_UCSC_dm6/Drosophila_melanogaster/UCSC/dm6/dm6.chrom.sizes.txt"
gtf="/Users/matthewlee/Desktop/Columbia/Sequencing/Drosophila_melanogaster_UCSC_dm6/Drosophila_melanogaster/UCSC/dm6/dm6.sorted.gtf"
for file in $seacr_path; do
  if [[ -f "$file" ]]; then
    name=$(basename $file)
    name="${name%.*}"
    echo "Processing file: $name"
    output="/Users/matthewlee/Desktop/Columbia/Sequencing/SEACR_bedgraphs/$name.seacr.bedgraph"
    awk '{OFS="\t"; print $1, $2, $3, $4}' $file > $output
    bedtools intersect -a $output -b $gtf -wa -wb > $seacr_annotated/$name.intersect_genes.bed 

#   bedtools genomecov -bg -i $file -g $chrom_file > /Users/matthewlee/Desktop/Columbia/Sequencing/SEACR_bedgraphs/$name.seacr.bedgraph
  fi
done
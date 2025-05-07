import pandas as pd

geneInfoFolder = "/Users/matthewlee/Desktop/Columbia/Sequencing/SEACR_gene_metadata/Gene Info"
protList = ["Gro", "CtBP", "Ubx"]
for prot in protList:
    prot_df1 = pd.read_csv(f"{geneInfoFolder}/{prot}-1-norm.tsv", sep = "\t")
    prot_df1.drop_duplicates
    prot_df2 = pd.read_csv(f"{geneInfoFolder}/{prot}-2-norm.tsv", sep = "\t")
    prot_df2.drop_duplicates
    common_df = pd.merge(prot_df1, prot_df2, how='inner', on='NCBI GeneID')
    common_df.drop_duplicates
    common_df_merged = common_df.iloc[:, 0:11]
    common_df_merged.to_csv(f"{geneInfoFolder}/{prot}_merged_genes.csv")
    print(prot, common_df_merged.shape)
    print(common_df_merged.head(5))

CtBP_df = pd.read_csv(f"{geneInfoFolder}/CtBP_merged_genes.csv")
Gro_df = pd.read_csv(f"{geneInfoFolder}/Gro_merged_genes.csv")
Ubx_df = pd.read_csv(f"{geneInfoFolder}/Ubx_merged_genes.csv")

CtBP_Ubx = pd.merge(CtBP_df, Ubx_df, how='inner', on='NCBI GeneID')
CtBP_Ubx.drop_duplicates
CtBP_Ubx = CtBP_Ubx.iloc[:, 0:11]
CtBP_Ubx.to_csv(f"{geneInfoFolder}/CtBP_Ubx_merged_genes.csv")
print(CtBP_Ubx.head(5), CtBP_Ubx.shape)

Gro_Ubx = pd.merge(Gro_df, Ubx_df, how='inner', on='NCBI GeneID')
Gro_Ubx.drop_duplicates
Gro_Ubx = Gro_Ubx.iloc[:, 0:11]
print(Gro_Ubx.head(5), Gro_Ubx.shape)
Gro_Ubx.to_csv(f"{geneInfoFolder}/Gro_Ubx_merged_genes.csv")

Gro_CtBP = pd.merge(Gro_df, CtBP_df, how='inner', on='NCBI GeneID')
Gro_CtBP.drop_duplicates
Gro_CtBP = Gro_CtBP.iloc[:, 0:11]
print(Gro_CtBP.head(5), Gro_CtBP.shape)
Gro_CtBP.to_csv(f"{geneInfoFolder}/Gro_CtBP_merged_genes.csv")


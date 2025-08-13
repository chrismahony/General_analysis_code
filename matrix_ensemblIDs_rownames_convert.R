library(gsfisher)

# Get annotation file, 'mm' for mouse, 'hs' for human
annotation_gs <- fetchAnnotation(species="mm", ensembl_version=NULL, ensembl_host=NULL)


# Suppose your matrix is called 'mat' and currently has Ensembl IDs as rownames
ensembl_ids <- rownames(mat)

# Match each Ensembl ID to its gene name
idx <- match(ensembl_ids, annotation_gs$ensembl_id)

# Replace rownames with gene names (keeping original if no match)
rownames(mat) <- ifelse(
  is.na(idx),
  ensembl_ids,  
  annotation_gs$gene_name[idx]
)

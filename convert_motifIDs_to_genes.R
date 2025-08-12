Idents(atac_motifs) <- 'fibrocombined_condition'

DefaultAssay(atac_motifs) <- 'chromvar'

marker_motifs <- FindAllMarkers(atac_motifs,  only.pos = TRUE,
  mean.fxn = rowMeans,
  fc.name = "avg_diff")

index <- match(rownames(marker_motifs), jaspar2$ID)
marker_motifs$gene <- jaspar2$gene[index]

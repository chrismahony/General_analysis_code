library(Seurat)
library(ggplot2)
library(dplyr)
library(splitstackshape)
library(Archr) #not essential, can be removed if not installed, just for formating ggplot at end

obj$condition_sample_cluster <- paste(obj$condition, obj$sample_id, obj$cluster  sep="_")

Idents(obj) <- 'condition_sample_cluster'

dotplot <- DotPlot(obj, features = "Cxcl12")
dotplot <- dotplot$data

dotplot <- cSplit(dotplot, splitCols = "id", sep="_")
  
dotplot <- dotplot %>% filter(id_1 %in% c("condition1", "condition2")) %>% filter(cluster == "MF")


desired_order <- c("condition1", "condition2")
dotplot$id_1 <- factor(dotplot$id_1, levels = desired_order)

ggplot(dotplot) +
  geom_boxplot(aes(x = id_1, y = avg.exp, fill=id_1))+
      geom_jitter(data=dotplot, mapping=aes(x = id_1, y = avg.exp.scaled), width = 0.1, size = 1.8, shape = 21,  fill = "black", color = "black") +theme_ArchR()+RotatedAxis()

t_test_result <- t.test(avg.exp.scaled ~ id_1, data = dotplot)
t_test_result
  

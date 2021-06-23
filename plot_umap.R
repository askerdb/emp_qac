source("load_data.R")
umap = read.csv("bigdata/emp_umap_embedding.csv")
umapfmeta = merge(umap, fmeta, by.x = "ID", by.y = "X.featureID")
umapfmeta$QAC = grepl("N\\+", fmeta$GNPS_LIBA_Consol_SMILES)
umapfmeta$CAN_npc_pathway = as.character(umapfmeta$CAN_npc_pathway)
umapfmeta$CAN_npc_pathway[umapfmeta$CAN_npc_pathway == "" | is.na(umapfmeta$CAN_npc_pathway)] = "Unclassified"
ggplot(subset(umapfmeta, QAC == FALSE)) +
  geom_point(aes(x = UMAP1, y = UMAP2, color = CAN_npc_pathway)) +
  geom_point(data = subset(umapfmeta, QAC == TRUE), aes(x = UMAP1, y = UMAP2), 
             color = "red", inherit.aes = F)+
    theme_bw() +
   labs(color='CANOPUS pathway') + 
  scale_colour_brewer(palette = "BrBG")

  
qac_ms2 = read.table("qac_ms2.txt", header = T)
ggplot(qac_ms2, aes(x = as.factor(Scan), y = Mz, color = Intensity)) + 
  geom_point() + theme_bw() +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) + 
  coord_flip() 


ggplot(subset(qac_ms2, Mz < 100) , aes(x = as.factor(Scan), y = Mz, color = Intensity)) + 
  geom_point() + theme_bw() +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) + 
  coord_flip() 

qac_ms2_perc = as.data.frame(sort(round(table(round(qac_ms2$Mz, 1))/223*100, 3)))
colnames(qac_ms2_perc) = c("Appr. m/z", "Percent")
library(ztable); options(ztable.type="viewer")

ztable(tail(qac_ms2_perc, 10),include.rownames = F)
library(reshape2)
library(pheatmap)
qac_ms2$Mzbin = round(qac_ms2$Mz, 1)
qac_ms2$Presence = as.numeric(qac_ms2$Intensity > 0)
qac_ms2agg = dcast(qac_ms2, Mzbin ~ Scan, value.var = "Presence", fun.aggregate = mean)
qac_ms2agg[is.na(qac_ms2agg)] = 0
row.names(qac_ms2agg) = qac_ms2agg$Mzbin; qac_ms2agg$Mzbin = NULL
pheatmap(qac_ms2agg, cluster_rows = F, labels_col = NULL)

fmetaf = fmeta_qac[,c("GNPS_LIB_Compound_Name", "GNPS_LIB_Smiles", "GNPS_parent.mass")]
View(fmetaf[order(fmetaf$GNPS_parent.mass),])

write.table(fmetaf, file = "fmeta_qac_SMILES.csv")


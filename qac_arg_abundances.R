library(reshape2); library(plyr); library(cowplot); library(ggplot2)
counts = read.table("data/emp_qac.csv", sep = ',', header = T, row.names = 1)
counts$Gene = row.names(counts)
countsm = melt(counts)
countsm$Gene = sub("\\.faa", "", countsm$Gene)
countsm$variable = sub("_diamond_hits.txt", "", countsm$variable)
smeta = read.table("data/emp500_metadata_basic.txt", sep = "\t", header =T, comment.char = "", quote = "", stringsAsFactors = FALSE)
smeta = subset(smeta, read_count_shotgun_r1 != "not applicable")
smeta$read_count_shotgun_r1 = as.numeric(smeta$read_count_shotgun_r1)
#smeta$metaID = sub("tis", "", gsub("\\.", "_", sub("[0-9]\\.", "", smeta$sample_name_plus_plate)))
smeta$metaID = gsub("\\.", "_",smeta$sample_name_original)
hitsdf = merge(countsm, smeta, by.x = "variable", by.y = "metaID", all.x = T, sort = F )                   
hitsdf = subset(hitsdf, empo_1 != "Control")

#Add feature metadata
bacmeta = read.table("data/BacMet2_PRE.155512.mapping.txt", sep = "\t", header = T,nrow = 0, fill = T)
hitsdffeat = merge(hitsdf, bacmeta, by.x = "Gene", by.y = "Gene_name", all.x = T, sort = F)
hitsdffeat$QAC = ifelse(grepl("QAC", hitsdffeat$Compound), "QAC", "Not QAC") 

ggplot(subset(hitsdffeat, empo_1 != "Control"), aes(x = log10(value/as.numeric(read_count_shotgun_r1)), y = emp500_title)) + geom_boxplot() +
  facet_grid(QAC~empo_1, scales = "free") + coord_flip()

ggplot(hitsdf, aes(x = log10(value/as.numeric(read_count_shotgun_r1)), y = as.numeric(hitsdf$alpha_shotgun_woltka_min10k_richness))) + geom_point()

       
library(reshape2); library(plyr); library(cowplot): library(plyr)
files = Sys.glob("data/annotations_scaffolds_bacmet2_predicted_db/*")

fileslist = lapply(files, function(x) read.table(x, sep = "\t"))
fileslistdf = lapply(1:length(fileslist), function(x) {
  data.frame(fileslist[x], File = files[x]) } ) 
filesdf = do.call(rbind, fileslistdf)

filesdf$Env = sub("_diamond_bacmet_predicted_hits.txt", "", sub("data/annotations_scaffolds_bacmet2_predicted_db/", "", filesdf$File))
filesdf$BacMet_ID = sapply(filesdf$V2, function(x) strsplit(x, "\\|")[[1]][2] )
filesdf$Contig = unname(sapply(filesdf$V1, function(x) strsplit(x, "_[0-9]+$")[[1]][1]))
bacmeta = read.table("data/BacMet2_PRE.155512.mapping.txt", sep = "\t", header = T,nrow = 0, fill = T)
filesdfmeta = merge(filesdf, bacmeta, by.x = "BacMet_ID", by.y = "GI_number", all.x = T )
filesdfmeta$QAC = ifelse(grepl("QAC", filesdfmeta$Compound), "QAC", "Not QAC") 

filesarg = Sys.glob("bigdata/CARD/*ARGs.txt")
filesarglist = lapply(filesarg, function(x) read.table(x, sep = "\t", comment.char = "", header = T, quote = ""))
filesarglistdf = lapply(1:length(filesarglist), function(x) {
  print(filesarg[x])
  data.frame(filesarglist[x], File = filesarg[x]) } ) 
filesargdf = do.call(rbind, filesarglistdf)
filesargdf$Contig = unname(sapply(filesargdf$ORF_ID, function(x) strsplit(x, "_[0-9]* #")[[1]][1]))


bothcontigs = intersect(filesdf$Contig, filesargdf$Contig)

bothcontigsdf = merge(subset(filesdfmeta, Contig %in% bothcontigs & QAC == "QAC"),
                      subset(filesargdf, Contig %in% bothcontigs), by = "Contig")
head(bothcontigsdf[,c("Gene_name", "Env", "Best_Hit_ARO")])
bothcontigsdf$Pair = paste(bothcontigsdf$Gene_name, bothcontigsdf$Best_Hit_ARO)
ggpairsenv = ddply(bothcontigsdf, .(Env, Cut_Off), summarise, Sum = length(Env))
ggplot(ggpairsenv, aes(y = Sum, x = Env)) + geom_bar(stat = "identity")+
  facet_grid(Cut_Off ~ ., scales = "free_y") + theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) 
 

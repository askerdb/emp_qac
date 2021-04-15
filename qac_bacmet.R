library(reshape2); library(plyr); library(cowplot)
files = Sys.glob("data/annotations_scaffolds_bacmet2_predicted_db/*")

fileslist = lapply(files, function(x) read.table(x, sep = "\t"))
fileslistdf = lapply(1:length(fileslist), function(x) data.frame(fileslist[x], File = files[x]) )
filesdf = do.call(rbind, fileslistdf)

filesdf$Env = sub("_diamond_bacmet_predicted_hits.txt", "", sub("data/annotations_scaffolds_bacmet2_predicted_db/", "", filesdf$File))
filesdf$BacMet_ID = sapply(filesdf$V2, function(x) strsplit(x, "\\|")[[1]][2] )

bacmeta = read.table("data/BacMet2_PRE.155512.mapping.txt", sep = "\t", header = T,nrow = 0, fill = T)
filesdfmeta = merge(filesdf, bacmeta, by.x = "BacMet_ID", by.y = "GI_number", all.x = T )
filesdfmeta$QAC = ifelse(grepl("QAC", filesdfmeta$Compound), "QAC", "Not QAC") 

asmmeta = read.table("data/emp500_metadata_shotgun_assembly_scaffolds.txt", sep = "\t", quote = "", header = T)

filesdfmetaer = merge(filesdfmeta, asmmeta, by.x = "Env", by.y = "sample_name", all.x = T)

rawp = ggplot(filesdfmeta, aes(Env )) + geom_bar() + facet_grid(QAC~., scales=  "free_y") +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1), text = element_text(size=20))

filesdfmetaeragg = ddply(filesdfmetaer, .(Env, QAC, total_reads, empo_2), summarize, Count = length(Compound))
normp =  ggplot(filesdfmetaeragg, aes(x = Env, y = Count/total_reads, fill = empo_2)) + geom_bar(stat="identity") + 
  facet_grid(QAC~., scales=  "free_y")+
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1),text = element_text(size=20))

plot_grid(rawp, normp, labels = c("Raw", "Normalized"))

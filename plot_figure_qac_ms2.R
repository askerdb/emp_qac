qac_ms2 = read.table("qac_ms2.txt", header = T)
ggplot(subset(qac_ms2, Mz < 100) , aes(x = as.factor(Scan), y = Mz, color = Intensity)) + 
  geom_point() + theme_bw() +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) + 
  coord_flip() 

qac_ms2 = read.table("qac_ms2.txt", header = T)
qac_ms2_perc = as.data.frame(sort(round(table(round(qac_ms2$Mz, 1))/223*100, 3)))
colnames(qac_ms2_perc) = c("Appr. m/z", "Percent")
write.csv(qac_ms2_perc, file = "Table_s1_fragments.csv")

fmeta = read.table("data/FBMN_metabo_feature_metadata_filtered_consolidated_is_microbial.tsv",
                   header = T, sep = "\t", quote = "", comment.char = "")

fmeta_qac = subset(fmeta,grepl("N\\+", fmeta$GNPS_LIB_Consol_SMILES))
nrow(fmeta_qac)

fmeta_qac_a = subset(fmeta,grepl("N\\+", fmeta$GNPS_LIBA_Consol_SMILES))
nrow(fmeta_qac_a)

write.table(fmeta_qac, file = "fmeta_qac.csv")

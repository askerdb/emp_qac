library(ggplot2)
#Load feature metadata
fmeta = read.table("bigdata/FBMN_metabo_feature_metadata_filtered_consolidated_is_microbial.tsv",
                   header = T, sep = "\t", quote = "", comment.char = "")
fmeta_qac = subset(fmeta,grepl("N\\+", fmeta$GNPS_LIB_Consol_SMILES))
fmeta_qaca = subset(fmeta,grepl("N\\+", fmeta$GNPS_LIBA_Consol_SMILES))


#Load abundances
abund = read.table("bigdata/1907_EMPv2_INN_GNPS_quant.csv", sep = ",", header = T)

abund_qac_meta = merge(abund, fmeta_qac, by.x = 0, by.y = "X.featureID", sort = F)
abund_qac = abund_qac_meta[, 12:ncol(abund)]
row.names(abund_qac) = abund_qac_meta$Row.names

abund_qaca_meta = merge(abund, fmeta_qaca, by.x = 0, by.y = "X.featureID", sort = F)
abund_qaca = abund_qaca_meta[, 12:ncol(abund)]
row.names(abund_qaca) = abund_qaca_meta$Row.names

#Load sample metadata and match it
colnames(abund_qac) = sub("X", "", gsub("\\.", "_", sub(".mzML.cropped.Peak.area","", colnames(abund_qac))))
smeta = read.table("bigdata/qiime2_metadata.tsv", sep = "\t", header =T, comment.char = "", quote = "", stringsAsFactors = FALSE)
smeta$new_filename = gsub("\\.", "_", sub(".mzML", "", gsub("-", "_", smeta$metabo_v2_filename_2019)))
abund_qac_joint = merge(t(abund_qac), smeta, by.x = 0, by.y = "new_filename")
abund_qac = t(abund_qac_joint[, 2:223])
colnames(abund_qac) = abund_qac_joint$Row.names
abund_qac01 = abund_qac
abund_qac01[abund_qac01 > 0] = 1

colnames(abund_qaca) = sub("X", "", gsub("\\.", "_", sub(".mzML.cropped.Peak.area","", colnames(abund_qaca))))
smeta$new_filename = gsub("\\.", "_", sub(".mzML", "", gsub("-", "_", smeta$metabo_v2_filename_2019)))
abund_qaca_joint = merge(t(abund_qaca), smeta, by.x = 0, by.y = "new_filename")
abund_qaca = t(abund_qaca_joint[, 2:223])
colnames(abund_qaca) = abund_qaca_joint$Row.names

#Load metagenomic genus assignments
library(biomformat)
mgbiom = read_hdf5_biom("bigdata/117180_genus.biom")
mg_genus = data.frame(mgbiom$data)
colnames(mg_genus) = sapply(mgbiom$rows, function(x) x$id)
row.names(mg_genus) = sub("13114\\.", "", sapply(mgbiom$columns, function(x) x$id))

#Extracted from emp500_lcms_fbmn_biom_noControls_controlFiltered.qza
fabund = read_hdf5_biom("bigdata/feature-table.biom")
lcms = data.frame(fabund$data)
colnames(lcms) = sapply(fabund$rows, function(x) x$id)
row.names(lcms) = sub("13114\\.", "", sapply(fabund$columns, function(x) x$id))




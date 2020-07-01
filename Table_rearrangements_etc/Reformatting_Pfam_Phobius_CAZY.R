require(data.table)
require(stringr)

#Importing the two column table generated from the InterPro output
Pfam <- read.csv("Final_bins_Pfam_annotations.tsv", sep="\t", header=F, quote="")
colnames(Pfam) <- c("Geneid", "Pfam")

#concatenating multiple Pfam domains for the same protein into one row
Pfam_table <- data.table(Pfam)[, list(Pfam=str_c(Pfam, collapse=" | ")), by = Geneid]
write.table(Pfam_table, "Final_bins_Pfam_annotation_reformat2.tsv", sep="\t", row.names=F, quote=F)

#The same thing for Phobius
Phobius <- read.csv("Final_bins_Phobius_annotations.tsv", sep="\t", header=F, quote="")
colnames(Phobius) <- c("Geneid", "Phobius")

#concatenating multiple Phobius domains for the same protein into one row
Phobius_table <- data.table(Phobius)[, list(Phobius=str_c(Phobius, collapse=" | ")), by = Geneid]
write.table(Phobius_table, "Final_bins_Phobius_annotation_reformat2.tsv", sep="\t", row.names=F, quote=F)

CAZY <- read.csv("Final_bins_hmm_CAZY.tsv", sep="\t", header=T, quote="")[,c(1,2)]
colnames(CAZY) <- c("Geneid", "CAZY_hmm")

#concatenating multiple CAZY domains for the same protein into one row
CAZY_table <- data.table(CAZY)[, list(CAZY_hmm=str_c(CAZY_hmm, collapse=" | ")), by = Geneid]
write.table(CAZY_table, "Final_bins_hmm_CAZY_reformat.tsv", sep="\t", row.names=F, quote=F)

require(data.table)
require(dplyr)
require(reshape2)
require(stringr)

#loading the Emapper annotations. The table has been previously reduced to just three columns
EGGNOGS <- data.table(read.csv("Final_bins_EggNOGs.tsv", 
                               sep="\t", 
                               header=T, 
                               na=""))
colnames(EGGNOGS) <- c("Geneid", "EggNOG")

EGGNOGS <- na.omit(EGGNOGS, cols="EggNOG")

#Table of gene to bin attribution
Gene_to_bin <- read.csv("Final_bins_genes_in_bins.tsv", 
                        sep="\t", 
                        header=T)
colnames(Gene_to_bin) <- c("Geneid", "Bin")

#TAdding the bin attribution to the EggNOG table
EGGNOGS <- merge(EGGNOGS, 
                 Gene_to_bin, 
                 by="Geneid",
                 all.x=T)[,c(3,1,2)]

#The EggNOG functions file can be downloaded from the EggNOG webpage
EGGNOG_functions <- read.csv("EggNOG_annotations.tsv", 
                             sep="\t", 
                             header=F, 
                             na="NA")
colnames(EGGNOG_functions) <- c("EggNOG", "EggNOG_function")
EGGNOG_functions <- na.omit(EGGNOG_functions, cols="EggNOG_function")

#Counting EggNOGs per Bin and generating the matrix
EGGNOGS_in_bin <- na.omit(cube(data.table(EGGNOGS), 
                               lapply(.SD, length), 
                               by=c("Bin","EggNOG"), 
                               .SDcol=2), 
                          cols="Bin")

EGGNOG_per_bin <- dcast(EGGNOGS_in_bin, 
                        EggNOG ~ Bin, 
                        sum)

#Adding the Function column and writing output. Later the table can be further summarized by "Function" rather than EggNOG id.                   
EGGNOG_per_bin <- merge(EGGNOG_per_bin, 
                        EGGNOG_functions, 
                        all.x=T, 
                        by="EggNOG")[,c(1,98,2:97)]
#Write the table. !!! If you want to summarize eggNOGs by function later, don't forget to paste EggNOG ids into the function field for those without functional assignment. Otherwise they all will be summed up under function"NA".
write.table(EGGNOG_per_bin, 
            file="Final_bins_EggNOG_per_bin.tsv", 
            sep="\t", 
            row.names=F, 
            quote=F)

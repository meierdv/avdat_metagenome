require(dada2)
setwd("/tmp/dmeier/DADA2/")

path <- "./"
Readfiles <- sort(list.files(path, 
                             pattern=".fastq.gz"))

#estimating error-rates
#a warning about varying sequence length appears 
#since the script was designed to handle unmerged Illumina reads. But it's OK.

Errorprofile <- learnErrors(Readfiles, 
                            multithread=TRUE, 
                            qualityType="FastqQuality")

#plotErrors(Errorprofile, nominalQ=TRUE)

#dereplicating sequences
DerepReads <- derepFastq(Readfiles, 
                         verbose=TRUE)

#assigning sample names
names(DerepReads) <- sort(list.files(path, 
                                     pattern=".fastq.gz"))

#da-da-da
DADA_ASVs <- dada(DerepReads, err=Errorprofile, 
                  multithread=TRUE)

#generate sequence by OTU table
seqtab <- makeSequenceTable(DADA_ASVs)

#remove chimeras
seqtab.nochim <- removeBimeraDenovo(seqtab, 
                                    method="consensus",
                                    multithread=TRUE,
                                    verbose=TRUE)

ASV_table <- t(seqtab.nochim)

#paste the sequence as a column
ASV_table <- cbind(ASV_sequence=rownames(ASV_table), 
                   ASV_table)

#generate a column with an ASV name made up from the row number and containing the size of the ASV aka sum of all counts across rows (uses only numerical columns)
ASV_table <- cbind(ASV=paste("ASV_", 
                             1:nrow(ASV_table),
                             ";size=",
                             rowSums(ASV_table[sapply(ASV_table, is.numeric)], na.rm=T),
                             sep=""), 
                   ASV_table)

write.table(ASV_table, 
            file="ASV_table_nochim.tsv", 
            sep="\t", 
            row.names=F, 
            quote=F)

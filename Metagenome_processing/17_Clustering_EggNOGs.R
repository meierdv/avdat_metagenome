require(data.table)
pastrequire(dplyr)
require(stringr)
require(vegan)

#---------------------------------------------------------------------------------------------------------
# Clustering EggNOG functions
#---------------------------------------------------------------------------------------------------------

#Importing the EggNOG per bin table
EggNOGs_per_bin <- read.csv("Final_bins_EggNOG_per_bin.tsv", 
                            sep="\t", 
                            header=T, 
                            row.names=1, 
                            check.names = F)


#Adding up the counts of different eggNOGs with the same function assignment
EggNOG_functions_per_bin <- na.omit(cube(data.table(EggNOGs_per_bin), 
                                         lapply(.SD, sum), 
                                         by="EggNOG_function", 
                                         .SDcol=c(2:97)), 
                                    cols="EggNOG_function")

#Writing this new table, just to have it in case
write.table(EggNOG_functions_per_bin, 
            file="Final_bins_EggNOG_function_per_bin.csv", 
            quote=F, 
            sep="\t", 
            row.names=F)

#Remove EggNOGs which appear only in one Bin. These rows will have a sum of 1 when table transformed to presence-absence
EggNOG_functions_per_bin <- decostand(EggNOG_functions_per_bin[,c(2:97)], 
                                     method="pa")
EggNOG_functions_per_bin <- EggNOG_functions_per_bin[rowSums(EggNOG_functions_per_bin != 0) > 1, ]

#The counts are transformed into presence-absence, since we are not considering redundancy of functions but only looking at if an organism can or cannot perform certain metabolism
#Bray-Curtis dissimilarity is calculated

EggNOG_dist <- vegdist(t(EggNOG_functions_per_bin), 
                       dist="bray")

Egg_NOG_cluster <- hclust(EggNOG_dist, 
                          method="average")
plot(Egg_NOG_cluster, hang=-1)


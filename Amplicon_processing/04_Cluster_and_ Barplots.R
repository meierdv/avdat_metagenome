require(vegan)
require(ggplot2)
require(colorspace)
require(reshape2)


#-----------------------------------------------------------------------------------------------------
#Clustering
#-----------------------------------------------------------------------------------------------------

# 1) clustering by SWARM OTUs

com_data <- read.table("Sample_by_SWARM.tsv", header=T, sep="\t", row.names=1)

com_data_T <- t(com_data)

com_dist <- vegdist(com_data_T, method="bray") # calculating a distance matrix with Bray-Curtis simillarity index
OTU_cluster <- hclust(com_dist, method="average")

{pdf("OTU_cluster.pdf")

plot(OTU_cluster, hang="-1", main="Cluster-analysis of microbial communities", xlab="Sampling sites", ylab="Dissimilarity")

dev.off()}

write.table(OTU_cluster$order, file="OTU_cluster_order.txt", sep="\t", quote=F)  # use to reorder the table for the bar charts


#------------------------------------------------------------------------------------------------------
#Bar Charts
#------------------------------------------------------------------------------------------------------

#This is a table with taxonomic categories to be plotted. These were summarized manually to reflect abundant groups at the highest taxonomic resolution possible and summarize many very low abundant taxa under "other"
mydata <- read.csv("Avdat_Genera_plot.csv", sep="\t", header=T) 

bar_frame <- mydata[c(1:30), c(2:33)]

bar_melt <- melt(bar_frame, id="order")
colnames(bar_melt) <- c("Sample", "Taxon", "Rel_abundance" )

#This is a file with hexdecimal codes of custom colors selected for taxonomic groups to plot. 
#The colors were given manually in the table with the categories to plot. The column with the color values were saved separately.

bar_colours <- scan("Avdat_Genera_color.csv", what="")

bar_colScale <- scale_fill_manual(name="Taxon", values=bar_colours)

ggplot(bar_melt, aes(x=Sample, 
                     y=Rel_abundance, 
                     fill=Taxon, 
                     order=as.numeric(Taxon)))+ 
geom_bar(stat="identity", 
         position="stack", 
         width=0.7) +
xlab("Samples") + 
ylab("Relative abundance") +
bar_colScale+
guides(fill=T)

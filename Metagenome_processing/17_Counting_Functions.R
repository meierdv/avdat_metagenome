setwd("/home/dmeier/Documents/DOME/Avdat_metagenomes/Re_assembly/Functions/")

require(data.table)

#-----------------------------------------------------------------------------------------------------------
#Counting number of differently annotated genes per bin in a category (e.g. different subunits of an enzyme)
#-----------------------------------------------------------------------------------------------------------

for(x in scan("Functions_list.txt", what="character")) {

#Importing the feature Counts
  Funcfile <- file.path(paste(x, ".csv", sep=""))
  
  Functable <- read.csv(Funcfile, 
                                   sep="\t", 
                                   header=T, 
                                   quote="")[,c(1,4)]

  colnames(Functable) <- c("Bin","Annotation")

  Funccountfile <- file.path(paste("./counts/", x, ".tsv", sep=""))

  Funccounttable <- data.table(Functable)[, .(different_function_count = uniqueN(Annotation)), by=Bin]
  colnames(Funccounttable) <- c("Bin", paste(x))
  write.table(Funccounttable,
            file=Funccountfile,
            sep="\t",
            row.names=F,
            quote=F)
}

#Importing the separate tables with function counts per bin

for(x in scan("Functions_list.txt", what="character")) {
  
  assign(paste(x), read.csv(paste("./counts/", x, ".tsv", sep=""), 
                            sep="\t", 
                            header=T, 
                            quote=""))
  
  mydata <- get(x)
  
  assign(x, mydata)
  rm(mydata)
}

rm(x)

#Merge all the tables based on the Bin column as id

Funcsummary <- Reduce(function(x, y) 
  merge(x, 
        y, 
        by.x="Bin", 
        all=T), 
  mget(ls()))

write.table(Funcsummary, 
            file="Avdat_selected_functions_summary.tsv", 
            sep="\t", 
            row.names=F, 
            quote=F, 
            na="0")

#Large tables can be reformated easily with basic unix commands: columns rearranged, patterns searched and replaced etc. to fit the input formats required by certain tools.
#Example: extracting only the global EggNOG id assignment from the Emapper output table.
#The EggNOG ids can be found in column 19. The columns are separated by tabs (default). The global EggNOG ids are marked with "@1" 

#firts taking out the query id column, #1

cut -f 1 MAGS_NEW_Emapper_diamond.tsv > Query_id.column

#taking out the EggNOG id column and removing everything that is not marked with @1 by a series of sed search and replace operations

cut -f 19 MAGS_NEW_Emapper_diamond.tsv | sed 's/\@1$//g' | sed 's/\@1\,.*//g' | sed 's/.*\,//g' > EggNOG_id.column

#putting the two columns together again

paste Query_id.column EggNOG_id.column > My_EggNOGGs.tsv

#removing the temporary files
rm *.column

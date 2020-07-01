#!/bin/bash
#SBATCH --job-name=Anvio_gen_database
#SBATCH --cpus-per-task=32
#SBATCH --mem=512G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=Anvio_gen_database.out
#SBATCH --error=Anvio_gen_database.err
#SBATCH --nice=1000
#SBATCH --partition=himem

module load anvio

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

mkdir $TMPDIR/Single_Profiles

for CLADE in (ls $DATA_FOLDER/Re_assembly/refs/*.fasta | xargs -n 1 basename | sed 's/\.fasta//g');

do

#copy database and single samples profiles to temporary directory for faster processing
    scp $DATA_FOLDER/Re_assembly/Anvio/"$CLADE".db $TMPDIR/

    scp -r $DATA_FOLDER/Re_assembly/Anvio/"$CLADE"_*_PROFILE $TMPDIR/Single_Profiles/
    scp -r $DATA_FOLDER/Re_assembly/Anvio/"$CLADE"_taxonomy_for_Anvio.tsv $TMPDIR/

#The table of taxonomy of the best diamond blastp hit for each gene exported from the diamond results file and formated to have the number of columns and headers required by Anvi'o can be imported into the database here

    anvi-import-taxonomy-for-genes \
        -c $TMPDIR/"$CLADE".db \
        -p default_matrix \
        -i $TMPDIR/"$CLADE"_taxonomy_for_Anvio.tsv

#Based on the taxonomy of the encoded genes, Anvi'o assignes taxonomy to splits (which in our case equal contigs snce we did not split them up). In this step the taxonomy of contigs is exported as a table.
    anvi-export-splits-taxonomy \
        -c $TMPDIR/"$CLADE".db \
        -o $TMPDIR/"$CLADE"_Anvio_contig_taxonomy.tsv

        scp $TMPDIR/"$CLADE"_Anvio_contig_taxonomy.tsv $DATA_FOLDER/Re_assembly/Anvio/

#Merge the single profiles into one profile database. No binning required here as we have done this already
    anvi-merge \
        -c $TMPDIR/"$CLADE".db \
        --skip-concoct-binning \
        --skip-hierarchical-clustering \
        -S "$CLADE" \
        -o $TMPDIR/"$CLADE"_PROFILE \
        $TMPDIR/Single_Profiles/"$CLADE"_*_PROFILE/PROFILE.db

#Import the assignment of contigs to bins made by DASTool into the Anvio profile database
    anvi-import-collection \
        -c $TMPDIR/"$CLADE".db \
        -p "$CLADE"_Anvio/"$CLADE"_PROFILE/PROFILE.db \
        -C DAS_Tool \
        --contigs-mode $DATA_FOLDER/Re_assembly/Binning/DAS_Tool/"$CLADE"*_scaffolds2bin.txt
    
    scp $TMPDIR/"$CLADE".db $DATA_FOLDER/Re_assembly/Anvio/
    scp -r $TMPDIR/"$CLADE"_PROFILE $DATA_FOLDER/Re_assembly/Anvio/

    rm -r $TMPDIR/*

done

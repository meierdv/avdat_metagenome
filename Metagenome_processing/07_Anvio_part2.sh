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
module load centrifuge

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with fastq reads being in a subfolder called "reads".
#PROJECTNAME is a prefix which was used for the assembly etc.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"

#copy database and single samples profiles to temporary directory for faster processing
scp $DATA_FOLDER/Anvio/"$PROJECTNAME".db $TMPDIR/

mkdir $TMPDIR/Single_Profiles
scp -r $DATA_FOLDER/Anvio/*_PROFILE $TMPDIR/Single_Profiles/
scp -r $DATA_FOLDER/Anvio/"$PROJECTNAME"_taxonomy_for_Anvio.tsv $TMPDIR/

#The table of taxonomy of the best diamond blastp hit for each gene exported from the diamond results file and formated to have the number of columns and headers required by Anvi'o can be imported into the database here
anvi-import-taxonomy-for-genes \
    -c $TMPDIR/"$PROJECTNAME".db \
    -p default_matrix \
    -i $TMPDIR/"$PROJECTNAME"_taxonomy_for_Anvio.tsv

#Based on the taxonomy of the encoded genes, Anvi'o assignes taxonomy to splits (which in our case equal contigs snce we did not split them up). In this step the taxonomy of contigs is exported as a table.
anvi-export-splits-taxonomy \
    -c $TMPDIR/"$PROJECTNAME".db \
    -o $TMPDIR/"$PROJECTNAME"_Anvio_contig_taxonomy.tsv

scp $TMPDIR/"$PROJECTNAME"_Anvio_contig_taxonomy.tsv $DATA_FOLDER/Anvio/

#Merge the single profiles into one profile database. No binning required here as we have done this already
anvi-merge \
    -c $TMPDIR/"$PROJECTNAME".db \
    --skip-concoct-binning \
    --skip-hierarchical-clustering \
    -S "$PROJECTNAME" \
    -o $TMPDIR/"$PROJECTNAME"_PROFILE \
    $TMPDIR/Single_Profiles/*_PROFILE/PROFILE.db

#Import the assignment of contigs to bins made by DASTool into the Anvio profile database
anvi-import-collection \
    -c $TMPDIR/"$PROJECTNAME".db \
    -p "$PROJECTNAME"_Anvio/"$PROJECTNAME"_PROFILE/PROFILE.db \
    -C DAS_Tool \
    --contigs-mode $DATA_FOLDER/Binning/DAS_Tool/"$PROJECTNAME"*_scaffolds2bin.txt

scp $TMPDIR/"$PROJECTNAME".db $DATA_FOLDER/Anvio/
scp -r $TMPDIR/"$PROJECTNAME"_PROFILE $DATA_FOLDER/Anvio/

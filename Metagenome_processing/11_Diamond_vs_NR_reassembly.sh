#!/bin/bash
#SBATCH --job-name=Diamond_vs_NR
#SBATCH --cpus-per-task=20
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=Diamond_vs_NR.out
#SBATCH --error=Diamond_vs_NR.err
#SBATCH --nice=2000
#SBATCH --partition=basic

module load diamond

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with a subfolder called "Re_assembly"
#PROJECTNAME is a prefix which was used for the assembly etc.
#DIAMOND_DATABASE should be the absolute path to the diamond NCBI-Nr database
DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
DIAMOND_DATABASE=/localmirror/monthly/diamond/nr.dmnd


for CLADE in (ls $DATA_FOLDER/Re_assembly/refs/*.fasta | xargs -n 1 basename | sed 's/\.fasta//g');

do

#copy the amino-acids sequence file exported from the Anvio database to temporary dirtectory for faster processing
    scp $DATA_FOLDER/Re_assembly/Anvio/"$CLADE"_proteins.faa $TMPDIR/

    diamond blastp \
        --tmpdir $TMPDIR \
        -p 20 \
        -q $TMPDIR/"$CLADE"_proteins.faa \
        --db $DIAMOND_DATABASE \
        --daa $TMPDIR/"$CLADE"_diamond.daa \
        --evalue 1E-15 \
        -k 1

#copy the diamond alignment file back to the data folder. Using MEGAN6 and mapping file taxonomy of the hits can be read out from it and saved as a table. Alternatively, if a diamond database with taxonomy information was used, taxonomy can be exported via the "diamond view" command

    scp $TMPDIR/"$CLADE"_diamond.daa $DATA_FOLDER/Re_assembly/Anvio/

done

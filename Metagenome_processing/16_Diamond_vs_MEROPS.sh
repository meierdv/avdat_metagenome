#!/bin/bash
#SBATCH --job-name=Diamond_vs_MEROPS
#SBATCH --cpus-per-task=20
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/Diamond_vs_MEROPS.out
#SBATCH --error=logs/Diamond_vs_MEROPS.err
#SBATCH --nice=2000
#SBATCH --partition=basic

module load diamond

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored.
#PROJECTNAME is a prefix which was used for the assembly etc.
#MEROPS_DATABASE should be the absolute path to the diamond MEROPS database
DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"
MEROPS_DATABASE=/scratch/dmeier/MEROPS_peptidase.dmnd

#copy the amino-acids sequence file exported from the Anvio database to temporary dirtectory for faster processing
scp $DATA_FOLDER/Final_bins/Final_bins.faa $TMPDIR/

diamond blastp \
    --tmpdir $TMPDIR \
    -p 20 \
    -q $TMPDIR/Final_bins.faa \
    --db $MEROPS_DATABASE \
    --daa $TMPDIR/Final_bins_MEROPS_diamond.daa \
    --evalue 1E-5 \
    -k 1

#Generating a tabular Output from the diamond alignment file, specifying the columns for the output at the end.
#The column "salltitles" includes protein function and organism name
diamond view \
    --daa $TMPDIR/Final_bins_MEROPS_diamond.daa \
    --out $TMPDIR/Final_bins_MEROPS_diamond.tsv \
    -f 6 qseqid sseqid salltitles pident evalue

#copy the tabular ouput file back to the data folder.

scp $TMPDIR/Final_bins_MEROPS_diamond.tsv $DATA_FOLDER/Final_bins/

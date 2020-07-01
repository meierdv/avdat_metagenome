#!/bin/bash
#SBATCH --job-name=Anvio_summerize
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/Anvio_summerize.out
#SBATCH --error=logs/Anvio_summerize.err
#SBATCH --nice=1000
#SBATCH --partition=basic

module load anvio

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

#After you've finished inspecting and refining the bins export the final bins

for CLADE in (ls $DATA_FOLDER/Re_assembly/refs/*.fasta | xargs -n 1 basename | sed 's/\.fasta//g');

do

    anvi-summarize
        -c $DATA_FOLDER/Re_assembly/Anvio/"$CLADE".db \
        -p $DATA_FOLDER/Re_assembly/Anvio/"$CLADE"_PROFILE/PROFILE.db \
        -C DAS_Tool \
        --taxonomic-level t_family \
        -O $DATA_FOLDER/Re_assembly/Anvio/"$CLADE"_Refined_Bins

done

#!/bin/bash
#SBATCH --job-name=InterPro
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/InterPro.%a.out
#SBATCH --error=logs/InterPro.%a.err
#SBATCH --nice=1000
#SBATCH --partition=basic
#SBATCH --constraint=fast-localmirror

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

mkdir $DATA_FOLDER/Final_bins/InterPro

/localmirror/monthly/interpro/interproscan-5.27-66.0/interproscan.sh \
    -appl Pfam,TIGRFAM,TMHMM,Phobius\
    -T $TMPDIR \
    -i $DATA_FOLDER/Final_bins/Final_bins.$SLURM_ARRAY_TASK_ID.faa \
    -f tsv \
    -o $DATA_FOLDER/Final_bins/InterPro/Final_bins_InterPro.$SLURM_ARRAY_TASK_ID.csv 


#!/bin/bash
#SBATCH --job-name=HMM_dbCAN
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/HMM_dbCAN.%a.out
#SBATCH --error=logs/HMM_dbCAN.%a.err
#SBATCH --nice=1000
#SBATCH --partition=basic
#SBATCH --constraint=array-1core

module load hmmer

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes/
CAZY_PATH=/scratch/dmeier/dbCAN2/db

scp -r $DATA_FOLDER/Final_bins/Final_bins.$SLURM_ARRAY_TASK_ID.faa $TMPDIR/

scp -r $CAZY_PATH/*.hmm* $TMPDIR/

mkdir $DATA_FOLDER/Final_bins/CAZY

hmmscan \
    --cpu 1 \
    -E 1E-15 \
    --domtblout $TMPDIR/Final_bins_CAZY_domains_hmm.$SLURM_ARRAY_TASK_ID.out \
    --tblout $TMPDIR/Final_bins_CAZY_hmm.$SLURM_ARRAY_TASK_ID.out \
    $TMPDIR/dbCAN-HMMdb-V7.hmm \
    Final_bins.$SLURM_ARRAY_TASK_ID.faa

scp $TMPDIR/Final_bins_CAZY*.out $DATA_FOLDER/Final_bins/CAZY/


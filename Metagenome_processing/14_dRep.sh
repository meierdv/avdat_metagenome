#!/bin/bash
#SBATCH --job-name=dRep
#SBATCH --cpus-per-task=20
#SBATCH --mem=128G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=dRep.out
#SBATCH --error=dRep.err
#SBATCH --nice=1000
#SBATCH --partition=basic

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

mkdir $TMPDIR/All_bins

scp $DATA_FOLDER/Binning/DAS_Tool/*/*.contigs.fa $TMPDIR/All_bins/
scp $DATA_FOLDER/Re_assembly/Binning/DAS_Tool/*/*.fa $TMPDIR/All_bins/

module load drep

#Old and new bins are compared with dRep. Upon inspection of the dRep output tables best bins (more complete, less contaminated and bigger in size) are kept.

dRep cluster \
    $TMPDIR/All_bins_dRep \
    -p 20 \
    --S_algorithm ANIn \
    --genomes $TMPDIR/All_bins/*.fa

scp -r $TMPDIR/All_bins_dRep $DATA_FOLDER/





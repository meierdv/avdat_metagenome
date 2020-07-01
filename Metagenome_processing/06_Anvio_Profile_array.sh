#!/bin/bash
#SBATCH --job-name=Anvi-profile
#SBATCH --cpus-per-task=8
#SBATCH --mem=20G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/Anvi-profile.%a.out
#SBATCH --error=logs/Anvi-profile.%a.err
#SBATCH --nice=1000
#SBATCH --partition=basic
#SBATCH --constraint=array-8core

module load anvio

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with fastq reads being in a subfolder called "reads".
#PROJECTNAME is a prefix which was used for the assembly etc.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"

SAMPLE=$(sed -n ${SLURM_ARRAY_TASK_ID}p $DATA_FOLDER/Sample_list.txt)

scp $DATA_FOLDER/Anvio/"$PROJECTNAME".db $TMPDIR/
scp $DATA_FOLDER/Mapping/"$SAMPLE"_*_sorted.bam* $TMPDIR/

anvi-profile \
            -c $TMPDIR/"$PROJECTNAME".db \
            --skip-hierarchical-clustering \
            -i $TMPDIR/"$SAMPLE"_*_sorted.bam \
            -M 1000 \
            -S "$SAMPLE" \
            -o $TMPDIR/"$SAMPLE"_PROFILE \
            -T 8

scp -r $TMPDIR/"$SAMPLE"_PROFILE $DATA_FOLDER/Anvio/



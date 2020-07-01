#!/bin/bash
#SBATCH --job-name=PhyloFlash
#SBATCH --cpus-per-task=20
#SBATCH --mem=128G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/PhyloFlash.out
#SBATCH --error=logs/PhyloFlash.err
#SBATCH --nice=1000
#SBATCH --partition=basic

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with fastq reads being in a subfolder called "reads".
#PROJECTNAME is a prefix which was used for the assembly etc.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"

module load phyloflash

cd $TMPDIR/

for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt);

do

    scp $DATA_FOLDER/reads/"$SAMPLE"_read*_trim_cor.fastq.gz $TMPDIR/
    
    mkdir $DATA_FOLDER/"$SAMPLE"_PhyloFlash;
     
    phyloFlash.pl \
        -clusterid 98 \
        -taxlevel 7 \
        -read1 $TMPDIR/"$SAMPLE"_read1_trim_cor.fastq.gz \
        -read2 $TMPDIR/"$SAMPLE"_read2_trim_cor.fastq.gz \
        -lib "$SAMPLE"_PhyloFlash \
        -CPUs 20

scp -r $TMPDIR/"$SAMPLE"_PhyloFlash* $DATA_FOLDER/"$SAMPLE"_PhyloFlash/

done


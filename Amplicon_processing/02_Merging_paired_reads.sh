#!/bin/bash
#SBATCH --job-name=Trim_and_correct
#SBATCH --cpus-per-task=32
#SBATCH --mem=1000G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/Trim_and_correct.out
#SBATCH --error=logs/Trim_and_correct.err
#SBATCH --nice=1000
#SBATCH --partition=himem

#Defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with fastq reads being in a subfolder called "reads".

DATA_FOLDER=/scratch/dmeier/Avdat_amplicons

#copy the fasta file with possible adapter sequences to remove and the innitial raw reads to temporary directory for faster processing

scp $DATA_FOLDER/reads/*_read[1,2]_trim_cor.fastq.gz $TMPDIR/

module load bbmap

for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt);

do

    bbmerge.sh \
        in=$TMPDIR/"$SAMPLE"_read1_trim.fastq.gz \
        in2=$TMPDIR/"$SAMPLE"_read2_trim.fastq.gz \
        out=$TMPDIR/"$SAMPLE"_merged.fastq.gz \
        qtrim=l \
        trimq=20 \
        minoverlap=50 \
        strict=T \
        threads=32

done


#copy the merged reads back to data folder.

scp $TMPDIR/"$SAMPLE"_merged.fastq.gz $DATA_FOLDER/reads/

done


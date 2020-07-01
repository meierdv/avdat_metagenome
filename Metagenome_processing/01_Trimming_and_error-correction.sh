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

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

#copy the fasta file with possible adapter sequences to remove and the innitial raw reads to temporary directory for faster processing

scp /scratch/dmeier/Adapters.fasta $TMPDIR/
scp $DATA_FOLDER/reads/*.fastq.gz $TMPDIR/

module load bbmap

#remove the adapters, as well as read ends with quality below 10 and the first 10 basepairs. The reads should be longer than 100 bp after all this.

for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt);

do

    bbduk.sh \
        ref=$TMPDIR/Adapters.fasta \
        in=$TMPDIR/"$SAMPLE".fastq.gz \
        out=$TMPDIR/"$SAMPLE"_read1_trim.fastq.gz \
        out2=$TMPDIR/"$SAMPLE"_read2_trim.fastq.gz \
        ktrim=l \
        qtrim=rl \
        trimq=10 \
        forcetrimleft=11 \
        minlength=100 \
        threads=32

done

module unload bbmap

module load spades

#perform Bayes-Hammmer error-correction of the trimmed reads with SPAdes

for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt);

do

    spades.py \
        --only-error-correction \
        -t 32 \
        -m 1000 \
        -1 $TMPDIR/"$SAMPLE"_read1_trim.fastq.gz \
        -2 $TMPDIR/"$SAMPLE"_read2_trim.fastq.gz \
        -o $TMPDIR/"$SAMPLE"_error_corr

#copy the error-corrected reads back to data folder. At the same time ther file names are cleaned up a bit from what spades generates.

scp $TMPDIR/"$SAMPLE"_error_corr/corrected/"$SAMPLE"_read1*cor.fastq.gz $DATA_FOLDER/reads/"$SAMPLE"_read1_trim_cor.fastq.gz
scp $TMPDIR/"$SAMPLE"_error_corr/corrected/"$SAMPLE"_read2*cor.fastq.gz $DATA_FOLDER/reads/"$SAMPLE"_read2_trim_cor.fastq.gz

done


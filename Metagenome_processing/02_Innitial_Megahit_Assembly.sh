#!/bin/bash
#SBATCH --job-name=Megahit_Assembly
#SBATCH --cpus-per-task=32
#SBATCH --mem=512G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=Megahit_Assembly.out
#SBATCH --error=Megahit_Assembly.err
#SBATCH --nice=1000
#SBATCH --partition=himem

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with fastq reads being in a subfolder called "reads".
#PROJECTNAME is a prefix which will be used for the assembly etc.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"

#copying data to tmp for faster processing
scp $DATA_FOLDER/reads/*_trim_cor.fastq.gz $TMPDIR/

module load bbmap

#normalizing read depth to reduce the number of reads to deal with for the assembler and reduce assembler confusion in cases of highly covered very abundant genomes, where coverage may vary greatly, especially if the population is actively dividing. The target depth is set in k-merdepth with a default k-mer size of 31. For kmer depth Dk, read depth Dr, read length R, and kmer size K: Dr=Dk*(R/(R-K+1)). With an average read length (after trimming) of 137 bp and k-mer depth of 31, the target read depth is approx. 42x. It means that areas with higher coverage will be cut down to 42x.

for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt);

do
    bbnorm.sh \
        threads=32 \
        fixspikes=t \
        target=33 \
        in=$TMPDIR/"$SAMPLE"_read1_trim_cor.fastq.gz \
        in2=$TMPDIR/"$SAMPLE"_read2_trim_cor.fastq.gz \
        out=$TMPDIR/"$SAMPLE"_read1_norm.fastq.gz \
        out2=$TMPDIR/"$SAMPLE"_read2_norm.fastq.gz
 
done

#remove the not normalized reads to free up space
rm *_read*_trim_cor.fastq.gz

zcat $TMPDIR/*_read1_norm.fastq.gz > $TMPDIR/Read1_normalized.fastq
zcat $TMPDIR/*_read2_norm.fastq.gz > $TMPDIR/Read2_normalized.fastq
rm $TMPDIR/*_read*_norm.fastq.gz

module unload bbmap

module load megahit

#Perform MEGAHIT assembly. The highest k-mer is the read length. Small k-mer steps of 10 are supposed to cover the variety of genomes with different degrees of microdiversity. Contigs shorter than 1000 bp are discarded right away.

megahit \
    -m 512000000000 \
    -t 32 \
    --tmp-dir $TMPDIR/megahit \
    --k-min 21 \
    --k-max 137 \
    --k-step 10 \
    --min-contig-len 1000 \
    -1 $TMPDIR/Read1_normalized.fastq
    -2 $TMPDIR/Read2_normalized.fastq
    -o Avdat_Rewetted_coassembly_megahit \
    --out-prefix $TMPDIR/"$PROJECTNAME"_coassembly

scp $TMPDIR/"$PROJECTNAME"_coassembly/"$PROJECTNAME"_coassembly.contigs.fa $DATA_FOLDER/"$PROJECTNAME"_coassembly.fasta


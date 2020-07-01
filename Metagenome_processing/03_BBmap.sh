#!/bin/bash
#SBATCH --job-name=BBmap
#SBATCH --cpus-per-task=20
#SBATCH --mem=128G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/BBmap_all.out
#SBATCH --error=logs/BBmap_all.err
#SBATCH --nice=1000
#SBATCH --partition=basic

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with fastq reads being in a subfolder called "reads".
#PROJECTNAME is a prefix which was used for the assembly etc.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"

#copying data to tmp for faster processing
scp $DATA_FOLDER/reads/*_trim_cor.fastq.gz $TMPDIR/
scp $DATA_FOLDER/"$PROJECTNAME"_coassembly.fasta $TMPDIR/

#creating a directory for output mapping files
mkdir $DATA_FOLDER/Mapping

module load bbmap
module load samtools

#perform the mapping of reads from each sample to the assembly. The innitial settings are set to search for a mapping identity around 97% ("minid"), meaning that reads where the k-mer based similarity is already so low that the identity could not possibly be 97% won't be aligned. This speeds up the mapping. However, it can still happen that although the read innitially looked similar based on k-mers, after alignment the identity is slightly lower. That's why a second parameter "idfilter" is set. After the alignment, reads with identity below 95% will be removed from the mapping files.

#A small script with samtools commands is also generated at output to convert the sam file into a bam file afterwards. Bam is a binary, compressed format and therefore smaller in size.

for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt);

do

    bbmap.sh \
        threads=20 \
        ref=$TMPDIR/"$PROJECTNAME"_coassembly.fasta \
        in=$TMPDIR/"$SAMPLE"_read1_trim_cor.fastq.gz \
        in2=$TMPDIR/"$SAMPLE"_read2_trim_cor.fastq.gz \
        minid=97 \
        idfilter=95 \
        bamscript=$TMPDIR/"$SAMPLE"_to_"$PROJECTNAME"_coassembly.sh \
        outm=$TMPDIR/"$SAMPLE"_to_"$PROJECTNAME"_coassembly.sam

#The sam file is converted into a sorted bam file.

bash "$SAMPLE"_to_"$PROJECTNAME"_coassembly.sh

done

#The bam mapping files are copied back to the data folder
scp *.bam* $DATA_FOLDER/Mapping/


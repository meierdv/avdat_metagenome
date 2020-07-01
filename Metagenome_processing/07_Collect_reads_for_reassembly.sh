#!/bin/bash
#SBATCH --job-name=BBmap_collect
#SBATCH --cpus-per-task=20
#SBATCH --mem=128G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/BBmap_collect.out
#SBATCH --error=logs/BBmap_collect.err
#SBATCH --nice=1000
#SBATCH --partition=basic

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with subfolders "reads" (fastq.gz files), "Mapping" (bam files), "Binning" (DAS_Tool output), "Anvio" (Anvio projects)

#PROJECTNAME is a prefix which was used for the assembly etc.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"

#Create a folder for the reassembly results
mkdir $DATA_FOLDER/Re_assembly

#Create a folder for the reference fasta files used to collect reads for specific clade reassemblies
mkdir $DATA_FOLDER/Re_assembly/refs

#Based on the CheckM tree of innitial bins create lists of related bins. For example, mark the bins of one phylogenetic clade in ARB and export as table ("File -> Expport -> Export fileds (Calc-sheet using NDS)"). Generate such tables for all the clades you wish to reassemble.

for CLADE in $(ls $DATA_FOLDER/*_bin_list.txt | xargs -n 1 basename | sed 's/_bin_list.txt//g');

do 
    for BIN in $(cat $DATA_FOLDER/"$CLADE"_bin_list.txt);
        do 
            cat $DATA_FOLDER/Binning/DAS_Tool/"$BIN".fasta >> $DATA_FOLDER/Re_assembly/refs/$CLADE.fasta
        done
done

#At this stage you could also add additional genomes or contigs to the reference. For example, there were very high coverage contigs (> 400x) that were classified as Rubrobacter but not included in any of the bins. As Rubrobacter genomes were the most abundant once and there were no other genomesclose in abundance in the metagenome, these contigs likely indeed belong to the most abundant Rubrobacter population. Therefore we included them into the mapping reference for Rubrobacter reassembly.
#You could also search for rRNA sequences in these reference files and kick out obviously misplaced rRNA seqeunes (e.g. Cyanobacteria rRNA in an Alphaproteobacteria mapping reference)

#----------------------------------------------------------------------------------------------------------------------------------------------------------

#copying data to tmp for faster processing
scp $DATA_FOLDER/reads/*_trim_cor.fastq.gz $TMPDIR/
scp $DATA_FOLDER/Re_assembly/refs/*.fasta $TMPDIR/

#creating a directory for output mapping files
mkdir $DATA_FOLDER/Re_assembly/Mapping

module load bbmap
module load samtools

#Perform the mapping of reads to the mapping references for each clade. This can be done as an array job or as a loop depening on the available computational resources and number of clades to re-assemble.
#!The read mapping is doen with BBmap default settings, meaning a minid of 70% (!). If judging by ANI thresholds, this would collect reads from species of the same genus.

#This time the output are just the reads that mapped and their pairs in fastq format, since it is done purely for collecting reads and not for alignment information, coverage etc.

for CLADE in $(ls $TMPDIR/*.fasta | xargs -n 1 basename | sed 's/\.fasta//g');

do

    for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt);

    do

        bbmap.sh \
            threads=20 \
            ref=$TMPDIR/"$CLADE".fasta \
            in=$TMPDIR/"$SAMPLE"_read1_trim_cor.fastq.gz \
            in2=$TMPDIR/"$SAMPLE"_read2_trim_cor.fastq.gz \
            outm=$TMPDIR/"$SAMPLE"_to_"$CLADE".fastq.gz
                
    done
#The files with mapped reads are copied back to the data folder
    scp *_to_"$CLADE".fastq.gz $DATA_FOLDER/Re_assembly/Mapping/

done




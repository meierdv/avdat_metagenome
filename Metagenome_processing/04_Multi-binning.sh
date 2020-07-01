#!/bin/bash
#SBATCH --job-name=Multi-binning
#SBATCH --cpus-per-task=32
#SBATCH --mem=512G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=Multi-binning.out
#SBATCH --error=Multi-binning.err
#SBATCH --nice=1000
#SBATCH --partition=himem

module load bbmap
module load metabat
module load samtools
module load maxbin
module load metawatt
module load concoct
module load dastool


#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with fastq reads being in a subfolder called "reads".
#PROJECTNAME is a prefix which was used for the assembly etc.
#METAWATTPATH should be the absolute path to the folder with the Metawatt jar file. METAWATT_DATABASES is the absolute path to the Metawatt databases
#CONCOCTPATH should be the absolute path to the concoct folder containing subfolders "bin" and "scripts"

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"
METAWATTPATH=/apps/metawatt/3.5.3/dist
METAWATT_DATABASES=/scratch/dmeier/Metawatt_database
CONCOCTPATH=/apps/concoct/0.4.1

mkdir $DATA_FOLDER/Binning
mkdir $DATA_FOLDER/Binning/MetaBAT
mkdir $DATA_FOLDER/Binning/MaxBin
mkdir $DATA_FOLDER/Binning/CONCOCT
mkdir $DATA_FOLDER/Binning/Metawatt
mkdir $DATA_FOLDER/Binning/DAS_Tool

#copy the mapping bam files and the corresponding bam.bai index files to temporary directory for faster processing.
#copy the coassembly contigs file to temporary directory

scp $DATA_FOLDER/Mapping/*.bam* $TMPDIR/
scp $DATA_FOLDER/"$PROJECTNAME"_coassembly.fasta $TMPDIR/

#Binning of the metagenomes co-assembly 

#This script is part of the MetaBAT module and reads out the bam files to generate a coverage table (incl. coverage variation) for the contigs
  
    jgi_summarize_bam_contig_depths \
        --outputDepth $TMPDIR/"$PROJECTNAME"_coassembly_coverage_Depths.txt \
        $TMPDIR/*_sorted.bam
        
#run MetaBAT
    metabat2 \
        -i $TMPDIR/"$PROJECTNAME"_coassembly.fasta \
        -a $TMPDIR/"$PROJECTNAME"_coassembly_coverage_Depths.txt \
        -o $TMPDIR/"$PROJECTNAME"_MetaBAT \
        -t 32

#copy the MetaBAT results to the data folder
scp -r $TMPDIR/"$PROJECTNAME"_MetaBAT/* $DATA_FOLDER/Binning/MetaBAT/

#From the coverage table generated by the metabat script earlier generate a coverage table for each sample in format expected by MaxBin

#count the number of samples to figure out how many columns you need to pick from the metabat coverage table. The "4" is added because the first column with coverage is actually column 4.

SAMPLE_COUNT=$(grep -c '^' $DATA_FOLDER/Sample_list.txt)
COLUMN_COUNT=$(($SAMPLE_COUNT+4))

#Start from column 4, pick out every second column (MaxBin doesn't need the coverage variation columns, only the coverage itself) until you got all the samples. Also remove the first line with the headers.

for i in $(seq 4 +2 $COLUMN_COUNT); 
  do
    cut -f 1,"$i" $TMPDIR/"$PROJECTNAME"_coassembly_coverage_Depths.txt | sed '1d' > $TMPDIR/"$PROJECTNAME"_coassembly_abundance_"$i".txt
  done
    ls $TMPDIR/_coassembly_abundance_*.txt > $TMPDIR/"$PROJECTNAME"_coassembly_abundances_list.txt
  
#run MaxBin
    run_MaxBin.pl \
        -contig $TMPDIR/"$PROJECTNAME"_coassembly.fasta \
        -abund_list $TMPDIR/"$PROJECTNAME"_coassembly_abundances_list.txt \
        -out $TMPDIR/"$PROJECTNAME"_MaxBin \
        -thread 32

#copy the MaxBin results to the data folder
scp -r TMPDIR/"$PROJECTNAME"_MaxBin/* $DATA_FOLDER/Binning/MaxBin/

#generate a Metawatt project
mkdir $TMPDIR/"$PROJECTNAME"_Metawatt
mkdir $TMPDIR/"$PROJECTNAME"_Metawatt/input
mkdir $TMPDIR/"$PROJECTNAME"_Metawatt/output
scp -r $METAWATT_DATABASES/databases $TMPDIR/"$PROJECTNAME"_Metawatt/

#Metawatt unfortunately always remaps the reads and there is no way to put in already calculated coverage tables. That's why it takes so long. But it also looks for contigs connected by paired reads mapping.

for READFILE in $(ls *_sorted.bam | sed 's/_sorted.bam//g');
    do
        samtools fastq $TMPDIR/"$READFILE"_sorted.bam $TMPDIR/"$PROJECTNAME"_Metawatt/input/"$READFILE".fastq
    done
scp $TMPDIR/"$PROJECTNAME"_coassembly.fasta $TMPDIR/"$PROJECTNAME"_Metawatt/input/

#metawatt-project.xml is a file with pipeline presets
scp $METAWATT_DATABASES/metawatt-project.xml $TMPDIR/"$PROJECTNAME"_Metawatt/

#run Metawatt
mkdir $TMPDIR/metawatt
java \
    -Xmx512g \
    -jar $METAWATTPATH/MetaWatt-3.5.3.jar \
    --temp-folder $TMPDIR/metawatt \
    --skip-database-update \
    --run $TMPDIR/"$PROJECTNAME"_Metawatt \
    --threads 32

#copy the Metawatt results to the data folder
scp -r TMPDIR/"$PROJECTNAME"_Metawatt/output/* $DATA_FOLDER/Binning/Metawatt/


#generate CONCOCT input covergae table from bamfiles
$CONCOCTPATH/scripts/gen_input_table.py \
    --samplenames <(for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt); do echo $SAMPLE; done) \
    $TMPDIR/Oman_saltmats.fasta \
    $TMPDIR/*_sorted.bam \
    > $TMPDIR/"$PROJECTNAME"_coverage_for_CONCOCT.cov

#run CONCOCT
concoct \
    -r 150 \
    -t 32 \
    --composition_file $TMPDIR/"$PROJECTNAME"_coassembly.fasta \
    --coverage_file $TMPDIR/"$PROJECTNAME"_coverage_for_CONCOCT.cov \
    --no_original_data \
    -b $TMPDIR/"$PROJECTNAME"_CONCOCT

#copy the CONCOCT results to the data folder
scp -r TMPDIR/"$PROJECTNAME"_CONCOCT/* $DATA_FOLDER/Binning/CONCOCT/

#generate DAS_Tool input files
#Attribution of contigs to bins according to MetaBAT
for BIN in $(ls $TMPDIR/"$PROJECTNAME"_MetaBAT/"$PROJECTNAME"_MetaBAT*.fa | xargs -n 1 basename | sed 's/\.fa//g'); 
    do 
        grep '^>' $TMPDIR/"$PROJECTNAME"_MetaBAT/"$BIN".fa | sed "s/$/\t$BIN/g" | sed 's/>//g' \
                >> $TMPDIR/"$PROJECTNAME"_MetaBAT_binning.txt 
    done

#Attribution of contigs to bins according to MaxBin 
for BIN in $(ls $TMPDIR/MaxBin/"$PROJECTNAME"_MaxBin*.fasta | xargs -n 1 basename | sed 's/\.fasta//g'); 
    do 
        grep '^>' $TMPDIR/"$PROJECTNAME"_MaxBin/"$BIN".fasta | sed "s/$/\t$BIN/g" | sed 's/>//g' \
                >> $TMPDIR/"$PROJECTNAME"_MaxBin_binning.txt
    done

#Attribution of contigs to bins according to Metawatt
grep '_bin_' $TMPDIR/"$PROJECTNAME"_Metawatt/output/"$PROJECTNAME"_coassembly.fasta*polished.sibci | sed 's/\t.*.fasta_bin/\tMetawatt/g' | sed 's/\t[0-9][0-9]*//g' \
> $TMPDIR/"$PROJECTNAME"_Metawatt_binning.txt

#Attribution of contigs to bins according to CONCOCT
sed '1d' $TMPDIR/"$PROJECTNAME"_CONCOCT/"$PROJECTNAME"_coassembly_clustering_gt1000.csv | \
perl -0pe "s/\,/\tCONCOCT/g" > $TMPDIR/"$PROJECTNAME"_CONCOCT_binning.txt



#run DAS_Tool to generate consensus bins from the results of different binners

BINNING_FILES=$(ls $TMPDIR/"$PROJECTNAME"*_binning.txt \
          perl -0pe 's/\n/\,/g' | \
          sed 's/\,$//g')

BINNERS=$(ls $TMPDIR/"$PROJECTNAME"*_binning.txt | xargs -n 1 basename \
          sed "s/$PROJECTNAME\_//g" | \
          sed 's/\_binning.txt//g' | \
          perl -0pe 's/\n/\,/g' | \
          sed 's/\,$//g')

DAS_Tool \
    -i "$BINNING_FILES" \
    -l "$BINNERS" \
    -c $TMPDIR/"$PROJECTNAME"_coassembly.fasta \
    -o $DATA_FOLDER/Binning/DAS_Tool/"$PROJECTNAME" \
    --score_threshold 0.2 \
    -t 32 \
    --write_bins


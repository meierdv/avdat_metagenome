#!/bin/bash
#SBATCH --job-name=Re_assembly_SPAdes
#SBATCH --cpus-per-task=32
#SBATCH --mem=512G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=Re_assembly_SPAdes.out
#SBATCH --error=Re_assembly_SPAdes.err
#SBATCH --nice=1000
#SBATCH --partition=himem

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with subfolders "reads" (fastq.gz files), "Mapping" (bam files), "Binning" (DAS_Tool output), "Anvio" (Anvio projects)


DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

#copying data to tmp for faster processing
scp $DATA_FOLDER/Re_assembly/Mapping/*_to_"$CLADE".fastq.gz $TMPDIR/

#Perform read normalization and SPAdes assembly for each clade.
for CLADE in (ls $DATA_FOLDER/Re_assembly/refs/*.fasta | xargs -n 1 basename | sed 's/\.fasta//g');

do

#normalize mapping reads to further reduce the computational effort
    for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt);
        do 
            bbnorm.sh \
                threads=32 \
                fixspikes=t \
                target=33 \
                in=$TMPDIR/"$SAMPLE"_to_"$CLADE".fastq.gz \
                out=$TMPDIR/"$SAMPLE"_to_"$CLADE"_norm.fastq \
        done

#run SPAdes on the collected reads 
    
        cat $TMPDIR/*_to_"$CLADE"_norm.fastq > $TMPDIR/"$CLADE".fastq

        spades.py \
            --only-assembler \
            --meta \
            -t 32 \
            -m 512 \
            -k 21,31,41,51,61,71,81,91,101,111,121,127 \
            --12 $TMPDIR/"$CLADE".fastq \
            -o $TMPDIR/"$CLADE"_SPAdes

    mv $TMPDIR/"$CLADE"_SPAdes/scaffolds.fasta assemblies/"$x"_SPAdes_NORM.fasta

#Filter out scaffolds shorter than 1000 bp    
        reformat.sh \
            in=$TMPDIR/"$CLADE"_SPAdes/scaffolds.fasta \
            minlength=1000 \
            out=$TMPDIR/"$CLADE"_SPAdes_NORM_over1000.fasta

#Copy the clade-specific re-assembly back to data folder
        scp $TMPDIR/"$CLADE"_SPAdes_NORM_over1000.fasta $DATA_FOLDER/Re_assembly/

#Map reads to the new assemblies to obtain differential coverage info. This time again: estimated target identity 97%, absolute cut-off at 95% (~ANI for same species)
#Now only mapping the reads used for assembly, which is much less than the entire sample read set. Also mapping to a smaller reference, clade specific re-assembly. Will need much less computational time.
#Also not, mapping not normalized reads!
  
    for SAMPLE in $(cat $DATA_FOLDER/Sample_list.txt);
        do 
            bbmap.sh \
                threads=32 \
                minid=97 \
                idfilter=95 \
                ref=$TMPDIR/"$CLADE"_SPAdes_NORM_over1000.fasta \
                in=$TMPDIR/"$SAMPLE"_to_"$CLADE".fastq.gz \
                outm=$TMPDIR/"$SAMPLE"_to_"$CLADE"_SPAdes.sam \
                bamscript=$TMPDIR/"$SAMPLE"_to_"$CLADE"_SPAdes_bamscript.sh
                
#Creating a sorted bam file               
            bash $TMPDIR/"$SAMPLE"_to_"$CLADE"_SPAdes_bamscript.sh

#Copying the bam mapping file back to the data directory
            scp $TMPDIR/"$SAMPLE"_to_"$CLADE"_SPAdes_sorted.bam* $DATA_FOLDER/Re_assembly/Mapping/
       done

done




#!/bin/bash
#SBATCH --job-name=Anvi-profile_reassembly
#SBATCH --cpus-per-task=8
#SBATCH --mem=20G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/Anvi-profile_reassembly.%a.out
#SBATCH --error=logs/Anvi-profile_reassembly.%a.err
#SBATCH --nice=1000
#SBATCH --partition=basic
#SBATCH --constraint=array-8core

module load anvio

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored.


DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

CLADE=$(ls $DATA_FOLDER/Re_assembly/refs/*.fasta | xargs -n 1 basename | sed 's/\.fasta//g' | sed -n ${SLURM_ARRAY_TASK_ID}p)

scp $DATA_FOLDER/Re_assembly/Anvio/"$CLADE".db $TMPDIR/
scp $DATA_FOLDER/Re_assembly/Mapping/*_to_"$CLADE"_SPAdes_sorted.bam* $TMPDIR/

for SAMPLE in /cat $DATA_FOLDER/Sample_list.txt);

do
    anvi-profile \
            -c $TMPDIR/"$CLADE".db \
            --skip-hierarchical-clustering \
            -i $TMPDIR/"$SAMPLE"_to_"$CLADE"_SPAdes_sorted.bam \
            -M 1000 \
            -S "$SAMPLE" \
            -o $TMPDIR/"$CLADE"_"$SAMPLE"_PROFILE \
            -T 8

    scp -r $TMPDIR/"$SAMPLE"_PROFILE $DATA_FOLDER/Re_assembly/Anvio/

done

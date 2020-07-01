#!/bin/bash
#SBATCH --job-name=GTDB_and_CheckM
#SBATCH --cpus-per-task=20
#SBATCH --mem=128G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=logs/GTDB_and_CheckM.out
#SBATCH --error=logs/GTDB_and_CheckM.err
#SBATCH --nice=1000
#SBATCH --partition=basic

module load gtdb-tk


DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

mkdir $TMPDIR/Final_bins

scp $DATA_FOLDER/Re_assembly/Anvio/Final_Bins/*.fasta $TMPDIR/Final_bins/

#Run GTDB Toolkit to classify the final bins
gtdbtk classify_wf \
    --cpus 20 \
    -x fasta \
    --out_dir $TMPDIR/Final_bins_GTDB \
    --genome_dir $TMPDIR/Final_bins/

scp -r $TMPDIR/Final_bins_GTDB $DATA_FOLDER/Re_assembly/

#Run checkM to have completeness/contamination statistics on the final bins
checkm lineage_wf \
    -x fasta \
    -t 20 \
    --pplacer_threads 20 \
    --tab_table \
    -f $TMPDIR/CheckM_Out_02/Final_bins_Checkm.csv \
    $TMPDIR/Final_bins/ \
    $TMPDIR/CheckM_Out_02

#Perform SSU search in the final bins. For this CheckM needs one fasta containing all contigs and then a folder with bins to know where these contigs belong to. a bit weird, but that's why we concatenate all Bins into one file.
cat $TMPDIR/Final_bins/*.fasta > $TMPDIR/All_bins.fasta
checkm ssu_finder \
    -x fasta \
    -t 20 \
    $TMPDIR/All_bins.fasta
    $TMPDIR/Final_bins/ \
    $TMPDIR/CheckM_Out_02/SSU_in_Bins 

scp -r $TMPDIR/CheckM_Out_02 $DATA_FOLDER/Re_assembly/


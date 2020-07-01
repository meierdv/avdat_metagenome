#!/bin/bash
#SBATCH --job-name=FastTree_MP
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=FastTree.out
#SBATCH --error=FastTree.err
#SBATCH --nice=1000
#SBATCH --partition=himem

module load fasttree

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

export OMP_NUM_THREADS=32

for CLADE in $(ls $DATA_FOLDER/Re_assembly/Final_bins_GTDB/"$CLADE"_alignment.faa | xargs -n 1 basename | sed 's/_alignment.faa//g');

do
    scp $DATA_FOLDER/Re_assembly/Final_bins_GTDB/"$CLADE"_alignment.faa $TMPDIR/

    FastTreeMP \
        -bionj \
        -gtr \
        -gamma \
        $TMPDIR/"$CLADE"_alignment.faa \
        > $TMPDIR/"$CLADE"_FastTree.tree

    scp $TMPDIR/"$CLADE"_FastTree.tree $DATA_FOLDER/Re_assembly/Final_bins_GTDB/

done


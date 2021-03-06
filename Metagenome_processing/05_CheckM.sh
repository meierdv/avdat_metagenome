#!/bin/bash
#SBATCH --job-name=CheckM
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=CheckM.out
#SBATCH --error=CheckM.err
#SBATCH --nice=1000
#SBATCH --partition=himem

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with fastq reads being in a subfolder called "reads".
#PROJECTNAME is a prefix which was used for the assembly etc.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"

mkdir $TMPDIR/Bins

#copying the fasta files of the bins created by DAS_Tool to temporary directory for faster processing
scp $DATA_FOLDER/Innitial_Bins/*.fasta $TMPDIR/Bins/

module load checkm
#Run checkm. This not only serves the first completeness/contamination estimation, but also for a identification of phylogenetically related bins. During the lineage workflow checkm places the bins into a phylogenomic tree. This tree can be loaded into a tree viewing program or openend in arb together with the concatenated alignment generated by CheckM. the same can now also be done with GTDB-Tk.
#The tree can be found in the output folder under "/storage/tree/concatenated.tre", the aligned fasta file from which the tree was calculated is in the same folder: "/storage/tree/concatenated.fasta"

checkm lineage_wf \
    -x fasta \
    -t 32 \
    --pplacer_threads 32 \
    --tab_table \
    -f $TMPDIR/CheckM_Out_01/"$PROJECTNAME"_innitial_bins_Checkm.csv \
    $TMPDIR/Bins/ \
    $TMPDIR/CheckM_Out_01

#copy the CheckM results forlder back to data directory
scp -r $TMPDIR/CheckM_Out_01 $DATA_FOLDER/
scp $TMPDIR/CheckM_Out_01/storage/tree/concatenated.tre $DATA_FOLDER/"$PROJECTNAME"_checkM_01_Tree.tree
scp $TMPDIR/CheckM_Out_01/storage/tree/concatenated.fasta $DATA_FOLDER/"$PROJECTNAME"_checkM_01_Tree.fasta

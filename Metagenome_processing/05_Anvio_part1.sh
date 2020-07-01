#!/bin/bash
#SBATCH --job-name=Anvio_gen_database
#SBATCH --cpus-per-task=32
#SBATCH --mem=512G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@provider.net
#SBATCH --output=Anvio_gen_database.out
#SBATCH --error=Anvio_gen_database.err
#SBATCH --nice=1000
#SBATCH --partition=himem

module load anvio
module load centrifuge

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with fastq reads being in a subfolder called "reads".
#PROJECTNAME is a prefix which was used for the assembly etc.

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes
PROJECTNAME="Avdat"

mkdir $DATA_FOLDER/Anvio

scp $DATA_FOLDER/"$PROJECTNAME"_coassembly.fasta $TMPDIR/

#generate Anvi'O database
anvi-gen-contigs-database \
    -n "$PROJECTNAME" \
    -f $TMPDIR/"$PROJECTNAME"_coassembly.fasta \
    -L 0 \
    -o $TMPDIR/"$PROJECTNAME".db

#find conserved single-copy genes and RNAs with HMM motifs
anvi-run-hmms \
    -c $TMPDIR/"$PROJECTNAME".db \
    -T 32

#export the nucleotide sequences for open reading frames
anvi-get-sequences-for-gene-calls \
    -c $TMPDIR/"$PROJECTNAME".db \
    --get-aa-sequences \
    -o $TMPDIR/"$PROJECTNAME"_proteins.faa

scp $TMPDIR/"$PROJECTNAME".db $DATA_FOLDER/Anvio/
scp $TMPDIR/$TMPDIR/"$PROJECTNAME"_proteins.faa $DATA_FOLDER/Anvio/


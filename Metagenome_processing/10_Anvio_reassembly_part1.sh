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

#defining some variables. DATA_FOLDER should be an absolute path to where the data for the project is stored, with a subfolder called "Re_assembly" containing the fasta files of the clade-specific SPAdes assemblies and bam mapping files in the folder "Mapping".

DATA_FOLDER=/scratch/dmeier/Avdat_metagenomes

mkdir $DATA_FOLDER/Re_assembly/Anvio


for CLADE in (ls $DATA_FOLDER/Re_assembly/refs/*.fasta | xargs -n 1 basename | sed 's/\.fasta//g');

do

scp $DATA_FOLDER/Re_assembly/"$CLADE".fasta $TMPDIR/

#generate Anvi'O database
anvi-gen-contigs-database \
    -n "$CLADE" \
    -f $TMPDIR/"$CLADE".fasta \
    -L 0 \
    -o $TMPDIR/"$CLADE".db

#find conserved single-copy genes and RNAs with HMM motifs
anvi-run-hmms \
    -c $TMPDIR/"$CLADE".db \
    -T 32

#export the nucleotide sequences for open reading frames
anvi-get-sequences-for-gene-calls \
    -c $TMPDIR/"$CLADE".db \
    --get-aa-sequences \
    -o $TMPDIR/"$CLADE"_proteins.faa

#copy the exported protein sequences to data directory

scp $TMPDIR/$TMPDIR/"$CLADE"_proteins.faa $DATA_FOLDER/Re_assembly/Anvio/

scp $TMPDIR/"$CLADE".db $DATA_FOLDER/Re_assembly/Anvio/

done

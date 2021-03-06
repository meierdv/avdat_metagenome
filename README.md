# Genome-centric analysis of microbial communities from biological soil crusts of the Negev Desert (Avdat Long-term Ecological Research Site)

This repository contains scripts used to process the metagenomic and 16S rRNA gene amplicon data obtained from biological soil crusts in at the Avdat site (N 30°36'33", E 34°44'48") in the Negev Desert, Israel. The results and discussion of the analysis are published in the manuscript <b>"Distribution of mixotrophy and desiccation survival mechanisms across microbial genomes in an arid biological soil crust community"</b> by Dimitri Meier, Stefanie Imminger, Osnat Gillor and Dagmar Woebken. <b>DOI:10.1128/mSystems.00786-20</b>

<b>Data availability:</b> rRNA gene amplicon reads, unassembled metagenomic reads, metagenome assemblies, and annotated MAGs have been deposited in the European Nucleotide Archive under project number PRJEB36534.
  
The detailed rationale behind the metagenome analysis steps is explained in "Metagenome_analysis.pdf" in this repository and in the Supplementary Methods section of the manuscript.

<b>DISCLAIMER</b>:

The authors consider themselves as microbial ecologists (not bioinformaticians) applying existing bioinformatic tools to analyze large amounts of DNA seqeuncing data. 
Scripts published here are meant to provide transparency about the parameters used in the analyses. They use only existing software and are not intended to constitute a ready-to-go pipeline. The scripts include parameters specific to the Vienna Life Sciences Computing cluster such as use of locally available databases and SLURM work-load manager etc.

The scripts in each folder are numbered. If two scripts have the same number, it means that these analyses do not depend on each other's output and can be run simultaneously.

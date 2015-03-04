#!/bin/sh
#$ -cwd -V
#$ -S /bin/bash
#$ -o /home/dcook/SGE -e /home/dcook/SGE
#$ -pe serial 8


REFERENCE="/data/shared_resources/samtools/mm9.fa"
ENSEMBL_GTF="/data/shared_resources/Ensembl_annotations/Mus_musculus.NCBIM37.67.gtf"
INPUT_ROOT="/ohri/projects/vanderhyden/picketts2015/analysis/cufflinks/"
TOPHAT_DIR="/ohri/projects/vanderhyden/picketts2015/analysis/tophat/"
GC2="GC2/accepted_hits.bam"
GC3="GC3/accepted_hits.bam"
GNP2="GNP2/accepted_hits.bam"
GNP3="GNP3/accepted_hits.bam"


### Use module to load program including compiler
module load Cufflinks/2.2.1-goolf-1.4.10

cd $INPUT_ROOT
cuffmerge -p 8 -g $ENSEMBL_GTF -s $REFERENCE assemblies.txt
cuffdiff -p 8 -b $REFERENCE -L GNP,GC -u merged_asm/merged.gtf $TOPHAT_DIR$GC2,$TOPHAT_DIR$GC3 $TOPHAT_DIR$GNP2,$TOPHAT_DIR$GNP3

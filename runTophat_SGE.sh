#!/bin/sh
#$ -cwd -V
#$ -S /bin/bash
#$ -o /home/dcook/SGE -e /home/dcook/SGE
#$ -pe serial 8
#$ -t 1-4

### Setting variables directing to various inputs for TopHat&Cufflinks
BOWTIE_INDEX="/data/shared_resources/bowtie2_indexes/mm9"
ENSEMBL_GTF="/data/shared_resources/Ensembl_annotations/Mus_musculus.NCBIM37.67.gtf"
INPUT_ROOT="/ohri/projects/vanderhyden/picketts2015/rawdata/"


### SGE will run through the script once for each ID before cycling to the next
case "$SGE_TASK_ID" in	
	"1" )
		SAMPLE="GC2"
		INPUT="GC2_R1.fastq GC2_R2.fastq" ;;
	"2" )
		SAMPLE="GC3"
		INPUT="GC3_R1.fastq GC3_R2.fastq" ;;
	"3" )
		SAMPLE="GNP2"
		INPUT="GNP2_R1.fastq GNP2_R2.fastq" ;;
	"4" )
		SAMPLE="GNP3"
		INPUT="GNP3_R1.fastq GNP3_R2.fastq" ;;
esac

TOPHAT_DIR="/ohri/projects/vanderhyden/picketts2015/analysis/tophat/$SAMPLE"
CUFFLINKS_DIR="/ohri/projects/vanderhyden/picketts2015/analysis/cufflinks/$SAMPLE"


### Uses module to load programs (proper version and compiler chain)
module load Bowtie2/2.2.4-goolf-1.4.10
module load Bowtie/1.1.1-goolf-1.4.10
module load TopHat/2.0.12-goolf-1.4.10

cd $INPUT_ROOT
tophat -p 8 -G $ENSEMBL_GTF -o $TOPHAT_DIR $BOWTIE_INDEX $INPUT

module load Cufflinks/2.2.1-goolf-1.4.10
cufflinks -p 8 -o $CUFFLINKS_DIR -u $TOPHAT_DIR/accepted_hits.bam

### Makes small file with directions to transcript.gtf from each analysis. Used by cufflinks later
echo $CUFFLINKS_DIR"/transcript.gtf" >> /ohri/projects/vanderhyden/picketts2015/analysis/cufflinks/assembly.txt

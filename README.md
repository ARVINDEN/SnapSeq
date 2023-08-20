# SnapSeq

## About
Scalable non-invasive amplicon-based precision sequencing (SNAPseq), is a cost-effective method for genetic testing and screening of β-hemoglobinopathies. This is a script for automated analysis pipeline for amplicon seq of samples and report of pathogenic variants.


# Quickstart

## Installation
For ease of installation all the dependencies required for the SnapSeq pipeline are preinstalled in a conda environment. To use conda, download and install the latest version of [Anaconda](https://docs.anaconda.com/free/anaconda/install/index.html).

Create and activate the conda environment SnapSeq
```
conda create env -f SnapSeq.yaml
conda activate SnapSeq
```
## Reference genome and index
Download the human GRCh38 genome build fasta file from [ucsc]([url](https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/)) and build index as follows,

```
mkdir GenomeBuild
cd GenomeBuild
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gunzip  hg38.fa.gz
bwa index hg38.fa
```

## Download ANNOVAR and refGene database
Download the latest version of [ANNOVAR](https://annovar.openbioinformatics.org/en/latest/user-guide/download/#annovar-main-package) into a directory of interest and download the refGene database as follows,

```
./annotate_variation.pl --downdb refGene --buildver hg38 humandb
```

## Usage
```
./SnapSeq_multi.sh -s samplesheet.csv -p 5
```
Options:.
  
  -s, --samplesheet     samplesheet csv file.
  
  -p, --parallel     Number of jobs in parallel.
  
  -H, --help     Display this message.

## Samplesheet format
The samplesheet.csv should contain the following feilds;
1. read1 - Read1 fastq file (gziped).
2. read2 - Read2 fastq file (gziped).
3. SampleID - Unique sample name.
4. reference - path/to/reference.fasta(bwa index should be build in the same directory).
5. region - path/to/bed file of amplified region.
6. threads - Number of threads to use.
7. pathvcf - path/to/pathogenic variants VCF.
8. annovar - path/to/annovar.

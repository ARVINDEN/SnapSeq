## SnapSeq

# About
Scalable non-invasive amplicon-based precision sequencing (SNAPseq), is a cost-effective method for genetic testing and screening of β-hemoglobinopathies. This is a script for automated analysis pipeline for amplicon seq of samples and report of pathogenic variants.


# Dependencies
1. GNU Parallel
2. Trimmomatic
3. samtools
4. bwa
5. Picard tools
6. VarScan
7. Annovar
8. R Packages (argparse, dplyr, stringr, data.table, ggplots2, gmoviz, regioneR)

 # Usage
Usage: SnapSeq_multi.sh [OPTIONS].
Options:.
  -s, --samplesheet     samplesheet csv file.
  -p, --parallel     Number of jobs in parallel.
  -H, --help     Display this message.

The samplesheet.csv should contain the following feilds;
1. read1 - Read1 fastq file (gziped).
2. read2 - Read2 fastq file (gziped).
3. SampleID - Unique sample name.
4. reference - path/to/reference.fasta(bwa index should be build in the same directory).
5. region - path/to/bed file of amplified region.
6. threads - Number of threads to use.
7. pathvcf - path/to/pathogenic variants VCF.
8. trimmomatic - path/to/trimmomatic.jar file.
9. picard - path/to/picard.jar file.
10. varscan - path/to/varscan.jar file.
11. annovar - path/to/annovar.

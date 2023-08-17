#!/bin/bash

read1=""
read2=""
name=""
ref=""
region=""
threads=""
pathvars=""
annovar=""


display_help() {
  echo "Usage: SnapSeq.sh [OPTIONS]"
  echo "Options:"
  echo "  -1, --read1     Read1 fastq(gz) file"
  echo "  -2, --read2     Read2 fastq(gz) file"
  echo "  -n, --name     Sample name"
  echo "  -R, --ref     Reference genome"
  echo "  -r, --region     Amplified region (bed file)"
  echo "  -@, --threads     Numbers of threads to use"
  echo "  -p, --pathvars     Pathogenic variants VCF file"
  echo "  -a, --annovar     Path to annovar files"
  echo "  -H, --help     Display this message"
}


# Parse command-line options
OPTIONS=$(getopt -o 1:2:n:R:r:@:p:a:H --long read1:,read2:,name:,ref:,region:,threads:,pathvars:,annovar:,help -n 'SnapSeq.sh' -- "$@")
eval set -- "$OPTIONS"

# Process command-line options
while true; do
  case "$1" in
    -1 | --read1)
      shift
      read1="$1"
      ;;
    -2 | --read2)
      shift
      read2="$1"
      ;;
    -n | --name)
      shift
      name="$1"
      ;;
    -R | --ref)
      shift
      ref="$1"
      ;;
    -r | --region)
      shift
      region="$1"
      ;;
    -@ | --threads)
      shift
      threads="$1"
      ;;
    -p | --pathvars)
      shift
      pathvars="$1"
      ;;
    -a | --annovar)
      shift
      annovar="$1"
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Invalid option: $1"
      display_help
      exit 1
      ;;
  esac
  shift
done


echo Trimming $name...

trimmomatic PE -threads $threads -phred33 -trimlog "$name"_trim.log $read1 $read2 "$name"_R1_trimmed.fastq.gz "$name"_R1_unpaired.fastq.gz "$name"_R2_trimmed.fastq.gz "$name"_R2_unpaired.fastq.gz AVGQUAL:20 MINLEN:30 ILLUMINACLIP:TruSeq3-PE.fa:2:30:10

echo Aligning $name to reference genome...

bwa mem -t $threads $ref "$name"_R1_trimmed.fastq.gz "$name"_R2_trimmed.fastq.gz | samtools view -Sb -@ $threads | samtools sort -@ $threads -o "$name"_sorted.bam


picard MarkDuplicates I="$name"_sorted.bam O="$name"_sorted_markedduplicates.bam M="$name"_picard_mdinfo.txt REMOVE_DUPLICATES=true AS=true

samtools index "$name"_sorted_markedduplicates.bam

Rscript CovProf.R $region "$name"_sorted_markedduplicates.bam $name

samtools mpileup -f $ref "$name"_sorted_markedduplicates.bam -o "$name".pileup

varscan mpileup2cns "$name".pileup --min-coverage 10 ----min-reads2 5 --min-avg-qual 20 --output-vcf 1 --variants > "$name".vcf

"$annovar"/convert2annovar.pl --format vcf4 "$name".vcf --includeinfo --withzyg > "$name".avinput

"$annovar"/table_annovar.pl "$name".avinput $annovar/humandb --buildver hg38 --outfile $name --protocol refGene --operation g --nastring . --otherinfo --remove --thread $threads

Rscript FilterPath.R -db $pathvars -f "$name".hg38_multianno.txt -w -n "$name"_pathogenic_vars.tsv  

rm "$name".avinput "$name".pileup "$name"_sorted.bam 

echo Done...






#!/bin/bash

samplesheet=""

display_help() {
  echo "Usage: SnapSeq_multi.sh [OPTIONS]"
  echo "Options:"
  echo "  -s, --samplesheet     samplesheet csv file"
  echo "  -p, --parallel     Number of jobs in parallel"
  echo "  -H, --help     Display this message"
}


# Parse command-line options
OPTIONS=$(getopt -o s:p:H --long samplesheet:,parallel:,help -n 'SnapSeq_multi.sh' -- "$@")
eval set -- "$OPTIONS"

# Process command-line options
while true; do
  case "$1" in
    -s | --samplesheet)
      shift
      samplesheet="$1"
      ;;
    -p | --parallel)
      shift
      parallel="$1"
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

Rscript generatecmd.R $samplesheet

cat runsamples.txt | parallel -j $parallel {}



#!/bin/bash

# This script is used to build the bow tie reference index. 
# Run this only when working with a new reference that has not been formatted for bowtie2

BASEDIR=/workdir/yc2644/CV_NYC_lcWGS

PICARD=/programs/picard-tools-2.19.2/picard.jar
SAMTOOLS=/programs/samtools-1.11/bin/samtools
BOWTIEBUILD=/programs/bowtie2-2.3.5.1-linux-x86_64/bowtie2-build

REFERENCE=$BASEDIR/reference/CV30_masked.fasta   # This is a fasta file with the reference genome sequence we will map to
REFBASENAME="${REFERENCE%.*}"

## First create .bai and .dict files if they haven't been created
if [ ! -f $REFERENCE'.fai' ] ; then
	$SAMTOOLS faidx $REFERENCE
fi

if [ ! -f $REFBASENAME'.dict' ] ; then
	java -jar $PICARD CreateSequenceDictionary R=$REFERENCE O=$REFBASENAME'.dict'
fi

## Build the reference index
$BOWTIEBUILD $REFERENCE $REFBASENAME

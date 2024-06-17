#!/bin/bash

# ANGSD
export PATH=/programs/angsd20191002/angsd:$PATH

# PCAngsd
export PYTHONPATH=/programs/pcangsd-0.98/lib64/python3.6/site-packages:/programs/pcangsd-0.98/lib/python3.6/site-packages/programs/pcangsd-0.98
export LD_LIBRARY_PATH=/programs/pcangsd-0.98/

BASEDIR=/workdir/yc2644/CV_NYC_lcWGS
REFDIR=$BASEDIR/reference
DATADIR=$BASEDIR/bam
#OUTDIR=$BASEDIR/results_$ANALYSIS

# path to the reference/ancestral genomes
REF=$REFDIR/CV30_masked.fasta
ANC=$REFDIR/CV30_masked.fasta

# path to a list of bam files for sets of populations
ALL=$BASEDIR/sample_lists/ALL_low_highds_hhmerged.list
ALLRe02exDEBY=$BASEDIR/sample_lists/ALL_low_highds_hhmerged_rmRe0.2_exDEBY.list

# inversion regions
INVERS=$BASEDIR/sample_lists/chr_no_big_invers.txt
ONLYINVERS=$BASEDIR/sample_lists/chr_only_big_invers.txt

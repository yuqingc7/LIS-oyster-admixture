#!/bin/bash

# ANGSD
export PATH=/programs/angsd20191002/angsd:$PATH

# PCAngsd
export PYTHONPATH=/programs/pcangsd-0.98/lib64/python3.6/site-packages:/programs/pcangsd-0.98/lib/python3.6/site-packages/programs/pcangsd-0.98
export LD_LIBRARY_PATH=/programs/pcangsd-0.98/

BASEDIR=/workdir/yc2644/CV_NYC_lcWGS
REFDIR=$BASEDIR/reference
DATADIR=$BASEDIR/bam
OUTDIR=$BASEDIR/results_ngsrelate

# path to the reference/ancestral genomes
REF=$REFDIR/CV30_masked.fasta
ANC=$REFDIR/CV30_masked.fasta

# path to a list of bam files of each population
HHmerged=$BASEDIR/sample_lists/HH1013a_merged_bam_dedup_overlapclipped_realigned.list

FI=$BASEDIR/sample_lists/FIcombined_bam_dedup_overlapclipped_realigned.list
FI_Re02=$BASEDIR/sample_lists/FIcombined_Re0.2_bam_dedup_overlapclipped_realigned.list

SV=$BASEDIR/sample_lists/SV0512a_bam_dedup_overlapclipped_realigned.list

CT5785=$BASEDIR/sample_lists/CT_Cv5785_dedup_overlapclipped_realigned.list

CT5786=$BASEDIR/sample_lists/CT_Cv5786_dedup_overlapclipped_realigned.list
CT5786_Re02=$BASEDIR/sample_lists/CT_Cv5786_Re0.2_dedup_overlapclipped_realigned.list

UMFSds=$BASEDIR/sample_lists/UMFS_downsampled_bam.list

NEHds=$BASEDIR/sample_lists/NEH_downsampled_bam.list

# inversion regions
INVERS=$BASEDIR/sample_lists/chr_no_big_invers.txt
ONLYINVERS=$BASEDIR/sample_lists/chr_only_big_invers.txt

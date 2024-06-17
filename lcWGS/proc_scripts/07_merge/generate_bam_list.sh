#!/bin/bash
# This script is used to generate the bam list
# when there are no samples to merge

##### only run this when NO merging is needed

BASEDIR=/workdir/yc2644/CV_NYC_lcWGS

find $BASEDIR/bam -name "*_sorted.bam" -printf "%f\n" | sort > $BASEDIR/sample_lists/bam_list.txt

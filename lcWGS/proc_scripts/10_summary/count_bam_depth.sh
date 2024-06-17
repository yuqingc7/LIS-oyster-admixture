#!/bin/bash

#SBATCH --job-name=jDepth.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=4 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=20gb # job memory request; request 4 GB of memory for this job
#SBATCH --output=jDepth.out.%j # write stdout+stderr to this file; %j will be automatically replaced by the job ID

start=`date +%s`

## This script is used to count per position depth for bam files. It will create one depth file per bam file.
# Advantage of this version is that you can use R to process the depth files.
# The depth files will then be processed by running depth_summary.R
BASEDIR=/workdir/yc2644/CV_NYC_lcWGS
find $BASEDIR/bam -name "*_realigned.bam" -printf "%f\n" | sort > $BASEDIR/sample_lists/bam_dedup_overlapclipped_realigned.list
BAMLIST=/workdir/yc2644/CV_NYC_2022reseq/sample_lists/bam_dedup_overlapclipped_realigned.list
 # Path to a list of bam files.

for SAMPLEBAM in `cat $BAMLIST`; do
    ## Count per position depth per sample
    samtools depth -aa $BASEDIR'/bam/'$SAMPLEBAM | cut -f 3 | gzip > $BASEDIR'/bam/'$SAMPLEBAM'.depth.gz'
done

end=`date +%s` ## date at end
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

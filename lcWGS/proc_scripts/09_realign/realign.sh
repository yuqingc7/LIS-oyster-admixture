#!/bin/bash

#SBATCH --job-name=jRealign.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=60gb # job memory request; request 4 GB of memory for this job
#SBATCH --output=jRealign.out.%j # write stdout+stderr to this file; %j will be automatically replaced by the job ID

# In-del relignment
# This needs to be run in the /bam/ folder so that the realigned bam files can be outputted to the correct directory.

start=`date +%s`
BASEDIR=/workdir/yc2644/CV_NYC_lcWGS
find $BASEDIR/bam -name "*_overlapclipped.bam" -printf "%f\n" | sort > $BASEDIR/sample_lists/bam_dedup_overlapclipped.list
BAMLIST=$BASEDIR/sample_lists/bam_list_dedup_overlapclipped.list # Path to a list of merged, deduplicated, and overlap clipped bam files. Full paths should be included. An example of such a bam list is /workdir/cod/greenland-cod/sample_lists/bam_list_1.tsv
REFERENCE=$BASEDIR/reference/CV30_masked.fasta # Path to reference fasta file and file name, e.g /workdir/cod/reference_seqs/gadMor2.fasta
SAMTOOLS=/programs/samtools-1.11/bin/samtools # Path to samtools
GATK=/programs/GenomeAnalysisTK-3.7/GenomeAnalysisTK.jar # Path to GATK

cd $BASEDIR/bam

## Loop over each sample
for SAMPLEBAM in `cat $BAMLIST`; do

if [ -e $SAMPLEBAM'.bai' ]; then
    echo "the file already exists"
else
    ## Index bam files
    $SAMTOOLS index $SAMPLEBAM
fi

done

## Realign around in-dels
# This is done across all samples at once

## Use an older version of Java
export JAVA_HOME=/usr/local/jdk1.8.0_121
export PATH=$JAVA_HOME/bin:$PATH

## Create list of potential in-dels
if [ ! -f $BASEDIR'/bam/all_samples_for_indel_realigner.intervals' ]; then
    java -Xmx40g -jar $GATK \
       -T RealignerTargetCreator \
       -R $REFERENCE \
       -I $BAMLIST \
       -o $BASEDIR'/bam/all_samples_for_indel_realigner.intervals' \
       -drf BadMate
fi

## Run the indel realigner tool
java -Xmx40g -jar $GATK \
   -T IndelRealigner \
   -R $REFERENCE \
   -I $BAMLIST \
   -targetIntervals $BASEDIR'/bam/all_samples_for_indel_realigner.intervals' \
   --consensusDeterminationModel USE_READS  \
   --nWayOut _realigned.bam

end=`date +%s` ## date at end
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

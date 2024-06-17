#!/bin/bash -l 
# change the default shell to bash; '-l' ensures your .bashrc will be sourced in, thus setting the login environment

#SBATCH --job-name=jDupClip.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=60gb # job memory request; request 4 GB of memory for this job
#SBATCH --output=jDupClip.out.%A_%a # write stdout+stderr to this file; %j will be automatically replaced by the job ID
#SBATCH --array=1-9

# Deduplicate (all samples) and clip overlapping read pairs (pair-end only)
# this script is used to deduplicate bam files and clipped overlapping read pairs for paired end data.

## start date
start=`date +%s`

BASEDIR=/workdir/yc2644/CV_NYC_lcWGS

BAMLIST=$BASEDIR/sample_lists/bam_list_$SLURM_ARRAY_TASK_ID.txt # Path to a list of merged, deduplicated, and overlap clipped bam files. Full paths should be included.

PICARD=/programs/picard-tools-2.19.2/picard.jar # Path to picard tools
BAMUTIL=/programs/bamUtil/bam # Path to bamUtil

cd $BASEDIR/bam

## Loop over each sample
for SAMPLEBAM in `cat $BAMLIST`; do

        ## Extract the file name prefix for this sample
        ## file name example: Cv5785_01_NY_1_4_pe_bt2_CV30_masked_minq20_sorted.bam
        SAMPLEPREFIX=`echo ${SAMPLEBAM%.bam}`

        ## Remove duplicates and print dupstat file
        # We used to be able to just specify picard.jar on the CBSU server, but now we need to specify the path and version
        java -Xmx60g -jar $PICARD MarkDuplicates I=$SAMPLEBAM O=$SAMPLEPREFIX'_dedup.bam' M=$SAMPLEPREFIX'_dupstat.txt' VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES=true

        ## Clip overlapping paired end reads (only necessary for paired end data)
        $BAMUTIL clipOverlap --in $SAMPLEPREFIX'_dedup.bam' --out $SAMPLEPREFIX'_dedup_overlapclipped.bam' --stats

done

end=`date +%s` ## date at end
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"


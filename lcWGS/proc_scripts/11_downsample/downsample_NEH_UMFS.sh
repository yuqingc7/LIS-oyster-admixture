#!/bin/bash -l

#SBATCH --job-name=jDownsample_NEH_UMFS.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=10 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=20gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=jDownsample_NEH_UMFS.out.%j # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID

## start date
start=`date +%s`

BASEDIR=/workdir/yc2644/CV_NYC_lcWGS # Path to base directory.
TARGETDIR=$BASEDIR/bam/ # Path to target directory for data store.
BAMLIST=$BASEDIR/sample_lists/NEH_UMFS_bam.list # Path to a list of bam files for downsampling (after overlap clipping and realignment around indels).
SAMTOOLS=/programs/samtools-1.11/bin/samtools # Path to Samtools
PICARD=/programs/picard-tools-2.19.2/picard.jar # Path to GATK
SUM=$BASEDIR/summary/NEH_UMFS_bam_depth_per_position_per_sample_summary.tsv # Path to the coverage summary of bam files (before downsampling)
NYC_low_cvg=1.337678 # This is the average coverage across other lcWGS samples. I used the genome-wide coverage as it is more comparable than the realized coverage.

for SAMPLEBAM in `cat $BAMLIST`; do

    SAMPLEPREFIX=`echo ${SAMPLEBAM%.bam}`
    echo "Sample: $SAMPLEPREFIX"
    SAMPLE=`echo $SAMPLEBAM | cut -d$'_' -f 1-2`
    DEPTH=`grep $SAMPLE $SUM | cut -f 2`
    pct=`awk "BEGIN {printf \"%.2f\n\", $NYC_low_cvg/$DEPTH}"`
    
    echo "start downsampling"
    if (( $(echo "$pct >= 1" |bc -l) )); 
    then
        echo "Sample $SAMPLE has smaller coverage than the NYC oysters target coverage of $NYC_low_cvg"
        #cp $SAMPLEBAM $TARGETDIR$SAMPLEPREFIX'.1.bam'
        echo "--------------------------------------"
    else
        java -jar $PICARD DownsampleSam \
            I=$BASEDIR/bam/$SAMPLEBAM \
            O=$TARGETDIR$SAMPLEPREFIX'.'$pct'.bam' \
            STRATEGY=Chained \
            RANDOM_SEED=1 \
            P=$pct \
            ACCURACY=0.0001
        echo "--------------------------------------"
    fi
done

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

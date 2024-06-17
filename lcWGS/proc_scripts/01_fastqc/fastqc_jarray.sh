#!/bin/bash -l 
# change the default shell to bash; '-l' ensures your .bashrc will be sourced in, thus setting the login environment

#SBATCH --job-name=jQC.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=4gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=jQC.out.%A_%a # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID
#SBATCH --array=1-9

#!/bin/bash

## start date
start=`date +%s`

FASTQC=/programs/FastQC-0.11.8/fastqc
BASEDIR=/workdir/yc2644/CV_NYC_lcWGS
SAMPLELIST=$BASEDIR/sample_lists/fastq_list_$SLURM_ARRAY_TASK_ID.txt # Path to the sample list.
RAWFASTQSUFFIX1=_1.fq.gz # Suffix to raw fastq files. Forward reads here
RAWFASTQSUFFIX2=_2.fq.gz # Suffix to raw fastq files. Reverse reads

for SAMPLE in `cat $SAMPLELIST | head -n 3`; do  # The head -n 3 is taking just the first three elements of our fastq list to loop over

  $FASTQC $BASEDIR'/raw_fastq/'$SAMPLE$RAWFASTQSUFFIX1 -o $BASEDIR'/fastqc/'
  $FASTQC $BASEDIR'/raw_fastq/'$SAMPLE$RAWFASTQSUFFIX2 -o $BASEDIR'/fastqc/'
  
done

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

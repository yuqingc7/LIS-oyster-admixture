#!/bin/bash -l 
# change the default shell to bash; '-l' ensures your .bashrc will be sourced in, thus setting the login environment

#SBATCH --job-name=jTrim.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=4gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=jTrim.out.%A_%a # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID
#SBATCH --array=1-9

# The remaining options in the sbatch script are the same as the options used in other, non-array settings; 
# in this example, we are requesting that each array task be allocated 1 CPU (--ntasks=1) 
# and 4 GB of memory (--mem=4gb) for up to 8 hour (--time=8:00:00)

## start date
start=`date +%s`

# This script is used to clip adapters. 

# path to the base working directory for the job
BASEDIR=/workdir/yc2644/CV_NYC_lcWGS
    # subdirectories include: sample_lists, reference, raw_fastq

# path to the Trim program
TRIMMOMATIC=/programs/trimmomatic/trimmomatic-0.39.jar

# number of threads for trimmomatic to use (default 8)
THREADS=8

# path to a list of the prefixes of the raw fastq files
SAMPLELIST=$BASEDIR/sample_lists/fastq_list_$SLURM_ARRAY_TASK_ID.txt
    # it should be a subset of the the 1st column of the sample table.
    # it was splited from the fastq_list.txt file by 10 lines

# path to the sample table
SAMPLETABLE=$BASEDIR/sample_lists/fastq_table.txt
    # the 1st column is prefix of the raw fastq files
    # the 2nd column is lane number
    # the 3rd column is sequence ID
    # the 4th column is sample ID
    # the 5th column is population
    # the 6th column is the data type, which is either pe or se

# path to the raw fastq files
RAWFASTQDIR=$BASEDIR/raw_fastq/
RAWFASTQSUFFIX1=_1.fq.gz # suffix to forward reads fastq files (paired-end data)
RAWFASTQSUFFIX2=_2.fq.gz # suffix to reverse reads fastq files (paired-end data)

ADAPTERS=$BASEDIR/reference/NexteraPE-PE.fa # Path to a list of adapter/index sequences, copied from /programs/bbmap-38.86/resources/adapters.fa or /programs/trimmomatic/adapters/TruSeq3-PE-2.fa

# loop over each sequenced sample library
for SAMPLEFILE in `cat $SAMPLELIST`; do
    # extract relevant values from the sample table:
    # sample ID (column 4), population ID (column 5), sequencing ID (column 3), lane number (column 2)
    SAMPLE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 4`
	POP_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 5`
	SEQ_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 3`
	LANE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 2`

    # when a sample has been sequenced in multiple lanes
    # we need to identify the files from each run uniquely
	SAMPLE_UNIQ_ID=$SAMPLE_ID'_'$POP_ID'_'$SEQ_ID'_'$LANE_ID 
    echo "Sample: $SAMPLE_UNIQ_ID"

    # extract data type from the sample table
	DATATYPE=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 6`


	RAWFASTQ_ID=$RAWFASTQDIR$SAMPLEFILE # input path and file prefix
	SAMPLEADAPT=$BASEDIR'/adapter_clipped/'$SAMPLE_UNIQ_ID # output path and file prefix

    ## Adapter clip the reads with Trimmomatic
	# The options for ILLUMINACLIP are: ILLUMINACLIP:<fastaWithAdaptersEtc>:<seed mismatches>:<palindrome clip threshold>:<simple clip threshold>:<minAdapterLength>:<keepBothReads>
    # minAdapterLength: since palindrome mode has a very low false positive rate, this can be safely reduced, even down to 1, to allow shorter adapter fragments to be removed. 
    # keepBothReads: By specifying „true‟ for this parameter, the reverse read will also be retained, which may be useful e.g. if the downstream tools cannot handle a combination of paired and unpaired reads. 
	# The MINLENGTH drops the read if it is below the specified length in bp
	# For definitions of these options, see http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf
	if [ $DATATYPE = pe ]; then # for Paired End reads
		java -jar $TRIMMOMATIC PE -threads $THREADS -phred33 $RAWFASTQ_ID$RAWFASTQSUFFIX1 $RAWFASTQ_ID$RAWFASTQSUFFIX2 $SAMPLEADAPT'_adapter_clipped_f_paired.fastq.gz' $SAMPLEADAPT'_adapter_clipped_f_unpaired.fastq.gz' $SAMPLEADAPT'_adapter_clipped_r_paired.fastq.gz' $SAMPLEADAPT'_adapter_clipped_r_unpaired.fastq.gz' 'ILLUMINACLIP:'$ADAPTERS':2:30:10:1:true MINLENGTH:80'

	elif [ $DATATYPE = se ]; then # for Single End reads
		java -jar $TRIMMOMATIC SE -threads $THREADS -phred33 $RAWFASTQ_ID$RAWFASTQSUFFIX1 $SAMPLEADAPT'_adapter_clipped_se.fastq.gz' 'ILLUMINACLIP:'$ADAPTERS':2:30:10 MINLENGTH:40'
		fi

done

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

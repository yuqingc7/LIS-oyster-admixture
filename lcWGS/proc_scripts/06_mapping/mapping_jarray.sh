#!/bin/bash -l 
# change the default shell to bash; '-l' ensures your .bashrc will be sourced in, thus setting the login environment

#SBATCH --job-name=jMap.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=4 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=10gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=jMap.out.%A_%a # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID
#SBATCH --array=1-9


# This script is used to map the retained PE reads that failed to align concordantly to the mtDNA genome
# to the nuclear genome, filter, and convert to bam file


## start date
start=`date +%s`

# path to the base working directory for the job
BASEDIR=/workdir/yc2644/CV_NYC_lcWGS

# path to the bowtie2 & samtools program
BOWTIE=/programs/bowtie2-2.3.5.1-linux-x86_64/bowtie2
SAMTOOLS=/programs/samtools-1.11/bin/samtools

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

# path to the fastq files
FASTQDIR=$BASEDIR/mt_mapped/
FASTQSUFFIX1=.1 # suffix to forward reads fastq files (paired-end data)
FASTQSUFFIX2=.2 # suffix to reverse reads fastq files (paired-end data)

REFERENCE=$BASEDIR/reference/CV30_masked.fasta # path to reference fasta file and file name
REFNAME=CV30_masked # Reference name to add to output files, e.g. gadMor2

MAPPINGPRESET=very-sensitive # the pre-set option to use for mapping in bowtie2 
	# very-sensitive for end-to-end (global) mapping [typically used when we have a full genome reference], 
	# very-sensitive-local for partial read mapping that allows soft-clipping [typically used when mapping genomic reads to a transcriptome]

# loop over each sequenced sample library
for SAMPLEFILE in `cat $SAMPLELIST`; do
    # extract relevant values from the sample table:
    # sample ID (column 4), population ID (column 5), sequencing ID (column 3), lane number (column 2)
	SAMPLE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 4`
	POP_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 5`
	SEQ_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 3`
	LANE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 2`
	SAMPLE_UNIQ_ID=$SAMPLE_ID'_'$POP_ID'_'$SEQ_ID'_'$LANE_ID 

    # extract data type from the sample table
	DATATYPE=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 6`

	SAMPLETOMAP=$FASTQDIR$SAMPLE_UNIQ_ID # input path and file prefix
	SAMPLEBAM=$BASEDIR'/bam/'$SAMPLE_UNIQ_ID # output path and file prefix
	
    # define platform unit (PU), which is the lane number
	PU=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 2`

	# define reference base name
	REFBASENAME="${REFERENCE%.*}"

	# map reads to the reference
	echo $SAMPLE_UNIQ_ID

	if [ $DATATYPE = pe ]; then
	# we ignore the reads that get orphaned during adapter clipping because that is typically a very small proportion of reads. 
	# if a large proportion of reads get orphaned (loose their mate so they become single-end), these can be mapped in a separate step and the resulting bam files merged with the paired-end mapped reads.
	$BOWTIE -q --phred33 --$MAPPINGPRESET -p 4 -I 0 -X 1500 --fr --rg-id $SAMPLE_UNIQ_ID --rg SM:$SAMPLE_ID --rg LB:$SAMPLE_ID --rg PU:$PU --rg PL:ILLUMINA -x $REFBASENAME -1 $SAMPLETOMAP$FASTQSUFFIX1 -2 $SAMPLETOMAP$FASTQSUFFIX2 -S $SAMPLEBAM'_'$DATATYPE'_bt2_'$REFNAME'.sam'

	elif [ $DATATYPE = se ]; then
	$BOWTIE -q --phred33 --$MAPPINGPRESET -p 4 --rg-id $SAMPLE_UNIQ_ID --rg SM:$SAMPLE_ID --rg LB:$SAMPLE_ID --rg PU:$PU --rg PL:ILLUMINA -x $REFBASENAME -U $SAMPLETOMAP$FASTQSUFFIX1 -S $SAMPLEBAM'_'$DATATYPE'_bt2_'$REFNAME'.sam'

	fi

	# convert to bam file for storage (including all the mapped reads)
	$SAMTOOLS view -bS -F 4 $SAMPLEBAM'_'$DATATYPE'_bt2_'$REFNAME'.sam' > $SAMPLEBAM'_'$DATATYPE'_bt2_'$REFNAME'.bam'
	rm -f $SAMPLEBAM'_'$DATATYPE'_bt2_'$REFNAME'.sam' # remove sam files

	# filter the mapped reads (to only retain reads with high mapping quality)
	$SAMTOOLS view -h -q 20 $SAMPLEBAM'_'$DATATYPE'_bt2_'$REFNAME'.bam' | $SAMTOOLS view -buS - | $SAMTOOLS sort -o $SAMPLEBAM'_'$DATATYPE'_bt2_'$REFNAME'_minq20_sorted.bam'
		# filter bam files to remove poorly mapped reads (non-unique mappings and mappings with a quality score < 20)

done

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"


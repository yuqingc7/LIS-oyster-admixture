#!/bin/bash -l 
# change the default shell to bash; '-l' ensures your .bashrc will be sourced in, thus setting the login environment

#SBATCH --job-name=jmtDNA.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=4gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=jmtDNA.out.%A_%a # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID
#SBATCH --array=1-9


# This script is used to map the paired-end reads to the mitochondrial DNA (ref_C_virginica-3.0_mtDNA.fasta.gz, here renamed as cv30_mtDNA) using Bowtie2
# --very-sensitive for reference genome mapping
# --un-conc OPTION to retain the PE reads that failed to align concordantly to the mtDNA genome

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
FASTQDIR=$BASEDIR/qual_filtered/
FASTQSUFFIX1=_adapter_clipped_qual_filtered_f_paired.fastq.gz # suffix to forward reads fastq files (paired-end data)
FASTQSUFFIX2=_adapter_clipped_qual_filtered_r_paired.fastq.gz # suffix to reverse reads fastq files (paired-end data)

REFERENCE=$BASEDIR/reference/CV30_mtDNA.fasta # path to reference fasta file and file name
REFNAME=CV30_mtDNA # Reference name to add to output files, e.g. gadMor2

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
	SAMPLEBAM=$BASEDIR'/bam_mtDNA/'$SAMPLE_UNIQ_ID # output path and file prefix
	SAMPLETOFASTQ=$BASEDIR'/mt_mapped/'$SAMPLE_UNIQ_ID # output path and file prefix

    # define platform unit (PU), which is the lane number
	PU=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 2`

	# define reference base name
	REFBASENAME="${REFERENCE%.*}"

	# map reads to the reference
	echo $SAMPLE_UNIQ_ID

	# map the mtDNA
	$BOWTIE -q --phred33 --$MAPPINGPRESET --un-conc-gz $SAMPLETOFASTQ -p 1 -I 0 -X 1500 --fr --rg-id $SAMPLE_UNIQ_ID --rg SM:$SAMPLE_ID --rg LB:$SAMPLE_ID --rg PU:$PU --rg PL:ILLUMINA -x $REFBASENAME -1 $SAMPLETOMAP$FASTQSUFFIX1 -2 $SAMPLETOMAP$FASTQSUFFIX2 -S $SAMPLEBAM'_'$DATATYPE'_bt2_'$REFNAME'.sam'

	# remove the sam files
	rm -f $SAMPLEBAM'_'$DATATYPE'_bt2_'$REFNAME'.sam'

done

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

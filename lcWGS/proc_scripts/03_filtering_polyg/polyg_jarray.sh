#!/bin/bash -l 
# change the default shell to bash; '-l' ensures your .bashrc will be sourced in, thus setting the login environment

#SBATCH --job-name=jPolyg.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=4gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=jPolyg.out.%A_%a # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID
#SBATCH --array=1-9

## start date
start=`date +%s`

# This script is used to quality filter and trim poly g tails.  

# path to the base working directory for the job
BASEDIR=/workdir/yc2644/CV_NYC_lcWGS

# path to the fastp program
FASTP=/programs/fastp-0.20.0/bin/fastp

# number of threads to use. default is 10
THREADS=10

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

# type of filtering
FILTER=polyg
    # values can be: polyg (forced PolyG trimming only), 
    # quality (quality trimming, PolyG will be trimmed as well if processing NextSeq/NovaSeq data), 
    # or length (trim all reads to a maximum length)

# maximum length
MAXLENGTH=100
    # this input is only relevant when FILTER=length, and its default value is 100.

# loop over each sequenced sample library
for SAMPLEFILE in `cat $SAMPLELIST`; do
    # extract relevant values from the sample table:
    # sample ID (column 4), population ID (column 5), sequencing ID (column 3), lane number (column 2)
	SAMPLE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 4`
	POP_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 5`
	SEQ_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 3`
	LANE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 2`
	SAMPLE_UNIQ_ID=$SAMPLE_ID'_'$POP_ID'_'$SEQ_ID'_'$LANE_ID 
	echo "Sample: $SAMPLE_UNIQ_ID"

    # extract data type from the sample table
	DATATYPE=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 6`

	SAMPLEADAPT=$BASEDIR'/adapter_clipped/'$SAMPLE_UNIQ_ID # input path and file prefix
	SAMPLEQUAL=$BASEDIR'/qual_filtered/'$SAMPLE_UNIQ_ID # output path and file prefix

    ## Trim polyg tail or low quality tail with fastp
	# --trim_poly_g forces polyg trimming, --cut_right enables cut_right quality trimming
	# -Q disables quality filter, -L disables length filter, -A disables adapter trimming
	# Go to https://github.com/OpenGene/fastp for more information
	if [ $DATATYPE = pe ]; then
		if [ $FILTER = polyg ]; then
			$FASTP --trim_poly_g --cut_right -L -A --thread $THREADS -i $SAMPLEADAPT'_adapter_clipped_f_paired.fastq.gz' -I $SAMPLEADAPT'_adapter_clipped_r_paired.fastq.gz' -o $SAMPLEQUAL'_adapter_clipped_qual_filtered_f_paired.fastq.gz' -O $SAMPLEQUAL'_adapter_clipped_qual_filtered_r_paired.fastq.gz' -h $SAMPLEQUAL'_adapter_clipped_fastp.html' -j $SAMPLEQUAL'_adapter_clipped_fastp.json'
		elif [ $FILTER = quality ]; then
			$FASTP -L -A --thread $THREADS -i $SAMPLEADAPT'_adapter_clipped_f_paired.fastq.gz' -I $SAMPLEADAPT'_adapter_clipped_r_paired.fastq.gz' -o $SAMPLEQUAL'_adapter_clipped_qual_filtered_f_paired.fastq.gz' -O $SAMPLEQUAL'_adapter_clipped_qual_filtered_r_paired.fastq.gz' -h $SAMPLEQUAL'_adapter_clipped_fastp.html' -j $SAMPLEQUAL'_adapter_clipped_fastp.json'
		elif [ $FILTER = length ]; then
			$FASTP --max_len1 $MAXLENGTH -Q -L -A --thread $THREADS -i $SAMPLEADAPT'_adapter_clipped_f_paired.fastq.gz' -I $SAMPLEADAPT'_adapter_clipped_r_paired.fastq.gz' -o $SAMPLEQUAL'_adapter_clipped_qual_filtered_f_paired.fastq.gz' -O $SAMPLEQUAL'_adapter_clipped_qual_filtered_r_paired.fastq.gz' -h $SAMPLEQUAL'_adapter_clipped_fastp.html' -j $SAMPLEQUAL'_adapter_clipped_fastp.json'
		fi

	elif [ $DATATYPE = se ]; then
		if [ $FILTER = polyg ]; then
			$FASTP --trim_poly_g --cut_right -L -A --thread $THREADS -i $SAMPLEADAPT'_adapter_clipped_se.fastq.gz' -o $SAMPLEQUAL'_adapter_clipped_qual_filtered_se.fastq.gz' -h $SAMPLEQUAL'_adapter_clipped_fastp.html' -j $SAMPLEQUAL'_adapter_clipped_fastp.json'
		elif [ $FILTER = quality ]; then
			$FASTP -L -A --thread $THREADS -i $SAMPLEADAPT'_adapter_clipped_se.fastq.gz' -o $SAMPLEQUAL'_adapter_clipped_qual_filtered_se.fastq.gz' -h $SAMPLEQUAL'_adapter_clipped_fastp.html' -j $SAMPLEQUAL'_adapter_clipped_fastp.json'
		elif [ $FILTER = length ]; then
			$FASTP --max_len1 $MAXLENGTH -Q -L -A --thread $THREADS -i $SAMPLEADAPT'_adapter_clipped_se.fastq.gz' -o $SAMPLEQUAL'_adapter_clipped_qual_filtered_se.fastq.gz' -h $SAMPLEQUAL'_adapter_clipped_fastp.html' -j $SAMPLEQUAL'_adapter_clipped_fastp.json'
		fi
	fi	
done

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

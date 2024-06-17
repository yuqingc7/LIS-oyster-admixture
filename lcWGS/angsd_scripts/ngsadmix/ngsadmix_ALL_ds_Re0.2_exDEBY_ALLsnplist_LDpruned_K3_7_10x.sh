#!/bin/bash -l

#SBATCH --job-name=ngsadmix_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_K3_7_10x.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=12 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=30gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=ngsadmix_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_K3_7_10x.out.%j # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID

## start date
start=`date +%s`

NGSADMIX=/programs/NGSadmix/NGSadmix

BASEDIR=/workdir/yc2644/CV_NYC_lcWGS
INDIR=$BASEDIR/results_pca
OUTDIR=$BASEDIR/results_ngsadmix
PREFIX=ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver

for ((i=1; i<=10; i++)); do
	echo $i
	for ((K=3; K<=7; K++)); do
    		echo $K
    		$NGSADMIX -P 12 -likes $INDIR'/'$PREFIX'.beagle.gz' -K $K -o $OUTDIR'/ngsadmix_K'$K'_run'$i'_'$PREFIX
	done
done

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"


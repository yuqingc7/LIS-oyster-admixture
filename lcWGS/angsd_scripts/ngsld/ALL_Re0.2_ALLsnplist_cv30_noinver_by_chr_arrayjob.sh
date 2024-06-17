#!/bin/bash

#SBATCH --job-name=ALL_Re0.2_ALLsnplist_maf0.05_pind0.86_cv30_noinver_by_chr.sh
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=12 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=40gb # job memory request; request 4 GB of memory for this job
#SBATCH --output=ALL_Re0.2_ALLsnplist_maf0.05_pind0.86_cv30_noinver_by_chr.out.%j
#SBATCH --array=1-10

## start date
start=`date +%s`

source /workdir/yc2644/CV_NYC/angsd_scripts/ngsld/config_per_pop_per_chr.sh
cd $BASEDIR/bam

target="ALL_Re0.2_ALLsnplist"
TARGET=$ALLRe02

THREADS=12 # set threads number for option -P; change accordingly
PV=1e-6 # p value for SNPs calling (0.05 1e-2 1e-4 1e-6 2e-6)
MIN_MAF=0.05 # SNPs restricted to be more common variants with minor allele frequencies of at least 5%
PERCENT_IND=0.86 # percentage of individuals
N_IND=$(wc -l $TARGET | cut -d " " -f 1) # calculate the number of individuals
MIN_IND=$(($N_IND*86/100)) # keep SNP with at least one read for this percentage (80%) of individuals over all individuals

echo "Ouput beagle files can be used for ngsld for all individuals listed in "$TARGET" by chromosome"
echo "keep loci with at leat one read for n individuals = "$MIN_IND", which is 86% of total "$N_IND" individuals"
echo "filter on allele frequency = "$MIN_MAF

echo "Starting chromosome" $SLURM_ARRAY_TASK_ID

OUTBASE=$target"_maf"$MIN_MAF"_pval"$PV"_pind"$PERCENT_IND"_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID

angsd -P $THREADS \
-b $TARGET -anc $ANC -out $OUTDIR"/"$OUTBASE \
-doMaf 1 \
-GL 1 -doSaf 1 -doGlf 2 -doMajorMinor 3 -sites $BASEDIR"/results_ngsld/global_snp_list_ALL_ds_maf0.05_pval1e-6_pind0.86_cv30_noinver_chr"$SLURM_ARRAY_TASK_ID".txt"

echo "Finishing chromosome" $SLURM_ARRAY_TASK_ID

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"


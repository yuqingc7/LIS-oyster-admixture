#!/bin/bash

#SBATCH --job-name=ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_pca_noinver_maf0.05_pind0.86.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=12 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=50gb # job memory request; request 4 GB of memory for this job
#SBATCH --output=ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_pca_noinver_maf0.05_pind0.86.out.%j # write stdout+stderr to this file; %j will be automatically replaced by the job ID

# this script performs SNP calling based on genotype likelihoods and produces outputs for PCA/MDS method
# based on pruned SNP datasets

## start date
start=`date +%s`
# configure the variables and such
source /workdir/yc2644/CV_NYC_lcWGS/angsd_scripts/config.sh
cd $BASEDIR/bam
OUTDIR=$BASEDIR/results_pca

TARGET=$ALLRe02exDEBY
target="ALL_ds_Re0.2_exDEBY"

THREADS=12 # set threads number for option -P; change accordingly
PV=1e-6 # p value for SNPs calling (0.05 1e-2 1e-4 1e-6 2e-6)
MIN_MAF=0.05 # SNPs restricted to be more common variants with minor allele frequencies of at least 5%
PERCENT_IND=0.86 # percentage of individuals
N_IND=$(wc -l $TARGET | cut -d " " -f 1) # calculate the number of individuals
MIN_IND=$(($N_IND*86/100)) # keep SNP with at least one read for this percentage (80%) of individuals over all individuals 

echo "Ouput can be used for PCA/MDS for all individuals listed in "$TARGET
echo "keep loci with at leat one read for n individuals = "$MIN_IND", which is 86% of total "$N_IND" individuals"
echo "filter on allele frequency = "$MIN_MAF

OUTBASE=$target"_ALLsnplist_LDpruned_maf"$MIN_MAF"_pval"$PV"_pind"$PERCENT_IND"_cv30_noinver"

angsd -P $THREADS \
    -b $TARGET -anc $ANC -out $OUTDIR"/"$OUTBASE \
    -rf $INVERS \
    -doMaf 1 -GL 1 -doGlf 2 -doMajorMinor 3 \
    -doIBS 1 -doCounts 1 -doCov 1 -makeMatrix 1 \
    -sites $OUTDIR'/global_snp_list_ALL_ds_maf0.05_pval1e-6_pind0.86_cv30_noinver_LDpruned.txt'

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"



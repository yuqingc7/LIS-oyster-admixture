#!/bin/bash

#SBATCH --job-name=ALL_Re0.2_ALLsnplist_ngsld_est_by_chr.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=14 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=20gb # job memory request; request 4 GB of memory for this job
#SBATCH --output=ALL_Re0.2_ALLsnplist_maf0.05_pind0.86_ngsld_est_by_chr.sh.out.%A_%a # write stdout+stderr to this file; %j will be automatically replaced by the job ID
#SBATCH --array=1-10


## start date
start=`date +%s`

# This script calculates pairwise Linkage Disequilibrium (LD) under a probabilistic framework

BASEDIR=/workdir/yc2644/CV_NYC
export PERL5LIB=/programs/PERL/lib/perl5
export PATH=/programs/ngsLD-1.1.1:/programs/ngsLD-1.1.1/scripts:$PATH
	
echo "Starting Chr"$SLURM_ARRAY_TASK_ID	

zcat $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID".mafs.gz" | cut -f 1,2 | tail -n +2 > $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID"_pos.txt"
cnt=$(cat $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID"_pos.txt" | wc -l)

ngsLD \
--geno $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID".beagle.gz" \
--pos $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID"_pos.txt" \
--probs \
--n_ind 145 \
--n_sites $cnt \
--max_kb_dist 0 \
--max_snp_dist 0 \
--n_threads 14 \
--out $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID".ld"

#cut -f1,4,7- $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID".ld" > $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID"_new.ld"
	
echo "Finishing Chr"$SLURM_ARRAY_TASK_ID


# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"


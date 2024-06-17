#!/bin/bash

#SBATCH --job-name=ALL_Re0.2_ALLsnplist_ngsld_pruning_by_chr.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=12 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=20gb # job memory request; request 4 GB of memory for this job
#SBATCH --output=ALL_Re0.2_ALLsnplist_maf0.05_pind0.86_ngsld_pruning_pmaxdt10_pminwt0.5_by_chr.out.%A_%a # write stdout+stderr to this file; %j will be automatically replaced by the job ID
#SBATCH --array=1-10

## start date
start=`date +%s`

BASEDIR=/workdir/yc2644/CV_NYC
export PERL5LIB=/programs/PERL/lib/perl5
export PATH=/programs/ngsLD-1.1.1:/programs/ngsLD-1.1.1/scripts:$PATH

# use the script scripts/prune_graph.pl to prune your dataset and get a list of unlinked sites
prune_graph.pl \
--in_file $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID".ld" \
--max_kb_dist 10 \
--min_weight 0.5 \
--out $BASEDIR"/results_ngsld/ALL_Re0.2_ALLsnplist_maf0.05_pval1e-6_pind0.86_cv30_noinver_ch"$SLURM_ARRAY_TASK_ID"_unlinked_pmaxdt10_pminwt0.5.id"


# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

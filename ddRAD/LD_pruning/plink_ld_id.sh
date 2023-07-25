#!/bin/bash -l

#SBATCH --job-name=plink_all_ld_pruning.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=1gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=plink_all_ld_pruning.out.%j # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID


## start date
start=`date +%s`

PREFIX=SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396

/programs/plink-1.9-x86_20210606/plink --vcf "/workdir/yc2644/CV_NYC_ddRAD/vcf/"$PREFIX".recode.vcf" \
--allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 1 0.2 \
--out "/workdir/yc2644/CV_NYC_ddRAD/LD_pruning/"$PREFIX"_indep_50_1_0.2"

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

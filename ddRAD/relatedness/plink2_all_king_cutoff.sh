#!/bin/bash -l

#SBATCH --job-name=plink2_all_king.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=2gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=plink2_all_king_cutoff.out.%j # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID


## start date
start=`date +%s`

PREFIX=SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers

/programs/plink2_linux_general_20220129/plink2 \
--vcf "/workdir/yc2644/CV_NYC_ddRAD/vcf/"$PREFIX".recode.vcf" \
--allow-extra-chr \
--king-cutoff 0.177 \
--out "/workdir/yc2644/CV_NYC_ddRAD/relatedness/"$PREFIX

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

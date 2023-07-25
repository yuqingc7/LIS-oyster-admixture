#!/bin/bash -l

#SBATCH --job-name=structure_threader_n380_all_cor.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=10 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=20gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=structure_threader_n380_all_cor.out.%j # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID


## start date
start=`date +%s`

PREFIX=SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil
SAMPLE=n380_all


## set environment

export PYTHONPATH=/programs/structure_threader-1.2.11/lib/python3.6/site-packages/
export PATH=/programs/structure_threader-1.2.11/bin:$PATH

# run software
structure_threader run -i "/workdir/yc2644/CV_NYC_ddRAD/structure/"$SAMPLE"_cor/threader_input/"$SAMPLE"_"$PREFIX".recode.strct_in" -o "/workdir/yc2644/CV_NYC_ddRAD/structure/"$SAMPLE"_cor" -st /programs/structure_2_3_4/bin/structure -K 4 -R 10 -t 10 --log true

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"

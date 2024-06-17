#!/bin/sh
# this script is used for relatedness estimation

#SBATCH --job-name=jngsrelate.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=10 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=30gb # job memory request; request 4 GB of memory for this job
#SBATCH --output=jngsrelate.out.%j # write stdout+stderr to this file; %j will be automatically replaced by the job ID

## start date
start=`date +%s`

# configure the variables and such
source /workdir/yc2644/CV_NYC_lcWGS/angsd_scripts/config_each_pop.sh
cd $BASEDIR/results_glf

OUTDIR=$BASEDIR/results_ngsrelate

ngsRelate=/programs/ngsRelate-20190304/ngsRelate
FI_cnt=24
SV_cnt=24
CT5785_cnt=30
CT5786_cnt=30
HHmerged_cnt=25
UMFSds_cnt=10
NEHds_cnt=10

for pop in FI SV CT5785 CT5786 HHmerged UMFSds NEHds; do
    # extract the snp frequency column from mafs zip file and remove the header (to make it in the format NgsRelate needs)
    zcat $pop'_maf0.05_pval1e-6_pind0.8_cv30_full.mafs.gz' | cut -f6 |sed 1d > $pop'_freq'
    cnt=$pop'_cnt'
    # calculate the stats using ngsrelate
    echo ${!cnt}
    $ngsRelate -f $pop'_freq' -g $pop'_maf0.05_pval1e-6_pind0.8_cv30_full.glf.gz' -n ${!cnt} -z $pop'.list' -O $pop'.res'
    done

# The output should be a file called $pop'.res' that contains the output for all pairs between all individuals.
# NgsRelate takes two files as input: 
# a file with genotype likelihoods (-g) and a file with population allele frequencies (-f) for the sites there are genotype likelihoods for. 
# -z <INT> Name of file with IDs (optional)
# -n <INT> Number of samples in glf.gz
# https://github.com/ANGSD/NgsRelate

# Note that if you want you also input a file with the IDs of the individuals (on ID per line) in the same order as in the file 'filelist' used to make the genotype likelihoods. 
# If you do the output will also contain these IDs and not just the numbers of the samples (one can actually just use that exact file, however the IDs then tend to be a bit long). 
# This can be done with the optional flag -z followed by the filename.

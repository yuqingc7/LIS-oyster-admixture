#!/bin/bash -l

#SBATCH --job-name=structure_threader_cor_s3270.sh # job name
#SBATCH --mail-user=yc2644@cornell.edu # where to send mail
#SBATCH --mail-type=END,FAIL # mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=12 # number of tasks; by default, 1 task=1 slot=1 thread
#SBATCH --nodes=1 # number of nodes, i.e., machines; all non-MPI jobs *must* run on a single node, i.e., '--nodes=1' must be given here
#SBATCH --mem=20gb # job memory request; request 8 GB of memory for this job; default is 1GB per job; here: 8
#SBATCH --output=structure_threader_cor.out.%j # write stdout+stderr to this file; %A and %a replacement strings for the master job ID and task ID


## start date
start=`date +%s`

WORKDIR=/workdir/yc2644/CV_NYC_nemo_sim/
NUMIND=90
S=3270

echo "high differentiation"
for ADMIX in "cons0.001" "cons0.002" "cons0.005" "cons0.01" "cons0.02" "cons0.05"; do
	echo "scenario $ADMIX"
	#for AD_GEN in 13671 13672 13676 13681 13686 13691 13701; do
	for AD_GEN in 13671 13672 13676 13681 13691 13701; do
		echo "time since admixture $AD_GEN"
		for REP in {01..10}; do
			echo "replicate $REP"
			
			PREFIX="2pop_ntrl_eq10400_s"$S"_"$ADMIX"_rep"$REP"_"$AD_GEN

			# run software
			/home/yc2644/.local/bin/structure_threader run -i $WORKDIR"structure/"$PREFIX"/threader_input/"$PREFIX".n"$NUMIND".str" -o $WORKDIR"structure/"$PREFIX -st /programs/structure_2_3_4/bin/structure -K 2 -R 10 -t 12 --log true --ind $WORKDIR"structure/indfile_n"$NUMIND".txt" --params $WORKDIR"structure/mainparams"

		done
	done
done

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"


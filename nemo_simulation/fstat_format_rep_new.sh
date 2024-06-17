#!/bin/bash

# this script stores commands to merge unadmixed native population (pop3) before admixture event
# with admixed populations (admixed native pop1, aquaculture pop2)

# S=1000
# PRE_AD_GEN=11400
# S=40
# PRE_AD_GEN=10440

S=3270
PRE_AD_GEN=13670
# S=280
# PRE_AD_GEN=10680

#ADMIX_ALL=("cons0.01" "cons0.02" "cons0.05" "cons0.1" "cons0.2" "cons0.5")
#ADMIX_ALL=("single0.1" "single0.2" "single0.5" "single0.8")
ADMIX_ALL=("cons0.001" "cons0.002" "cons0.005" "cons0.01" "cons0.02" "cons0.05")

for ADMIX in "${ADMIX_ALL[@]}"; do
	echo "$ADMIX"
	WORKDIR="/workdir/yc2644/CV_NYC_nemo_sim/nemo_simulations/2pop_ntrl_eq10400_s"$S"_"$ADMIX"_rep/ntrl"
	cd $WORKDIR

	for REP in {01..10}; do
		echo "replicate $REP"
	
		PREFIX="2pop_ntrl_eq10400_s"$S"_"$ADMIX"_rep"$REP
	
		# extract native population (30 inds)
		sed -n '5006,5035p;5036q' $PREFIX"_"$PRE_AD_GEN"_1.dat" > $PREFIX"_"$PRE_AD_GEN".unadmixed.dat"

		# extract AQ population (30 inds) (population id is 2 already)
		sed -n '5036,5065p;5066q' $PREFIX"_"$PRE_AD_GEN"_1.dat" > $PREFIX"_"$PRE_AD_GEN".aq.dat"

		# Change the first number in every column from 1 to 3 (population id)
		sed 's/^./3/' $PREFIX"_"$PRE_AD_GEN".unadmixed.dat" > $PREFIX"_"$PRE_AD_GEN".unadmixed.mod.dat"

		#for i in 0 1 2 3 5 10 15 20
		for i in 0 1 5 10 15 20 30
		do
			AD_GEN=$(($PRE_AD_GEN +1 + $i))
			# Merge the unadmixed genotypes and aq genotypes with admixed genotypes at different generation
			echo "$AD_GEN generations of admixture"

			#extract admixed native population (30 inds) + header info
			sed -n '1,5035p;5036q' $PREFIX"_"$AD_GEN"_1.dat" > $PREFIX"_"$AD_GEN"_1_wild.dat"

			cat $PREFIX"_"$AD_GEN"_1_wild.dat" $PREFIX"_"$PRE_AD_GEN".aq.dat" $PREFIX"_"$PRE_AD_GEN".unadmixed.mod.dat" > $PREFIX"_"$AD_GEN".n90.dat"

			# remove extra information in extended fstat file
			# Change 5004 in the first line to 5000
			sed -i '1s/5004/5000/' $PREFIX"_"$AD_GEN".n90.dat"
			# Change pop total 2 in the first line to 3 (because I added the unadmixed pop)
			sed -i '1s/2/3/1' $PREFIX"_"$AD_GEN".n90.dat"
			# Remove last four columns of each line from L5006-5095
			sed -i '5006,5095s/\([^ ]* *\)\{4\}$//' $PREFIX"_"$AD_GEN".n90.dat"
			# Remove four lines for the four last values age,sex,ped,origin (L5002, 5003, 5004, 5005)
			sed -i '5002,5005d' $PREFIX"_"$AD_GEN".n90.dat"
			mkdir "/workdir/yc2644/CV_NYC_nemo_sim/structure/"$PREFIX"_"$AD_GEN
			mkdir "/workdir/yc2644/CV_NYC_nemo_sim/structure/"$PREFIX"_"$AD_GEN"/threader_input"
		done
	done
done


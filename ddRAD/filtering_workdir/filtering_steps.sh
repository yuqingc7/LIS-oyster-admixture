# This script follows the filtering steps in dDocent tutorial
# http://www.ddocent.com/filtering/


# Keep variants that have been successfully genotyped in 50% of individuals, a minimum quality score of 30, and a minor allele count of 3

vcftools --gzvcf ../vcf/TotalRawSNPs.vcf --max-missing 0.5 --mac 3 --minQ 30 --recode --recode-INFO-all --out TotalRawSNPs.g5mac3

# The next filter we will apply is a minimum depth for a genotype call and a minimum mean depth. Keep genotypes that have less than 3 reads
vcftools --vcf TotalRawSNPs.g5mac3.recode.vcf --minDP 3 --recode --recode-INFO-all --out TotalRawSNPs.g5mac3dp3

# The next step is to get rid of individuals that did not sequence well. We can do this by assessing individual levels of missing data
curl -L -O  https://github.com/jpuritz/dDocent/raw/master/scripts/filter_missing_ind.sh
chmod +x filter_missing_ind.sh
./filter_missing_ind.sh TotalRawSNPs.g5mac3dp3.recode.vcf TotalRawSNPs.g5mac3dplm # input vcf file + output file prefix
# plotting a histogram of missing data per individual
# set a cut-off based on the histogram

# Now that we have removed poor coverage individuals, we can restrict the data to variants called in a high percentage of individuals and filter by mean depth of genotypes
vcftools --vcf TotalRawSNPs.g5mac3dplm.recode.vcf --max-missing 0.95 --maf 0.05 --recode --recode-INFO-all --out DP3g95maf05 --min-meanDP 20
# This applied a genotype call rate (95%) across all individuals. With two localities, this is sufficient, but when you have multiple localities being sampled You are also going to want to filter by a population specific call rate.

# Filter by a population specific call rate 
curl -L -O https://github.com/jpuritz/dDocent/raw/master/scripts/pop_missing_filter.sh
chmod +x pop_missing_filter.sh
./pop_missing_filter.sh 
# Usage is pop_missing_filter vcffile popmap percent_missing_per_pop number_of_pops_for_cutoff name_for_output
./pop_missing_filter.sh DP3g95maf05.recode.vcf popmap 0.1 22 DP3g95p10maf05

# From this point forward, the filtering steps assume that the vcf file was generated by FreeBayes

# take a look at the header of our VCF file and take a quick look at all the information.
mawk '/#/' DP3g95p10maf05.recode.vcf | less

# This script will automatically filter a FreeBayes generated VCF file using criteria related to site depth,
# quality versus depth, strand representation, allelic balance at heterzygous individuals, and paired read representation.
# The script assumes that loci and individuals with low call rates (or depth) have already been removed.
curl -L -O https://github.com/jpuritz/dDocent/raw/master/scripts/dDocent_filters
chmod +x dDocent_filters
./dDocent_filters
# bash dDocent_filters.sh VCF_file Output_prefix
bash dDocent_filters DP3g95p10maf05.recode.vcf DP3g95p10maf05.FIL

# The next filter to apply is HWE. Heng Li also found that HWE is another excellent filter to remove erroneous variant calls. We don’t want to apply it across the board, since population structure will create departures from HWE as well. We need to apply this by population.

# First, we need to convert our variant calls to SNPs
# This will decompose complex variant calls into phased SNP and INDEL genotypes and keep the INFO flags for loci and genotypes. 
/programs/vcflib-1.0.1/bin/vcfallelicprimitives DP3g95p10maf05.FIL.FIL.recode.vcf --keep-info --keep-geno > DP3g95p10maf05.FIL.prim.vcf
# Next, we can feed this VCF file into VCFtools to remove indels.
vcftools --vcf DP3g95p10maf05.FIL.prim.vcf --remove-indels --recode --recode-INFO-all --out SNP.DP3g95p10maf05

curl -L -O https://github.com/jpuritz/dDocent/raw/master/scripts/filter_hwe_by_pop.pl
chmod +x filter_hwe_by_pop.pl
./filter_hwe_by_pop.pl
# filter_hwe_by_pop.pl -v <vcffile> -p <popmap> [options]
./filter_hwe_by_pop.pl -v SNP.DP3g95p10maf05.recode.vcf -p popmap -h 0.001 -c 0.25 -o SNP.DP3g95p10maf05.HWE
# -h, --hwe: Minimum cutoff for Hardy-Weinberg p-value (for test as implemented in vcftools) [Default: 0.001]
# -c, --cutoff: Proportion of all populations that a locus can be below HWE cutoff without being filtered. For example, choosing 0.5 will filter SNPs that are below the p-value threshold in 50% or more of the populations. [Default: 0.25]
# Typically, errors would have a low p-value and would be present in many populations.

# We have now created a thoroughly filtered VCF, and we should have confidence in these SNP calls.

# However, rad_haplotyper tool takes a VCF file of SNPs and will parse through BAM files looking to link SNPs into haplotypes along paired reads.
curl -L -O https://raw.githubusercontent.com/chollenbeck/rad_haplotyper/master/rad_haplotyper.pl
chmod +x rad_haplotyper.pl
# perl rad_haplotyper.pl -v <vcffile> -r <reference> [options]
perl rad_haplotyper.pl -v SNP.DP3g95p10maf05.HWE.recode.vcf -x 8 -mp 1 -u 15 -ml 10 -n -r reference.fasta
# -ml, --max_low_cov_inds: Count cutoff for removing loci with low coverage or genotyping errors from the final output. The value is the maximum allowable number of individuals with less than the expected number of haplotypes [Default: No filter]
# - x, threads
# -n, --keep_single_indels: Includes indels that are the only polymorphism at the locus (contig)
# -u, --cutoff: Excludes loci with more than the specified number of SNPs [Default: No filter]
# -m, --miss_cutoff: Proportion of missing data cutoff for removing loci from the final output. For example, to keep only loci with successful haplotype builds in 95% of individuals, enter 0.95. [Default:0.9]
# -mp, --max_paralog_inds: Count cutoff for removing loci that are possible paralogs from the final output. The value is the maximum allowable number of individuals with more than the expected number of haplotypes [Default: No filter]
# -ml: --max_low_cov_ind: Count cutoff for removing loci with low coverage or genotyping errors from the final output. The value is the maximum allowable number of individuals with less than the expected number of haplotypes [Default: No filter]


# 
curl -L -O https://github.com/jpuritz/dDocent/raw/master/scripts/remove.bad.hap.loci.sh
chmod +x remove.bad.hap.loci.sh
./remove.bad.hap.loci.sh loci.to.remove SNP.DP3g95p5maf05.HWE.recode.vcf 





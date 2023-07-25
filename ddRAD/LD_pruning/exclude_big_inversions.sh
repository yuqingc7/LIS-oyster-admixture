
# exclude inversions

# invers.bed list the three big inversions that used during filtering
#chrom chromStart  chromEnd
#1 40630000  42400000
#5 62190000  79000000
#6 30500000  43900000

vcftools --vcf /workdir/yc2644/CV_NYC_ddRAD/vcf/SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.vcf \
--exclude-bed invers.bed --recode --recode-INFO-all --out SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers 

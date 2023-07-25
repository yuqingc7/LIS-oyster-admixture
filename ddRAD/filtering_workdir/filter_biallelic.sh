#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8

# update VCF headers
# change "_" to "-" in VCF headers
bcftools reheader --samples sample_id_all_471_mod.txt \
-o SNP.DP3g95p10maf05.HWE.mod.recode.vcf \
SNP.DP3g95p10maf05.HWE.recode.vcf
# 8,263 SNPs, 22 populations, 471 individuals

# remove biallelic SNPs
/programs/plink2_linux_general_20220129/plink2 \
--vcf SNP.DP3g95p10maf05.HWE.mod.recode.vcf \
--max-alleles 2 \
--allow-extra-chr \
--make-bed \
--out SNP.DP3g95p10maf05.HWE.mod.biallelic
# 8132 variants remaining after main filters.
# Writing SNP.DP3g95p10maf05.HWE.mod.biallelic.fam ... done.
# Writing SNP.DP3g95p10maf05.HWE.mod.biallelic.bim ... done.
# Writing SNP.DP3g95p10maf05.HWE.mod.biallelic.bed ... done.
PREFIX=SNP.DP3g95p10maf05.HWE.mod.biallelic
/programs/plink-1.9-x86_20210606/plink \ # covert back to vcf
-bfile "/workdir/yc2644/CV_NYC_ddRAD/vcf/"$PREFIX \
--recode vcf \
--allow-extra-chr \
--set-missing-var-ids @:# \
--out "/workdir/yc2644/CV_NYC_ddRAD/vcf/"$PREFIX

# update VCF headers again
# change "_" to "-" in VCF headers
bcftools reheader --samples sample_id_all_471_mod.txt \
-o SNP.DP3g95p10maf05.HWE.mod.biallelic.recode.vcf \
SNP.DP3g95p10maf05.HWE.mod.biallelic.vcf
# 8,132S SNPs, 21 populations, 396 individuals

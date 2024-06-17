setwd("/local/workdir/yc2644/CV_NYC_ddRAD/diversity")

library(tidyverse)
library(MASS)
#install_github("jgx65/hierfstat")
library("hierfstat")
library(gaston,quietly=TRUE)
library("adegenet")
library(vcfR)

# import VCF files and convert to genind
filename <- "SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396.n380_refil.recode.vcf"
filepath <- paste0("/local/workdir/yc2644/CV_NYC_ddRAD/vcf/", filename)
all_vcf <- read.vcfR(filepath, verbose = FALSE)
all_genind <- vcfR2genind(all_vcf)

filename <- "SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.recode.vcf"
filepath <- paste0("/local/workdir/yc2644/CV_NYC_ddRAD/vcf/", filename)
pruned_vcf <- read.vcfR(filepath, verbose = FALSE)
pruned_genind <- vcfR2genind(pruned_vcf)

# load population information
pop_info <- read_delim("../structure/indfile_n380_all_strata.txt", delim="\t", col_names = F) %>% 
  dplyr::rename(ind=X1, pop=X2, locat=X3, grp=X4, stage=X5, yr=X6)
pop_info$pop = factor(pop_info$pop)
pop_info$locat = factor(pop_info$locat)
pop_info$grp = factor(pop_info$grp)
pop_info$stage = factor(pop_info$stage)
pop_info$yr = factor(pop_info$yr)


# basic stats -------------------------------------------------------------

all_genind@pop <- pop_info$pop
#all_genind@pop <- pop_info$locat
all_genind

# Estimates allelic richness, the rarefied allelic counts, per locus and population
Arich <- allelic.richness(all_genind,min.n=NULL,diploid=TRUE)
ind_mean <- colMeans(x=Arich$Ar, na.rm = TRUE)
# write.table(ind_mean, file = "individual.allelic.richness.txt", sep = "\t", quote = FALSE,
#             row.names = T, col.names = F)

wilcox.test(c(ind_mean[1],ind_mean[4:19]),ind_mean[2:3], alternative = "greater")
mean(c(ind_mean[1],ind_mean[4:19]))
mean(ind_mean[2:3])

# `basic.stats` (it calculates $H_O$, $H_S$, $F_{IS}$, $F_{ST}$ etc...)
basicstat <- basic.stats(all_genind, diploid = TRUE, digits = 2)
names(basicstat)
basicstat$overall

# mean Ho per population
Ho <- colMeans(x=basicstat$Ho, na.rm = TRUE)
# write.table(Ho, file = "pop.Ho.txt", sep = "\t", quote = FALSE,
#             row.names = T, col.names = F)
wilcox.test(c(Ho[1],Ho[4:19]),Ho[2:3], alternative = "two.sided")
mean(c(Ho[1],Ho[4:19]))
mean(Ho[2:3])


# mean He per population
He <- colMeans(x=basicstat$Hs, na.rm = TRUE)
# write.table(He, file = "pop.He.txt", sep = "\t", quote = FALSE,
#             row.names = T, col.names = F)
wilcox.test(c(He[1],He[4:19]),He[2:3], alternative = "greater")
mean(c(He[1],He[4:19]))
mean(He[2:3])

plot(x=ind_mean,y=He)

# mean Fis per population
Fis <- colMeans(x=basicstat$Fis, na.rm = TRUE)
# write.table(Fis, file = "pop.Fis.txt", sep = "\t", quote = FALSE,
#             row.names = T, col.names = F)
wilcox.test(c(Fis[1],Fis[4:19]),Fis[2:3], alternative = "greater")
mean(c(Fis[1],Fis[4:19]))
mean(Fis[2:3])

Fis_ci <- boot.ppfis(all_genind)$fis.ci

wilcox.test(Fis[6:8],Fis[4:5], alternative = "greater")

wilcox.test(Fis[16:17],Fis[14:15], alternative = "greater")


# Functions beta.dosage give estimates of individual inbreeding coefficients
# and kinships between individuals
# convert to a dosage format via fstat2dos
all_genind.dos <- fstat2dos(all_genind) #converts fstat format to dosage 
fis.all <- fis.dosage(all_genind.dos, pop=all_genind@pop) 
beta.dos.all <- beta.dosage(all_genind.dos)
# By default (inb=TRUE) the inbreeding coefficient 
# is returned on the main diagonal.
indF.all <- pop_info %>% mutate(indF = diag(beta.dos.all))
write.table(indF.all, file = "indF.all.txt", sep = "\t", quote = FALSE,
            row.names = F, col.names = T)

indF.all <- read.table("indF.all.txt", header=T)

indF.all %>% 
  dplyr::group_by(pop) %>% 
  dplyr::summarise(average=mean(indF))

# Fst -------------------------------------------------------------

pruned_genind@pop <- pop_info$pop
pruned_genind
# Weir and Cockerham's estimate
wc(pruned_genind)
#$FST
#[1] 0.01406976
#$FIS
#[1] 0.1082749

# Pairwise Fst
fst_pruned <- genet.dist(pruned_genind, method = "WC84") 
write.matrix(fst_pruned, file = "pairwise.pruned.fst.txt", sep = "\t")

# AMOVA -------------------------------------------------------------
library(poppr)

# strata(pruned_genind) <- pop_info
# pruned_genind
# amova.result <- poppr.amova(pruned_genind, ~grp/locat, nperm=999)
# amova.test <- randtest(amova.result,nrepet = 999) # Test for significance


filename <- "SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.n196_HH_SV.recode.vcf"
filepath <- paste0("/local/workdir/yc2644/CV_NYC_ddRAD/vcf/", filename)
subset_pruned_vcf <- read.vcfR(filepath, verbose = FALSE)
subset_pruned_genind <- vcfR2genind(subset_pruned_vcf)

subset_pop_info <- read_delim("../structure/indfile_n196_all_strata.txt", delim="\t", col_names = F) %>% 
  dplyr::rename(ind=X1, pop=X2, locat=X3, grp=X4, stage=X5, yr=X6)
subset_pop_info$pop = factor(subset_pop_info$pop)
subset_pop_info$locat = factor(subset_pop_info$locat)
subset_pop_info$grp = factor(subset_pop_info$grp)
subset_pop_info$stage = factor(subset_pop_info$stage)
subset_pop_info$yr = factor(subset_pop_info$yr)

strata(subset_pruned_genind) <- subset_pop_info
subset_pruned_genind
amova.result1 <- poppr.amova(subset_pruned_genind, ~locat/yr, nperm=999)
amova.test1 <- randtest(amova.result1,nrepet = 999) # Test for significance

amova.result2 <- poppr.amova(subset_pruned_genind, ~stage/yr, nperm=999)
amova.test2 <- randtest(amova.result2,nrepet = 999) # Test for significance

amova.result3 <- poppr.amova(subset_pruned_genind, ~locat/stage, nperm=999)
amova.test3 <- randtest(amova.result3,nrepet = 999) # Test for significance

amova.result4 <- poppr.amova(subset_pruned_genind, ~yr/stage, nperm=999)
amova.test4 <- randtest(amova.result4,nrepet = 999) # Test for significance

# We expect variations within samples to give the greatest amount of variation for populations that are not significantly differentiated. 
# Sigma represents the variance, σ, for each hierarchical level and 
# to the right is the percent of the total.
# $statphi provides the ϕ, population differentiation statistics. 
# These are used to test hypotheses about population differentiation. 
# We would expect a higher ϕ
# statistic to represent a higher amount of differentiation.

# subset Fst -------------------------------------------------------------
subset_pruned_genind

subset_pop_info <- subset_pop_info %>% mutate(stage_yr=paste(stage, yr, sep = "_"))
table(subset_pop_info$stage_yr)
subset_pop_info$stage_yr = factor(subset_pop_info$stage_yr)

subset_pruned_genind@pop <- subset_pop_info$stage_yr
subset_pruned_genind@pop <- subset_pop_info$yr
subset_pruned_genind@pop <- subset_pop_info$stage

subset_pruned_genind
# Weir and Cockerham's estimate
wc(subset_pruned_genind)
# $FST
# [1] 0.0004552227
# $FIS
# [1] 0.1174404

# Pairwise Fst
fst_pruned_subset <- genet.dist(subset_pruned_genind, method = "WC84") 


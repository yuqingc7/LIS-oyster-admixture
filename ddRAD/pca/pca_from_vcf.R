# setwd("/local/workdir/yc2644/CV_NYC_ddRAD/pca")
setwd("~/Github/LIS-oyster-admixture/ddRAD/pca")

# see https://github.com/clairemerot/Intro2PopGenomics/blob/master/3.2.3/PCA/script_PCA_from_vcf.R for original code
# if (!require("BiocManager", quietly = TRUE))
# install.packages("BiocManager")
# BiocManager::install("SNPRelate")
library(gdsfmt)
library(SNPRelate) # if there is something wrong with gfortran see link here https://thecoatlessprofessor.com/programming/cpp/rcpp-rcpparmadillo-and-os-x-mavericks-lgfortran-and-lquadmath-error/

####################
# Examine the data #
####################
# check the sample id
# create sample id file by extracting the samples from vcf file
# bcftools query -l SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.vcf > sample_id_all_exGRV_relfil_380_mod.txt
file1 = "../vcf/sample_id_all_exGRV_relfil_380_mod.txt"
dat1 = read.delim(file1, header = FALSE, sep='\t')
# count how many sample in the vcf 
paste0("number of samples in the vcf file is ", length(dat1$V1))
# check the sample id
head(dat1$V1)

####################
#     PCA plots    #
####################

# for samples n=380---------------------------------

# vcf
vcf.fn <- "../vcf/SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.recode.vcf"
# VCF => GDS
snpgdsVCF2GDS(vcf.fn, "SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.recode.gds", method="biallelic.only")
# summary
snpgdsSummary("SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.recode.gds")
# Open the GDS file
genofile <- snpgdsOpen("SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.recode.gds")

pca <- snpgdsPCA(genofile,autosome.only=FALSE)
pc.percent <- pca$varprop*100
head(round(pc.percent, 2))
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  EV3 = pca$eigenvect[,3],    # the second eigenvector
                  EV4 = pca$eigenvect[,4],    # the second eigenvector
                  stringsAsFactors = FALSE)

require(tidyverse)
meta <- read_tsv("../sample_lists/popmap_mod", col_names = F)
names(meta)[1] <- "sample.id"
names(meta)[2] <- "pop"
meta
length(sort(unique(meta$pop))) # 22 populations

dim(meta); dim(tab)
tab_meta <- right_join(meta, tab, by="sample.id") %>% 
  mutate(grp = ifelse(grepl("FI", pop), "Aquaculture", 
                      ifelse(grepl("HH|IRV|PM|PRA|TPZ", pop), "Hudson River", "East River")))

dim(tab_meta)
tab_meta
length(sort(unique(tab_meta$pop))) # 19 populations

# palette <- c('#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080', '#000000')

ggplot(tab_meta, aes(x = EV1, y = EV2)) + 
  geom_point(size=2, aes(color=grp, shape=grp))+
  # geom_mark_ellipse(aes(color = grp
  #                       ),
  #                   expand = unit(0,"mm"),
  #                   label.buffer = unit(0, 'mm'),
  #                   show.legend = F
  # ) +
  scale_colour_manual(values=c("#8DA0CB", "#FC8D62","#66C2A5"), name = "Population", 
                      labels = c("Aquaculture", "Native (East River)", "Native (Hudson River)")) +
  scale_shape_manual(values=c(17, 4, 4), name = "Population", 
                     labels = c("Aquaculture", "Native (East River)", "Native (Hudson River)")) +
  scale_x_continuous(paste("PC1 (",round(pc.percent[1],3),"%", ")",sep="")) + 
  scale_y_continuous(paste("PC2 (",round(pc.percent[2],3),"%",")",sep=""))+ 
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(axis.text=element_text(size=12),
        text = element_text(size=18,family="Times"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_rect(colour = "black", size=0.5))
# export: 8 x 6 inches


